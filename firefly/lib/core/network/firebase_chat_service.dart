import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:example_messaging/core/constants/firebase_constants.dart';

// ! Sohbet veritabanı ve iletişim servis katmanı
// Firestore ile gerçek zamanlı sohbet akışını, medya yüklemelerini ve batch işlemlerini yönetir
class FirebaseChatService {
  // ! Bir akış başlat.
  StreamSubscription<QuerySnapshot>? _messageSubscription;

  // ! FlyerChat ayarlamaları
  InMemoryChatController _chatController = InMemoryChatController();
  InMemoryChatController get chatController => _chatController;

  // ! Artık hangi odayı dinleyeceğini biliyor
  void initialize(String chatId) {
    // Eski bir dinleme varsa garanti olsun diye iptal et
    _messageSubscription?.cancel();

    // Yeniden bir sohbet oluşturuyoruz. Her sohbete girişte süreç yeniden başlıyor.
    _chatController = InMemoryChatController();

    // Burada arka planda çalışan bir çevrimdışı özellik var. Uygulamadan çıkıp girince de gözüküyor
    _messageSubscription = FirebaseFirestore.instance
        .collection(FirebaseConstants.chatsCollection)
        .doc(chatId)
        .collection(
          FirebaseConstants.messagesCollection,
        ) // ! Odalar altındaki mesajlar alt koleksiyonu
        .orderBy(FirebaseConstants.createdAtField, descending: false)
        .limit(50)
        .snapshots()
        .listen((snapshot) {
          for (var change in snapshot.docChanges) {
            // Sunucuya yeni ekleme olursa buraya da ekle
            if (change.type == DocumentChangeType.added) {
              final data = change.doc.data() as Map<String, dynamic>;
              final message = Message.fromJson(data);
              _chatController.insertMessage(message);
            }
          }
        });
  }

  // ! Son mesajı güncellemek için ortak bir Batch/Write yardımcı fonksiyonu
  Future<void> _saveMessageAndSetLast({
    required String chatId,
    required Map<String, dynamic> messageMap, // Model yerine Map alıyoruz
    required String messageId,
    required String lastTextDisplay,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    // Yeni bir mesaj yazma
    final msgRef = firestore
        .collection(FirebaseConstants.chatsCollection)
        .doc(chatId)
        .collection(FirebaseConstants.messagesCollection)
        .doc(messageId);
    batch.set(msgRef, messageMap); // Düzenlenmiş Map doğrudan yazılıyor

    // Son mesajı düzenleme
    final chatRef = firestore
        .collection(FirebaseConstants.chatsCollection)
        .doc(chatId);
    batch.update(chatRef, {
      FirebaseConstants.lastMessageField: lastTextDisplay,
      FirebaseConstants.lastMessageTimeField: FieldValue.serverTimestamp(),
    });

    // ! İki işlemi tek seferde (Atomik olarak) yapma
    await batch.commit();
  }

  // ! String mesajı gönderme
  void sendMessage(String text, String currentUserId, String chatId) {
    // Yeni string mesajı oluşturma
    final messageId = const Uuid().v4();
    final newMessage = TextMessage(
      id: messageId,
      authorId: currentUserId,
      text: text,
      createdAt: DateTime.now().toUtc(),
    );

    final messageMap = newMessage.toJson();
    messageMap[FirebaseConstants.typeField] =
        FirebaseConstants.textType; // ! Bu bir düz metindir etiketini vurduk

    _saveMessageAndSetLast(
      chatId: chatId,
      messageMap: messageMap,
      messageId: messageId,
      lastTextDisplay: text,
    );
  }

  // ! Görsel seçme ve gönderme
  Future<void> handleImageSelection(String currentUserId, String chatId) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    // Galeriden görsel seçildi ve fonskiyona parametreler yollandı
    if (image != null) {
      await _sendImageMessage(image.path, currentUserId, chatId);
    }
  }

  Future<void> _sendImageMessage(
    String filePath,
    String currentUserId,
    String chatId,
  ) async {
    try {
      final messageId = const Uuid().v4();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child(FirebaseConstants.chatImagesPath)
          .child('$messageId.jpg');

      // decodedImage ile görselin boyutlarına erişeceğiz, downloadUrl ile de imageSource vereceğiz
      final file = File(filePath);
      final fileBytes = await file.readAsBytes();
      final ui.Image decodedImage = await decodeImageFromList(fileBytes);

      final uploadTask = await storageRef.putFile(file);
      final String downloadUrl = await uploadTask.ref.getDownloadURL();

      final message = ImageMessage(
        id: messageId,
        authorId: currentUserId,
        source: downloadUrl,
        createdAt: DateTime.now().toUtc(),
        width: decodedImage.width.toDouble(),
        height: decodedImage.height.toDouble(),
      );

      final messageMap = message.toJson();
      messageMap[FirebaseConstants.typeField] =
          FirebaseConstants.imageType; // ! Bu bir görseldir etiketini vurduk

      await _saveMessageAndSetLast(
        chatId: chatId,
        messageMap: messageMap,
        messageId: messageId,
        lastTextDisplay: FirebaseConstants.photoDisplay,
      );
    } catch (e) {
      print("${FirebaseConstants.errorMessagePrefix}: $e");
    }
  }

  // ! Dosya seçme ve gönderme
  Future<void> handleFileSelection(String currentUserId, String chatId) async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      await _sendFileMessage(result.files.first, currentUserId, chatId);
    }
  }

  Future<void> _sendFileMessage(
    PlatformFile pickedFile,
    String currentUserId,
    String chatId,
  ) async {
    try {
      final messageId = const Uuid().v4();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child(FirebaseConstants.chatFilesPath)
          .child('${messageId}_${pickedFile.name}');

      final file = File(pickedFile.path!);
      final uploadTask = await storageRef.putFile(file);
      final String downloadUrl = await uploadTask.ref.getDownloadURL();

      final message = FileMessage(
        id: messageId,
        authorId: currentUserId,
        createdAt: DateTime.now().toUtc(),
        name: pickedFile.name,
        size: pickedFile.size,
        source: downloadUrl,
      );

      final messageMap = message.toJson();
      messageMap[FirebaseConstants.typeField] =
          FirebaseConstants.fileType; // ! Bu bir belgedir etiketini vurduk

      await _saveMessageAndSetLast(
        chatId: chatId,
        messageMap: messageMap,
        messageId: messageId,
        lastTextDisplay:
            '${FirebaseConstants.fileDisplayPrefix}${pickedFile.name}',
      );
    } catch (e) {
      print("${FirebaseConstants.errorMessagePrefix}: $e");
    }
  }

  // ! Servis kaynaklarını serbest bırakma
  void dispose() {
    _messageSubscription?.cancel();
    _messageSubscription = null; // Her ihtimale karşı hafızadan da sil
    _chatController.dispose();
  }
}
