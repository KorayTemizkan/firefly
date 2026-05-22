import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_messaging/core/network/firebase_network_service.dart';
import 'package:example_messaging/core/constants/firebase_constants.dart';
import 'package:example_messaging/core/constants/home_constants.dart';
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
    // ! Firestore sorgumuzu oluşturuyoruz.
    final requestsQuery = FirebaseFirestore.instance
        .collection(FirebaseConstants.connectionRequestsCollection)
        .where(FirebaseConstants.toIdField, isEqualTo: currentUid)
        .where(
          FirebaseConstants.statusField,
          isEqualTo: FirebaseConstants.statusPending,
        )
        .orderBy(FirebaseConstants.createdAtField, descending: true);

    return Expanded(
      child: FirestoreListView<Map<String, dynamic>>(
        scrollDirection: Axis.vertical,
        query: requestsQuery,
        pageSize: 20,
        errorBuilder: (context, error, stackTrace) =>
            Text('${FirebaseConstants.errorMessagePrefix}$error'),
        loadingBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
        emptyBuilder: (context) =>
            const Center(child: Text(HomeConstants.noUserFound)),
        itemBuilder: (context, doc) {
          final requestData = doc.data();
          final requestId = doc.id;

          final senderId = requestData[FirebaseConstants.fromIdField];
          final senderUsername =
              requestData[FirebaseConstants.senderUsernameField] ??
              HomeConstants.unknownUser;
          final status = requestData[FirebaseConstants.statusField] ?? '';

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
