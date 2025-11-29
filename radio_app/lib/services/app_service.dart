/// Servicio de aplicación para manejar lógica transversal.
/// Aquí puedes centralizar configuraciones globales:
/// - tema
/// - arranque inicial
/// - deep links
/// - manejo de primeras corridas

class AppService {
  bool _firstRun = true;

  bool get isFirstRun => _firstRun;

  void completeFirstRun() {
    _firstRun = false;
    print("Primera corrida completada");
  }

  void handleDeepLink(String url) {
    // Ejemplo: manejar un deep link
    print("Deep link recibido: $url");
  }
}
