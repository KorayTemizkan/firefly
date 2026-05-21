// https://firebase.google.com/docs/ai-logic/get-started?platform=flutter&api=dev#prereqs

import 'package:auto_route/auto_route.dart';
import 'package:example_messaging/core/utils/get_message_builders.dart';
import 'package:example_messaging/core/widgets/custom_appbar.dart';
import 'package:example_messaging/features/ai/presentation/pages/ai_page_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// ! Yapay Zeka (AI) Sohbet Sayfası
// Gemini entegrasyonu ile kullanıcıya asistanlık eden sohbet arayüzü
@RoutePage()
class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<AiPage> with AiPageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      // ! Chat Arayüzü Bileşeni
      // flutter_chat_ui kütüphanesi ile özelleştirilmiş mesajlaşma deneyimi
      body: Chat(
        onAttachmentTap: () {
          handleAttachmentPressed();
        },
        currentUserId: currentUserId,
        chatController: aiService.chatController,
        onMessageSend: (text) => aiService.askAI(text, currentUserId),
        // ! Kullanıcı çözümleme
        // Mesajın kimden geldiğini ayırt eden (Kullanıcı vs Gemini) yardımcı metot
        resolveUser: (String id) async {
          if (id == currentUserId) {
            return User(id: id, name: currentUserName);
          } else {
            return const User(id: 'gemini_bot', name: 'Gemini Asistan');
          }
        },

        // Görsel gelmesi durumunda build edilecek
        // Mesaj tiplerini görselleştirme için kullanılan özelleştirilmiş builder'lar
        builders: getMessageBuilders(chatController: aiService.chatController),
      ),
    );
  }
}
