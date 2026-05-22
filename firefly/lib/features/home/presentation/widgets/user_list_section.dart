import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_messaging/core/constants/firebase_constants.dart';
import 'package:example_messaging/core/constants/home_constants.dart';
import 'package:example_messaging/core/network/firebase_network_service.dart';
import 'package:example_messaging/injection_container.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

// ! Kullanıcı Listesi Bölümü
// Firestore'daki kullanıcıları arama özelliği ile birlikte listeleyen ve bağlantı isteği gönderilmesini sağlayan bölüm
class UserListSection extends StatefulWidget {
  const UserListSection({super.key});

  @override
  State<UserListSection> createState() => _UserListSectionState();
}

class _UserListSectionState extends State<UserListSection>
    with FirebaseNetworkService {
  String _searchText = '';

  // ! Dinamik sorgu oluşturma aracımız
  Query<Map<String, dynamic>> _buildQuery() {
    final baseQuery = FirebaseFirestore.instance
        .collection(FirebaseConstants.usersCollection)
        .orderBy(FirebaseConstants.usernameField);

    if (_searchText.isEmpty) {
      return baseQuery;
    }
    // * Firestore'da başlangıç harflerine göre arama (Prefix Search) yapma taktiği
    return baseQuery
        .where(
          FirebaseConstants.usernameField,
          isGreaterThanOrEqualTo: _searchText,
        )
        .where(
          FirebaseConstants.usernameField,
          isLessThanOrEqualTo: '$_searchText\uf8ff',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // ! Arama Çubuğu
          _customTextField(),
          _customFirestoreListView(),
        ],
      ),
    );
  }

  // ! Kullanıcı listesi görünümü
  Expanded _customFirestoreListView() {
    return Expanded(
      child: FirestoreListView<Map<String, dynamic>>(
        scrollDirection: Axis.vertical,
        query: _buildQuery(),
        pageSize: 20,
        errorBuilder: (context, error, stackTrace) =>
            Text('${FirebaseConstants.errorMessagePrefix}$error'),
        loadingBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
        emptyBuilder: (context) =>
            const Center(child: Text(HomeConstants.noUserFound)),
        itemBuilder: (context, doc) {
          final userData = doc.data();
          final targetUserId = doc.id;

          // ! Kendimiz gözükmeyelim
          if (targetUserId == currentUid) {
            return const SizedBox.shrink();
          }

          final targetUsername =
              userData[FirebaseConstants.usernameField] ??
              HomeConstants.unknownUser;
          final targetUserEmail = userData[FirebaseConstants.emailField] ?? '';

          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(targetUsername),
            subtitle: Text(targetUserEmail),
            trailing: IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () async {
                // ! Bağlantı isteği gönder
                await sendConnectionRequest(
                  targetUserId: targetUserId,
                  senderUsername: currentUsername,
                  senderEmail: currentEmail,
                  receiverUsername: targetUsername,
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ! Arama girdisi alanı
  TextField _customTextField() {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Kullanıcı adı ara...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          _searchText = value;
        });
      },
    );
  }
}
