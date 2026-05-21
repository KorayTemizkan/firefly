import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// ! Bildirim Durumları (State)
// Bildirim akışının farklı durumlarını yönetmek için tanımlanan sealed class
sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

// ! Başlangıç durumu
final class NotificationInitial extends NotificationState {}

// ! Uygulama açıkken (Foreground) yeni bir bildirim yakalandığında bu state yayılacak
final class InAppNotificationReceived extends NotificationState {
  final RemoteNotification notification;

  const InAppNotificationReceived(this.notification);

  @override
  List<Object?> get props => [notification];
}
