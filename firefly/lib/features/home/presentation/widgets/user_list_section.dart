import 'package:example_messaging/core/network/firebase_network_service.dart';
import 'package:example_messaging/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        .collection('users')
        .orderBy('username');

    if (_searchText.isEmpty) {
      return baseQuery;
    }
    // * Firestore'da başlangıç harflerine göre arama (Prefix Search) yapma taktiği:
    // * Örn: "ahm" ile başlayan ve "ahm\uf8ff" arasındakileri getir dersek "ahmet"i bulur.
    return baseQuery
        .where('username', isGreaterThanOrEqualTo: _searchText)
        .where('username', isLessThanOrEqualTo: '$_searchText\uf8ff');
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
      // ! Firestore UI paketini kullanıyoruz. ListView.builder'ın yamalanmış hali
      child: FirestoreListView<Map<String, dynamic>>(
        scrollDirection: Axis.vertical,
        query: _buildQuery(),
        pageSize: 20, // Her kaydırmada 20'şer veri çek.
        errorBuilder: (context, error, stackTrace) =>
            Text('Hata oluştu: $error'),
        loadingBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
        emptyBuilder: (context) =>
            const Center(child: Text('Hiç kullanıcı bulunamadı.')),
        itemBuilder: (context, doc) {
          // ! doc.data() ile doğrudan Firestore dökümanına erişiyoruz ve o anki kullanıcının bilgilerini çekiyoruz
          final userData = doc.data();
          final targetUserId = doc.id;

          // ! Kendimiz gözükmeyelim
          if (targetUserId == currentUid) {
            return const SizedBox.shrink();
          }

          final targetUsername = userData['username'] ?? 'Bilinmeyen Kullanıcı';
          final targetUserEmail = userData['email'] ?? '';

          // ! Liste elemanı tasarımı
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
          _searchText = value; // * Her harf yazıldığında sorgu tetiklenecek
        });
      },
    );
  }
}

/*
FirestoreListView senin yerine:

    Koleksiyonu kesintisiz (Stream/Live) olarak dinler.

    Sadece değişen dökümanları tespit edip arayüze yansıtır.

    Üstelik bunu yaparken sayfalama (pagination) mantığını da bozmaz (sen aşağı kaydırdıkça sonraki 20'yi çekmeye devam eder ama canlılığı korur).
*/
