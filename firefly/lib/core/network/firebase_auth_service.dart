import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_messaging/core/constants/firebase_constants.dart';
import 'package:example_messaging/core/constants/system_constants.dart';

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
        await FirebaseFirestore.instance.collection(SystemConstants.user).doc(user.uid).set({
        FirebaseConstants.uidField: user.uid,
          FirebaseConstants.emailField: user.email,
          FirebaseConstants.usernameField: user.email != null
              ? user.email!.split(SystemConstants.atSign)[0]
              : '${FirebaseConstants.defaultUsernamePrefix}${user.uid.substring(0, 5)}',
          FirebaseConstants.createdAtField: FieldValue.serverTimestamp(),
        });
        print(
          FirebaseConstants.successMessage,
        );
      } catch (e) {
        print("${FirebaseConstants.errorMessagePrefix} $e");
      }
    }
  }
}
