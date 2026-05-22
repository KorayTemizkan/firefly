// TODO: İşlev Dışı (düzenlenecek)

import 'package:example_messaging/core/constants/system_constants.dart';
import 'package:example_messaging/core/network/firebase_ai_service.dart';
import 'package:example_messaging/features/ai/presentation/pages/ai_page.dart';
import 'package:example_messaging/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ! Yapay Zeka Sayfa Mantığı (Mixin)
// Sohbet sayfasıyla ilgili kullanıcı bilgilerini, servis yönetimini ve etkileşim fonksiyonlarını barındırır
mixin AiPageMixin on State<AiPage> {
  // Bu mixin sadece ChatPage'in State'i üzerinde çalışabilir,
  // böylece 'context' ve 'setState' gibi özelliklere doğrudan erişir.
  final FirebaseAiService aiService = sl<FirebaseAiService>();
  final FirebaseAuth _auth = sl<FirebaseAuth>();

  // Aktif kullanıcının ID ve İsim bilgilerini alıyoruz
  String get currentUserId => _auth.currentUser?.uid ?? SystemConstants.unknownUser;
  String get currentUserName =>
      _auth.currentUser?.displayName ?? _auth.currentUser?.email ?? SystemConstants.me;

  // Fonksiyonu build metodundan tamamen kopardık
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
                /*
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    chatService.handleImageSelection(currentUserId);
                  },
                  child: const Text('Görsel Seçici'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    chatService.handleFileSelection(currentUserId);
                  },
                  child: const Text('Dosya Seçici'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // handleVoiceSender();
                  },
                  child: const Text('Ses Kaydı Gönder'),
                ),
                */
              ],
            ),
          ),
        );
      },
    );
  }
}
