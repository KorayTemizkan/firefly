import 'package:cloud_firestore/cloud_firestore.dart';

// ! Kimlik doğrulama servis mantığı
// Kullanıcı kayıt işlemlerinden sonra verileri Firestore'a senkronize eder
mixin FirebaseAuthService {
  Future<void> saveUserToFirestore(dynamic state) async {
    // ! Az önce kaydolan kullanıcıyı al
    final user = state.credential.user;

    if (user != null) {
      try {
        // ! Her ne kadar auth bölümüne kaydedilse de biz yine de Firestore'a kaydetmeliyiz.
        // ! 'users' koleksiyonuna UID'ler başlık (document ID) olacak şekilde bilgileri kaydet.
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'username': user.email != null
              ? user.email!.split('@')[0]
              : 'user_${user.uid.substring(0, 5)}',
          'createdAt': FieldValue.serverTimestamp(),
        });
        print(
          "Kullanıcı başarıyla Firestore 'users' koleksiyonuna kaydedildi!",
        );
      } catch (e) {
        print("Firestore'a kaydederken hata oluştu: $e");
      }
    }
  }
}
