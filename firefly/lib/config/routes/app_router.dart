import 'package:auto_route/auto_route.dart';
import 'package:example_messaging/config/routes/app_router.gr.dart';
import 'package:example_messaging/config/routes/auth_guard.dart';
import 'package:example_messaging/core/constants/system_constants.dart';

// ! Rotalama ayarları
// Uygulamanın tüm navigasyon yapısını belirler ve AutoRoute generator için işaretçidir
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // ! Onboarding(Auth)
    // Kimlik doğrulama ekranı, başlangıç sayfasıdır ve AuthGuard ile korunur
    AutoRoute(
      page: AuthRoute.page,
      path: SystemConstants.authPath,
      initial: true,
      guards: [AuthGuard()],
    ),

    // ! BottomBar ve genel yapı
    // Uygulamanın ana navigasyon barını ve içerdiği alt sayfaları tanımlar
    AutoRoute(
      page: CustomBottomBar.page,
      path: SystemConstants.mainPath,
      children: [
        AutoRoute(page: HomeRoute.page, path: SystemConstants.homePath),
        AutoRoute(page: AiRoute.page, path: SystemConstants.aiPath),
        AutoRoute(page: ProfileRoute.page, path: SystemConstants.profilePath),
      ],
    ),

    // ! Alt sayfalar
    // BottomBar dışı veya bağımsız açılan ekran rotaları
    AutoRoute(page: ChatRoute.page, path: SystemConstants.chatPath),
    AutoRoute(page: FullImageRoute.page, path: SystemConstants.imageTapPath),
    AutoRoute(page: SettingsRoute.page, path: SystemConstants.settingsPath),
  ];
}

// ! Kod üretimi komutu
// Projeyi build ederken rotaların (gr.dart) güncellenmesi için gereken komut
// dart run build_runner build --delete-conflicting-outputs --force-jit
