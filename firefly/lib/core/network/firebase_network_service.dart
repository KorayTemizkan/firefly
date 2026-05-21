import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ! Bağlantı ve ağ yönetimi servis katmanı
// Kullanıcılar arası arkadaşlık/bağlantı isteklerini, kabul/ret süreçlerini ve sohbet odası oluşumlarını yönetir
mixin FirebaseNetworkService {
  // ! İSTEK AT
  // Hedef kullanıcıya yeni bir bağlantı isteği gönderir ve Firestore'da kaydeder
  Future<void> sendConnectionRequest({
    required String targetUserId,
    required String senderUsername,
    required String senderEmail,
    required String receiverUsername,
  }) async {
    // ! Mevcut kullanıcının bilgilerini al
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    // ! İki ID'den benzersiz bir istek doküman ID'si oluşturuyoruz
    final requestId = '${currentUserId}_$targetUserId';

    // ! Bağlantı istekleri koleksiyonuna ilgili bilgileri ekliyoruz
    await FirebaseFirestore.instance
        .collection('connection_requests')
        .doc(requestId)
        .set({
          'fromId': currentUserId,
          'toId': targetUserId,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'senderUsername': senderUsername,
          'senderEmail': senderEmail,
          'receiverUsername': receiverUsername,
        });
  }

  // Veri tabanında aynı anda birbirine bağlı birden fazla dökümanı güncelliyorsan veya siliyorsan Batch (veya Transaction) şart.

  // ! İSTEĞİ KABUL ET
  // İsteği 'accepted' durumuna günceller ve taraflar arasında yeni bir sohbet odası oluşturur
  Future<void> acceptRequest({
    required String requestId,
    required String userA, // İsteği Gönderen (fromId)
    required String userB, // İsteği Kabul Eden (toId - yani mevcut kullanıcı)
    required String userAName, // İsteği gönderenin kullanıcı adı
    required String userBName, // İsteği kabul edenin kullanıcı adı
  }) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    // ! İsteği accepted yap (Listeden otomatik düşer)
    batch.update(firestore.collection('connection_requests').doc(requestId), {
      'status': 'accepted',
    });

    // ! Chat odası ID'si üret
    List<String> ids = [userA, userB];
    ids.sort();
    String chatId = ids.join('_');

    // ! Sohbet odasını oluştur
    batch.set(firestore.collection('chats').doc(chatId), {
      'chatId': chatId,
      'participants': [userA, userB],
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': 'Bağlantı kuruldu!',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'usernames': {userA: userAName, userB: userBName},
    });

    // ! İşlemleri atomik olarak gerçekleştir
    await batch.commit();
  }

  // ! İSTEĞİ REDDET
  // İsteğin durumunu 'rejected' olarak günceller
  Future<void> rejectRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection('connection_requests')
        .doc(requestId)
        .update({'status': 'rejected'});
  }

  // ! İSTEĞİ İPTAL ET
  // Gönderilen isteği Firestore'dan tamamen siler
  Future<void> cancelRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection('connection_requests')
        .doc(requestId)
        .delete();
  }
}
