import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:example_messaging/config/routes/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:example_messaging/injection_container.dart';

// ! Aktif Sohbetler Bölümü
// Firestore'dan gerçek zamanlı olarak aktif sohbet odalarını listeler
class ActiveChatsSection extends StatelessWidget {
  const ActiveChatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // ! participants dizisinde benim ID'm olan tüm sohbet odalarını zamana göre getir.
    final chatsQuery = FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUid)
        .orderBy('lastMessageTime', descending: true);

    return Expanded(
      // ! Firestore UI paketini kullanıyoruz. ListView.builder'ın yamalanmış hali
      child: FirestoreListView<Map<String, dynamic>>(
        scrollDirection: Axis.vertical,
        query: chatsQuery,
        pageSize: 20, // Her kaydırmada 20'şer veri çek.
        errorBuilder: (context, error, stackTrace) =>
            Text('Hata oluştu: $error'),
        loadingBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
        emptyBuilder: (context) =>
            const Center(child: Text('Hiç kullanıcı bulunamadı.')),
        itemBuilder: (context, doc) {
          // ! doc.data() ile doğrudan Firestore dökümanına erişiyoruz ve sohbet odasının bilgilerini çekiyoruz
          final chatData = doc.data();
          final chatId = chatData['chatId'];

          // ! Odadaki map yapısından karşı tarafın kullanıcı bilgisini ayıklıyoruz
          final usernames =
              chatData['usernames'] as Map<String, dynamic>? ?? {};

          // ! Map içinden benim ID'm olmayan ilk anahtarı (karşı tarafınkini) buluyoruz
          final peerId = usernames.keys.firstWhere(
            (key) => key != currentUid,
            orElse: () => '',
          );
          final peerName = usernames[peerId] ?? 'Sohbet Odası';
          final lastMessage = chatData['lastMessage'] ?? '';

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

/*
FirestoreListView senin yerine:

    Koleksiyonu kesintisiz (Stream/Live) olarak dinler.

    Sadece değişen dökümanları tespit edip arayüze yansıtır.

    Üstelik bunu yaparken sayfalama (pagination) mantığını da bozmaz (sen aşağı kaydırdıkça sonraki 20'yi çekmeye devam eder ama canlılığı korur).
*/
