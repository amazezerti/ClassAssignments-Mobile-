import 'package:battery_plus/battery_plus.dart';
import 'dart:async';
import '../main.dart';

class BatteryService {
  final Battery _battery = Battery();
  StreamSubscription<BatteryState>? _batterySubscription;

  void startBatteryMonitoring() {
    _batterySubscription = _battery.onBatteryStateChanged.listen((BatteryState state) async {
      try {
        final batteryLevel = await _battery.batteryLevel;
        print("🔋 Battery Level: $batteryLevel%");
        if (batteryLevel <= 20) {
          await showNotification('Battery', 'Low battery: $batteryLevel%. Please charge.', 'battery_alerts');
        } else if (batteryLevel >= 80) {
          await showNotification('Battery', 'Battery high: $batteryLevel%. Consider unplugging.', 'battery_alerts');
        }
      } catch (e) {
        print("Battery Monitoring Error: $e");
      }
    });
  }

  void stopBatteryMonitoring() {
    _batterySubscription?.cancel();
  }
}