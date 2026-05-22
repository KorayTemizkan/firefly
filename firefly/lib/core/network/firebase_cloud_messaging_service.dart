import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:example_messaging/core/constants/firebase_constants.dart';

/*
Bu fonksiyon ile arka planda da çalışma sağlanır.
İşletim sistemi uygulama kapalıyken bu fonksiyonu yine de çalıştırır.
Önemli: Bu fonksiyonun sınıfın dışında kalması en doğrusudur.
*/
@pragma('vm:entry-point')
Future<void> _firebaseCloudMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  print('${FirebaseConstants.backgroundMessageLog}${message.messageId}');
}

// ! Bildirim servis katmanı
// Firebase Cloud Messaging (FCM) üzerinden gelen bildirimleri yönetir ve uygulama içi akışa iletir
class FirebaseCloudMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // ! Stream

  // Gelen bildirimleri UI katmanına aktarmak için bir akış açtık
  final StreamController<RemoteNotification> _notificationStreamController =
      StreamController<RemoteNotification>.broadcast();

  // Cubitin bu akışı dinleyebilmesi için get metodu
  Stream<RemoteNotification> get notificationStream =>
      _notificationStreamController.stream;

  Future<void> initNotifications() async {
    try {
      // 1. Kullanıcıdan izinleri iste
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // İzin durumunu kontrol et
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print(FirebaseConstants.notificationPermissionGranted);

        // 2. Mevcut cihazın tokenini al (Sadece izin verildiyse almak en doğrusudur)
        String? token = await _messaging.getToken();
        print('${FirebaseConstants.fcmTokenLog}$token');

        // TODO: Projenin ilerleyen safhalarında bu token'ı sl<FirebaseFirestore>() kullanarak kullanıcının dokümanına kaydedebilirsin.
      } else {
        print(FirebaseConstants.notificationPermissionDenied);
      }

      // 3. Arka plan dinleyicisini ayarla
      // NOT: Bu metot sadece burada tanımlı kalmalı, tetiklenmesini Firebase kendisi yönetir.
      FirebaseMessaging.onBackgroundMessage(
        _firebaseCloudMessagingBackgroundHandler,
      );

      // 4. Ön plan dinleyicisini ayarla (Uygulama açıkken)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
          '${FirebaseConstants.foregroundMessageLog}${message.notification?.title}',
        );

        if (message.notification != null) {
          _notificationStreamController.add(message.notification!);
        }

        // TODO: Uygulama açıkken yukarıdan bildirim düşür. Buraya bir Overlay, Custom Snackbar veya 'flutter_local_notifications' entegrasyonu ekleyebilirsin.
      });

      // 5. Bildirime tıklandığında uygulama arka plandaysa
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('${FirebaseConstants.backgroundClickedLog}${message.data}');

        // TODO: auto_route kullanıyorsan yönlendirmeyi şöyle yapabilirsin:
        // if (message.data['type'] == 'match') {
        //   _appRouter.push(MatchDetailRoute(matchId: message.data['id']));
        // }
      });

      // 6. BONUS: Uygulama tamamen KAPALIYKEN (Terminated) bildirime tıklanarak açıldıysa
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        print(
          '${FirebaseConstants.terminatedClickedLog}${initialMessage.data}',
        );
        // Uygulama tamamen sıfırdan açıldığı için yönlendirmeyi Splash/Home açıldıktan hemen sonraya saklamalısın.
      }
    } catch (e) {
      // Olası bir Firebase bağlantı koptu/yetki yok hatasında uygulamanın main.dart'ı kilitlemesini önleriz
      print("${FirebaseConstants.fcmInitError}$e");
    }
  }
}
