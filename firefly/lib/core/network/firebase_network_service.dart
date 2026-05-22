import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:example_messaging/core/constants/firebase_constants.dart';

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
        .collection(FirebaseConstants.connectionRequestsCollection)
        .doc(requestId)
        .set({
          FirebaseConstants.fromIdField: currentUserId,
          FirebaseConstants.toIdField: targetUserId,
          FirebaseConstants.statusField: FirebaseConstants.statusPending,
          FirebaseConstants.createdAtField: FieldValue.serverTimestamp(),
          FirebaseConstants.senderUsernameField: senderUsername,
          FirebaseConstants.senderEmailField: senderEmail,
          FirebaseConstants.receiverUsernameField: receiverUsername,
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
    batch.update(
      firestore
          .collection(FirebaseConstants.connectionRequestsCollection)
          .doc(requestId),
      {FirebaseConstants.statusField: FirebaseConstants.statusAccepted},
    );

    // ! Chat odası ID'si üret
    List<String> ids = [userA, userB];
    ids.sort();
    String chatId = ids.join('_');

    // ! Sohbet odasını oluştur
    batch.set(
      firestore.collection(FirebaseConstants.chatsCollection).doc(chatId),
      {
        'chatId': chatId,
        FirebaseConstants.participantsField: [userA, userB],
        FirebaseConstants.createdAtField: FieldValue.serverTimestamp(),
        FirebaseConstants.lastMessageField:
            FirebaseConstants.connectionEstablishedMessage,
        FirebaseConstants.lastMessageTimeField: FieldValue.serverTimestamp(),
        FirebaseConstants.usernamesField: {userA: userAName, userB: userBName},
      },
    );

    // ! İşlemleri atomik olarak gerçekleştir
    await batch.commit();
  }

  // ! İSTEĞİ REDDET
  // İsteğin durumunu 'rejected' olarak günceller
  Future<void> rejectRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection(FirebaseConstants.connectionRequestsCollection)
        .doc(requestId)
        .update({
          FirebaseConstants.statusField: FirebaseConstants.statusRejected,
        });
  }

  // ! İSTEĞİ İPTAL ET
  // Gönderilen isteği Firestore'dan tamamen siler
  Future<void> cancelRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection(FirebaseConstants.connectionRequestsCollection)
        .doc(requestId)
        .delete();
  }
}
