import 'package:auto_route/auto_route.dart';
import 'package:example_messaging/config/routes/app_router.gr.dart';
import 'package:example_messaging/core/network/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

// ! Kimlik Doğrulama Sayfası
// Kullanıcıların giriş yapmasını veya yeni hesap oluşturmasını sağlayan arayüz
@RoutePage()
class AuthPage extends StatelessWidget with FirebaseAuthService {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Şimdilik sadece email sağlayıcısını tanımladık
    final providers = [EmailAuthProvider()];

    // ! Başarılı giriş sonrası yönlendirme
    void onSignedIn() {
      context.router.replace(const CustomBottomBar());
    }

    return SignInScreen(
      providers: providers,
      actions: [
        // ! Kayıt durumu
        // Yeni bir kullanıcı oluşturulduğunda verilerini Firestore'a kaydet ve ana sayfaya yönlendir
        AuthStateChangeAction<UserCreated>((context, state) async {
          await saveUserToFirestore(state);
          onSignedIn();
        }),
        // ! Giriş durumu
        // Mevcut kullanıcı başarıyla giriş yaptığında ana sayfaya yönlendir
        AuthStateChangeAction<SignedIn>((context, state) {
          onSignedIn();
        }),
      ],
    );
  }
}
