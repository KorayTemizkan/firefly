import 'package:example_messaging/features/remote_config/presentation/cubit/remote_config_cubit.dart';
import 'package:example_messaging/features/remote_config/presentation/cubit/remote_config_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ! Uzaktan Yapılandırma Görüntüleyici
// Remote Config'den gelen verileri dinler ve arayüzde gösterir
class RemoteConfigBlocBuilder extends StatelessWidget {
  const RemoteConfigBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteConfigCubit, RemoteConfigState>(
      builder: (context, state) {
        // ! Veriler başarıyla yüklendiyse kartı göster
        if (state is RemoteConfigLoaded) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Remote Config Mesajı: ${state.welcomeMessage}',
                style: const TextStyle(fontSize: 24, letterSpacing: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // ! Veriler yüklenirken gösterilecek yükleme göstergesi
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
