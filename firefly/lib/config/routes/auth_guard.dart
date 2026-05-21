import 'package:auto_route/auto_route.dart';
import 'package:example_messaging/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:example_messaging/config/routes/app_router.gr.dart';

// ! Kimlik doğrulama koruma katmanı
// Kullanıcının oturum durumuna göre erişimini yöneten güvenlik bariyeri
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    // ! Servis konumlandırıcıdan (Service Locator) mevcut kullanıcı oturumunu al
    final currentUser = sl<FirebaseAuth>().currentUser;

    // ! Zaten giriş yaptıysak
    if (currentUser != null) {
      // 1. Kural: Giriş sayfasına gitmeye çalışmasını İPTAL ET
      resolver.next(false);
      // 2. Kural: İptal ettiğin için onu hemen ana sayfaya şutla
      router.replace(const CustomBottomBar());
    } else {
      // Kullanıcı yoksa, giriş sayfasına (AuthPage) girmesine İZİN VER
      resolver.next(true);
    }
  }
}

/*
    ! Şimdi Sistem Nasıl İşleyecek?

    * Senaryo A (Kullanıcı ilk defa geliyor ya da çıkış yapmış):

    Uygulama açılır, AuthGuard devreye girer. Kullanıcıyı null görür. resolver.next(true) diyerek kapıyı açar ve kullanıcı AuthPage ekranını görür.
    Kullanıcı şifresini yazıp "Giriş Yap" dediğinde onSignedIn() tetiklenir ve context.router.replace(const CustomBottomBarRoute()) ile içeri girer.

    * Senaryo B (Kullanıcı zaten giriş yapmış, uygulamayı kapatıp açıyor):
    Uygulama açılır açılmaz AuthGuard bakar ki currentUser dolu. Hemen resolver.next(false) ile giriş sayfasını engeller ve
    router.replace(const CustomBottomBarRoute()) ile kullanıcıya hiç hissettirmeden doğrudan ana sayfayı açar.
*/
