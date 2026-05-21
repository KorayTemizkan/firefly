import 'package:auto_route/auto_route.dart';
import 'package:example_messaging/core/utils/get_message_builders.dart';
import 'package:example_messaging/core/widgets/custom_appbar.dart';
import 'package:example_messaging/features/chat/presentation/pages/chat_page_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// ! Sohbet Sayfası
// Belirli bir sohbet odasındaki mesajları görüntüleyen ve gönderim işlemlerini yöneten arayüz
@RoutePage()
class ChatPage extends StatefulWidget {
  // ! Bir sohbet odasının id'si ve karşı eşleşilen karşı tarafın kullanıcı adı getirilir
  final String chatId;
  final String peerName;

  const ChatPage({super.key, required this.peerName, required this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with ChatPageMixin {
  @override
  void initState() {
    super.initState();
    // ! Sohbet servisini başlat
    chatService.initialize(widget.chatId);
  }

  @override
  void dispose() {
    // ! Servis kaynaklarını serbest bırak
    chatService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Chat(
          onAttachmentTap: () {
            handleAttachmentPressed();
          },
          chatController: chatService.chatController,
          currentUserId: currentUserId,
          // ! Metin, gönderen kullanıcının id'si ve sohbet id'si gönderilir
          onMessageSend: (text) {
            chatService.sendMessage(text, currentUserId, widget.chatId);
          },
          // ! Kullanıcı çözümleme
          // Mesajların kime ait olduğunu belirleyerek UI'da doğru isimlerin görünmesini sağlar
          resolveUser: (String id) async {
            return User(
              id: id,
              name: id == currentUserId ? currentUserName : widget.peerName,
            );
          },

          // ! Mesaj oluşturucular
          // Görsel veya dosya gibi farklı mesaj tiplerini render eden yardımcılar
          builders: getMessageBuilders(
            chatController: chatService.chatController,
          ),
        ),
      ),
    );
  }
}
