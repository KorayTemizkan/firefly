import 'dart:ui';
import 'package:example_messaging/config/routes/app_router.dart';
import 'package:example_messaging/config/theme/app_themes.dart';
import 'package:example_messaging/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:example_messaging/features/notification/presentation/cubit/notification_state.dart';
import 'package:example_messaging/features/notification/presentation/widgets/toast_message.dart';
import 'package:example_messaging/features/remote_config/presentation/cubit/remote_config_cubit.dart';
import 'package:example_messaging/firebase_options.dart';
import 'package:example_messaging/injection_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ! Küresel anahtarlar
// Uygulama genelinde rotalama ve Scaffold'a erişim için kullanılan küresel tanımlamalar
final _appRouter = AppRouter();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  // ! Sistemsel
  // Flutter motorunun Firebase gibi asenkron işlemlerden önce hazır olduğundan emin oluyoruz
  WidgetsFlutterBinding.ensureInitialized();
  // Uygulamayı sadece dikey modlara sabitler
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Sistemin otomatik olarak navigation bar arkasına geçmesini engeller
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // ! Firebase Bağlantısı
  // Firebase'i projeye bağladığımız ayarlar ile başlatıyoruz
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ! GetIt Bağlantısı ve fonksiyonları
  // Dependency Injection yapısını başlatır, tüm servisleri ve cubitleri kaydeder
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Uygulama genelindeki state yönetimini (Bloc) ağaca entegre ediyoruz
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<NotificationCubit>()..monitorNotifications(),
        ),
        // ! REMOTE CONFIG'İ BURADA TETİKLİYORUZ
        BlocProvider(
          create: (context) => sl<RemoteConfigCubit>()..initRemoteConfig(),
        ),
      ],
      // Uygulama içi bildirimleri dinleyerek kullanıcıya gösterir
      child: BlocListener<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is InAppNotificationReceived) {
            ToastMessage.show(state.notification);
          }
        },
        child: MaterialApp.router(
          routerConfig: _appRouter.config(),
          debugShowCheckedModeBanner: false,
          theme: theme(),
          scaffoldMessengerKey: rootScaffoldMessengerKey,

          // ! Dil ve yerelleştirme ayarları
          localizationsDelegates: [
            // 1. Firebase'in kendi butonlarını/hatalarını Türkçe yapar
            FirebaseUILocalizations.withDefaultOverrides(
              const TrLocalizations(),
            ),
            // 2. Uygulamanın temelini (Kopyala/Yapıştır vb.) Türkçe yapar ve çökmeyi önler
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('tr', ''), // Türkçeyi desteklediğimizi belirtiyoruz
            Locale('en', ''),
          ],
          // !
        ),
      ),
    );
  }
}
