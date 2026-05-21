import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_messaging/core/network/firebase_network_service.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:example_messaging/injection_container.dart';

// ! Bekleyen Bağlantı İstekleri Bölümü
// Kullanıcıya gelen ve henüz onaylanmamış bağlantı isteklerini listeler ve işlem yapmasını sağlar
class PendingRequestsSection extends StatelessWidget
    with FirebaseNetworkService {
  const PendingRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // ! Firestore sorgumuzu oluşturuyoruz. Bağlantılar koleksiyonundan bize gelen istekleri tarihe göre sıralıyoruz.
    final requestsQuery = FirebaseFirestore.instance
        .collection('connection_requests')
        .where('toId', isEqualTo: currentUid)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true);

    return Expanded(
      // ! Firestore UI paketini kullanıyoruz. ListView.builder'ın yamalanmış hali
      child: FirestoreListView<Map<String, dynamic>>(
        scrollDirection: Axis.vertical,
        query: requestsQuery,
        pageSize: 20, // Her kaydırmada 20'şer veri çek.
        errorBuilder: (context, error, stackTrace) =>
            Text('Hata oluştu: $error'),
        loadingBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
        emptyBuilder: (context) =>
            const Center(child: Text('Hiç kullanıcı bulunamadı.')),
        itemBuilder: (context, doc) {
          // ! doc.data() ile doğrudan Firestore dökümanına erişiyoruz ve gönderen kullanıcının bilgilerini çekiyoruz
          final requestData = doc.data();
          final requestId = doc.id;

          final senderId = requestData['fromId'];
          final senderUsername =
              requestData['senderUsername'] ?? 'Bilinmeyen Kullanıcı';
          final status = requestData['status'] ?? '';

          // ! Liste elemanı tasarımı
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(senderUsername),
            subtitle: Text(status),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ! KABUL ET BUTONU
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () => acceptRequest(
                    requestId: requestId,
                    userA: senderId,
                    userB: currentUid,
                    userAName: senderUsername,
                    userBName: currentUsername,
                  ),
                ),
                // ! REDDET BUTONU
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => rejectRequest(requestId),
                ),
              ],
            ),
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
