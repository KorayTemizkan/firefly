import 'dart:ui';
import 'package:example_messaging/core/constants/system_constants.dart';
import 'package:example_messaging/core/network/firebase_ai_service.dart';
import 'package:example_messaging/core/network/firebase_chat_service.dart';
import 'package:example_messaging/core/network/firebase_cloud_messaging_service.dart';
import 'package:example_messaging/core/network/firebase_remote_config_service.dart';
import 'package:example_messaging/core/resources/shared_preferences.dart';
import 'package:example_messaging/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:example_messaging/features/remote_config/presentation/cubit/remote_config_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// ! Servis Bulucu (Service Locator)
// Proje genelinde nesne bağımlılıklarını yönetir
final sl = GetIt.instance;

// ! Bağımlılık Enjeksiyonu (Dependency Injection) Başlatıcı
Future<void> init() async {
  // ! Firebase Crashlytics Yapılandırması
  // Flutter tarafından yakalanan tüm hataları Crashlytics'e gönder
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Uygulama içinde async hataları gibi yakalanamayan hataları da Crashlytics'e gönder
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // ! Yerel Veri Depolama (SharedPreferences)
  final sharedPreferencesService = SharedPreferencesService();
  await sharedPreferencesService.init();
  sl.registerSingleton<SharedPreferencesService>(sharedPreferencesService);

  // ! Sohbet Servisi
  sl.registerSingleton<FirebaseChatService>(FirebaseChatService());

  // ! Yapay Zeka Servisi
  sl.registerLazySingleton<FirebaseAiService>(() => FirebaseAiService());

  // ! Firebase Kimlik Doğrulama
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // ! Bildirim Servisi (FCM)
  sl.registerSingleton<FirebaseCloudMessagingService>(
    FirebaseCloudMessagingService(),
  );
  sl.registerFactory<NotificationCubit>(
    () => NotificationCubit(sl<FirebaseCloudMessagingService>()),
  );

  // ! Uzaktan Yapılandırma (Remote Config)
  sl.registerSingleton<FirebaseRemoteConfigService>(
    FirebaseRemoteConfigService(),
  );
  sl.registerFactory<RemoteConfigCubit>(
    () => RemoteConfigCubit(sl<FirebaseRemoteConfigService>()),
  );

  /*
  // ! Bağımlılık Yönetimi Notları

  * registerSingleton: Uygulama açıldığı an tek bir kez üretilir ve yaşam döngüsü boyunca korunur.
  * registerLazySingleton: Sadece ilk ihtiyaç duyulduğunda (ilk erişimde) tek bir kez üretilir, sonra Singleton gibi yaşar.
  * registerFactory: Her çağrıldığında (Bloc/Cubit oluşturulurken) yepyeni bir instance üretir.
  */
}

// ! Global Kullanıcı Bilgileri Erişimcileri

/// Firebase Auth örneğine hızlı erişim
FirebaseAuth get auth => sl<FirebaseAuth>();

/// Mevcut giriş yapmış kullanıcı
User? get currentUser => auth.currentUser;

/// Mevcut kullanıcının benzersiz ID'si
String get currentUid => currentUser?.uid ?? '';

/// Giriş yapmış kullanıcının e-posta adresi (Yoksa boş döner)
String get currentEmail => currentUser?.email ?? '';

// TODO: Her seferinde böyle yapmamalıyım
/// Kullanıcı adı türetici:
/// E-postanın '@' öncesini alır veya UID'den benzersiz bir isim oluşturur.
String get currentUsername => currentEmail.isNotEmpty
    ? currentEmail.split(SystemConstants.atSign)[0]
    : '${SystemConstants.user}_${currentUid.isNotEmpty ? currentUid.substring(0, 5) : SystemConstants.unknownUser}';
