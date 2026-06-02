import 'package:flutter/material.dart';

class AccessibilityProvider extends ChangeNotifier {
  double _fontSizeFactor = 1.0;
  bool _isHighContrast = false;

  double get fontSizeFactor => _fontSizeFactor;
  bool get isHighContrast => _isHighContrast;

  // Aumenta o texto até um limite de 2.5x
  void aumentarTexto() {
    if (_fontSizeFactor < 2.5) {
      _fontSizeFactor += 0.1;
      notifyListeners();
    }
  }

  // Diminui o texto até um limite de 0.8x
  void diminuirTexto() {
    if (_fontSizeFactor > 0.8) {
      _fontSizeFactor -= 0.1;
      notifyListeners();
    }
  }

  // Alterna entre Colorido e Preto & Branco
  void alternarContraste() {
    _isHighContrast = !_isHighContrast;
    notifyListeners();
  }
}