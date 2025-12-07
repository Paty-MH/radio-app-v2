import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  /// Currently selected station
  int _currentStation = 0;
  int get currentStation => _currentStation;

  int get currentStationIndex => _currentStation;

  /// Here the station changes
  void setCurrentStation(int index) {
    _currentStation = index;
    notifyListeners();
  }

  /// Onboarding
  bool _didOnboard = false;
  bool get didOnboard => _didOnboard;

  void completeOnboarding() {
    _didOnboard = true;
    notifyListeners();
  }

  /// Light and dark theme
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  /// Lower panel open and closed
  bool _isPanelOpen = false;
  bool get isPanelOpen => _isPanelOpen;

  get stations => null;

  void setPanelOpen(bool value) {
    _isPanelOpen = value;
    notifyListeners();
  }
}
