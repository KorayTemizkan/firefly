import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_messaging/core/network/firebase_network_service.dart';
import 'package:example_messaging/core/constants/firebase_constants.dart';
import 'package:example_messaging/injection_container.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

// ! Gönderilen Bağlantı İstekleri Bölümü
// Kullanıcının başka kullanıcılara gönderdiği ve henüz onaylanmamış istekleri listeler
class SentRequestsSection extends StatelessWidget with FirebaseNetworkService {
  const SentRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // ! Firestore sorgumuzu oluşturuyoruz. Bağlantılar koleksiyonundan bizim gönderdiğimiz istekleri tarihe göre sıralıyoruz.
    final requestsQuery = FirebaseFirestore.instance
        .collection(FirebaseConstants.connectionRequestsCollection)
        .where(FirebaseConstants.fromIdField, isEqualTo: currentUid)
        .where(
          FirebaseConstants.statusField,
          isEqualTo: FirebaseConstants.statusPending,
        )
        .orderBy(FirebaseConstants.createdAtField, descending: true);

    return Expanded(
      // ! Firestore UI paketini kullanıyoruz.
      child: FirestoreListView<Map<String, dynamic>>(
        scrollDirection: Axis.vertical,
        query: requestsQuery,
        pageSize: 20,
        errorBuilder: (context, error, stackTrace) =>
            Text('${FirebaseConstants.errorMessagePrefix}$error'),
        loadingBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
        emptyBuilder: (context) =>
            const Center(child: Text('Henüz gönderilmiş bir istek yok.')),
        itemBuilder: (context, doc) {
          final requestData = doc.data();
          final requestId = doc.id;

          final receiverUsername =
              requestData[FirebaseConstants.receiverUsernameField] ?? '';
          final status = requestData[FirebaseConstants.statusField] ?? '';

          // ! Liste elemanı tasarımı
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(receiverUsername),
            subtitle: Text(status),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ! İPTAL ET BUTONU
                // Gönderilen isteği listeden kaldırır
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => cancelRequest(requestId),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
