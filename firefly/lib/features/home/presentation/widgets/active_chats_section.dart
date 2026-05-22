import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_messaging/injection_container.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:example_messaging/config/routes/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:example_messaging/core/constants/home_constants.dart'; // Import eklendi

// ! Aktif Sohbetler Bölümü
// Firestore'dan gerçek zamanlı olarak aktif sohbet odalarını listeler
class ActiveChatsSection extends StatelessWidget {
  const ActiveChatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // ! participants dizisinde benim ID'm olan tüm sohbet odalarını zamana göre getir.
    final chatsQuery = FirebaseFirestore.instance
        .collection(HomeConstants.chatsCollection)
        .where(HomeConstants.participantsField, arrayContains: currentUid)
        .orderBy(HomeConstants.lastMessageTimeField, descending: true);

    return Expanded(
      // ! Firestore UI paketini kullanıyoruz. ListView.builder'ın yamalanmış hali
      child: FirestoreListView<Map<String, dynamic>>(
        scrollDirection: Axis.vertical,
        query: chatsQuery,
        pageSize: 20, // Her kaydırmada 20'şer veri çek.
        errorBuilder: (context, error, stackTrace) =>
            Text('${HomeConstants.errorMessagePrefix}$error'),
        loadingBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
        emptyBuilder: (context) =>
            const Center(child: Text(HomeConstants.emptyListMessage)),
        itemBuilder: (context, doc) {
          // ! doc.data() ile doğrudan Firestore dökümanına erişiyoruz ve sohbet odasının bilgilerini çekiyoruz
          final chatData = doc.data();
          final chatId = chatData[HomeConstants.chatIdField];

          // ! Odadaki map yapısından karşı tarafın kullanıcı bilgisini ayıklıyoruz
          final usernames =
              chatData[HomeConstants.usernamesField] as Map<String, dynamic>? ??
              {};

          // ! Map içinden benim ID'm olmayan ilk anahtarı (karşı tarafınkini) buluyoruz
          final peerId = usernames.keys.firstWhere(
            (key) => key != currentUid,
            orElse: () => '',
          );
          final peerName = usernames[peerId] ?? HomeConstants.defaultChatName;
          final lastMessage = chatData[HomeConstants.lastMessageField] ?? '';

          // ! Liste elemanı tasarımı
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.chat_bubble)),
            title: Text(peerName),
            subtitle: Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // ! Tıklanıldığında o sohbete git
            onTap: () {
              context.router.push(
                ChatRoute(chatId: chatId, peerName: peerName),
              );
            },
          );
        },
      ),
    );
  }
}
