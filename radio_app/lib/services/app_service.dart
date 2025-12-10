class AppService {
  bool _firstRun = true;

  bool get isFirstRun => _firstRun;

  void completeFirstRun() {
    _firstRun = false;
    print("Primera corrida completada");
  }

  void handleDeepLink(String url) {
    print("Deep link recibido: $url");
  }
}
