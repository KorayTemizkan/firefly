import 'package:flutter/material.dart';

// ! Tema ve Görsel Strateji Yardımcıları
// BuildContext üzerinde hızlıca tema ve renk paletine erişim sağlar
extension ThemeHelper on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme =>
      theme.colorScheme; // ? primary, secondary vb. erişmek için
}

// ! Boyutlandırma Yardımcıları
// Ekranın yüksekliğine ve genişliğine Context üzerinden hızlıca ulaşmayı sağlar
extension ContextExtension on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}
