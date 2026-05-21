import 'dart:async';
import 'package:example_messaging/core/network/firebase_cloud_messaging_service.dart';
import 'package:example_messaging/features/notification/presentation/cubit/notification_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ! Bildirim Yönetimi (Cubit)
// Firebase'den gelen bildirim akışını dinler ve arayüz (UI) katmanına bildirim durumlarını iletir
class NotificationCubit extends Cubit<NotificationState> {
  final FirebaseCloudMessagingService _messagingService;
  StreamSubscription<RemoteNotification>? _subscription;

  NotificationCubit(this._messagingService) : super(NotificationInitial());

  // ! Bildirim akışını başlatma
  void monitorNotifications() {
    // Servisin ana kurulumunu tetikliyoruz
    _messagingService.initNotifications();

    // Mevcut bir dinleme varsa bellek sızıntısını önlemek için önce onu kapatıyoruz
    _subscription?.cancel();

    // Servisteki saf Dart Stream'ini dinlemeye başlıyoruz
    _subscription = _messagingService.notificationStream.listen((notification) {
      // ! Bildirim alındığında durumu güncelle
      emit(InAppNotificationReceived(notification));
    });
  }

  // ! Cubit kapatılırken aboneliği sonlandır
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
