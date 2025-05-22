import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../main.dart';

class ConnectivityService {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  void startListening() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      final status = results.contains(ConnectivityResult.wifi) ? 'Wi-Fi Connected' : 'Wi-Fi Disconnected';
      print("🔗 Connectivity Status: $status");
      await showNotification('Connectivity', status, 'connectivity_alerts');
    });
  }

  Future<void> initConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      final status = results.contains(ConnectivityResult.wifi) ? 'Wi-Fi Connected' : 'Wi-Fi Disconnected';
      print("🔗 Initial Connectivity: $status");
      await showNotification('Connectivity', status, 'connectivity_alerts');
    } catch (e) {
      print("Connectivity Error: $e");
    }
  }

  void stopListening() {
    _connectivitySubscription?.cancel();
  }
}