import 'package:flutter/material.dart';

// ! Başlık Bileşeni
// Uygulama arayüzlerinde standartlaştırılmış kalın ve sola hizalı başlık metni sunar
class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF1E1E1E), // ! Sabit koyu gri başlık rengi
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
