/// Servicio de audio para manejar lógica adicional
/// más allá del AudioProvider.
/// Útil si luego integras notificaciones, grabaciones o analytics.

class AudioService {
  // Aquí puedes agregar lógica adicional en el futuro:
  // - grabaciones
  // - analytics
  // - integración con notificaciones
  // - control de reproducción en segundo plano

  void logPlay(String stationName) {
    // Ejemplo: registrar que se inició reproducción
    print("Reproduciendo estación: $stationName");
  }

  void logPause(String stationName) {
    // Ejemplo: registrar que se pausó reproducción
    print("Pausada estación: $stationName");
  }
}
