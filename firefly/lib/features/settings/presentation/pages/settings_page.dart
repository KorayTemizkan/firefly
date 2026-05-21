import 'package:auto_route/auto_route.dart';
import 'package:example_messaging/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

// ! Ayarlar Sayfası
// Kullanıcı tercihleri ve uygulama ayarlarının yönetileceği ana arayüz
@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      // ! Ayarlar içerikleri buraya eklenecek
      body: Center(
        child: Text(
          '...',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
