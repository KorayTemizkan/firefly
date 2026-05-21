import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flyer_chat_file_message/flyer_chat_file_message.dart';
import 'package:flyer_chat_image_message/flyer_chat_image_message.dart';
import 'package:flyer_chat_system_message/flyer_chat_system_message.dart';
import 'package:flyer_chat_text_message/flyer_chat_text_message.dart';

Builders getMessageBuilders({required ChatController chatController}) {
  return Builders(
    // ! Düz metin mesajı oluşturucu
    textMessageBuilder:
        (
          context,
          message,
          index, {
          required bool isSentByMe,
          MessageGroupStatus? groupStatus,
        }) => FlyerChatTextMessage(message: message, index: index),

    // ! Bağlantı mesajı oluşturucu
    linkPreviewBuilder: (context, message, isSentByMe) {
      return LinkPreview(
        text: message.text,
        linkPreviewData: message.linkPreviewData,
        onLinkPreviewDataFetched: (linkPreviewData) {
          chatController.updateMessage(
            message,
            message.copyWith(linkPreviewData: linkPreviewData),
          );
        },
        parentContent: message.text,
      );
    },

    // ! Sistem mesajı oluşturucu
    systemMessageBuilder:
        (
          context,
          message,
          index, {
          required bool isSentByMe,
          MessageGroupStatus? groupStatus,
        }) => FlyerChatSystemMessage(message: message, index: index),

    // ! Görsel mesajı oluşturucu
    imageMessageBuilder:
        (
          context,
          message,
          index, {
          required bool isSentByMe,
          MessageGroupStatus? groupStatus,
        }) => FlyerChatImageMessage(
          message: message,
          index: index,
          constraints: const BoxConstraints(maxHeight: 200, maxWidth: 200),
        ),

    // ! Dosya mesajı oluşturucu
    fileMessageBuilder:
        (
          context,
          message,
          index, {
          required bool isSentByMe,
          MessageGroupStatus? groupStatus,
        }) {
          return FlyerChatFileMessage(message: message, index: index);
        },
  );
}
