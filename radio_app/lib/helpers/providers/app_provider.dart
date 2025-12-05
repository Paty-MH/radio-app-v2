import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  /// Estación seleccionada actualmente
  int _currentStation = 0;
  int get currentStation => _currentStation;

  /// Alias para compatibilidad con tu HomeScreen
  int get currentStationIndex => _currentStation;

  /// Cambiar estación
  void setCurrentStation(int index) {
    _currentStation = index;
    notifyListeners();
  }

  /// Onboarding (si lo usas)
  bool _didOnboard = false;
  bool get didOnboard => _didOnboard;

  void completeOnboarding() {
    _didOnboard = true;
    notifyListeners();
  }

  /// Tema claro/oscuro
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  /// Panel inferior abierto/cerrado
  bool _isPanelOpen = false;
  bool get isPanelOpen => _isPanelOpen;

  void setPanelOpen(bool value) {
    _isPanelOpen = value;
    notifyListeners();
  }
}
