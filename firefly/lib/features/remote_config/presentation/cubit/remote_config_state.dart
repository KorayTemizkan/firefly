import 'package:equatable/equatable.dart';

// ! Uzaktan Yapılandırma Durumları (State)
// Firebase Remote Config'den gelen verilerin uygulama içerisindeki durumlarını yönetir
sealed class RemoteConfigState extends Equatable {
  const RemoteConfigState();
  @override
  List<Object?> get props => [];
}

// ! Başlangıç durumu
final class RemoteConfigInitial extends RemoteConfigState {}

// ! Verilerin başarıyla yüklendiği durum
final class RemoteConfigLoaded extends RemoteConfigState {
  final String welcomeMessage;
  final String imageUrl;
  final bool isHidden;
  final int year;

  const RemoteConfigLoaded({
    required this.welcomeMessage,
    required this.imageUrl,
    required this.isHidden,
    required this.year,
  });

  @override
  List<Object?> get props => [welcomeMessage, imageUrl, isHidden, year];
}
