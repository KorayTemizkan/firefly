import 'package:example_messaging/core/constants/system_constants.dart';
import 'package:example_messaging/core/network/firebase_chat_service.dart';
import 'package:example_messaging/features/chat/presentation/pages/chat_page.dart';
import 'package:example_messaging/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ! Sohbet Sayfası Mantığı (Mixin)
// Sohbet sayfasıyla ilgili kullanıcı bilgilerini, servis yönetimini ve dosya paylaşım süreçlerini barındırır
mixin ChatPageMixin on State<ChatPage> {
  // Bu mixin sadece ChatPage'in State'i üzerinde çalışabilir,
  // böylece 'context', 'setState' ve 'widget' özelliklerine doğrudan erişir.
  final FirebaseChatService chatService = sl<FirebaseChatService>();
  final FirebaseAuth _auth = sl<FirebaseAuth>();

  // Aktif kullanıcının ID ve İsim bilgilerini alıyoruz
  String get currentUserId => _auth.currentUser?.uid ?? SystemConstants.unknownUser;
  String get currentUserName =>
      _auth.currentUser?.displayName ?? _auth.currentUser?.email ?? SystemConstants.me;

  // ! Ek dosya/görsel paylaşım menüsünü açar
  void handleAttachmentPressed() {
    showModalBottomSheet(
      context: context, // Mixin sayesinde 'context'e direkt erişiyoruz
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Sadece gerektiği kadar yer kaplar
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ! GÖRSEL
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // 👇 widget.chatId parametresini servise pasladık
                    chatService.handleImageSelection(
                      currentUserId,
                      widget.chatId,
                    );
                  },
                  child: const Text(SystemConstants.imagePicker),
                ),

                // ! DOSYA
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // 👇 widget.chatId parametresini servise pasladık
                    chatService.handleFileSelection(
                      currentUserId,
                      widget.chatId,
                    );
                  },
                  child: const Text(SystemConstants.filePicker),
                ),

                // ! SES
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // handleVoiceSender(); // İleride buraya da widget.chatId vermen gerekecek
                  },
                  child: const Text(SystemConstants.voicePicker),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
