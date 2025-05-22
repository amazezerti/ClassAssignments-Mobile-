import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import '../main.dart';

class BluetoothService {
  StreamSubscription<BluetoothAdapterState>? _bluetoothSubscription;

  Future<void> checkBluetoothState() async {
    try {
      final state = await FlutterBluePlus.adapterState.first;
      print('📡 Bluetooth State: $state');
      await showNotification('Bluetooth', 'Bluetooth State: $state', 'bluetooth_alerts');
    } catch (e) {
      print('Bluetooth State Error: $e');
    }
  }

  Future<List<BluetoothDevice>> getConnectedDevices() async {
    try {
      final devices = await FlutterBluePlus.connectedDevices;
      print("🔵 Connected Bluetooth Devices: ${devices.length}");
      return devices;
    } catch (e) {
      print('Error getting connected devices: $e');
      return [];
    }
  }

  Future<void> startScan() async {
    try {
      final bluetoothScanStatus = await Permission.bluetoothScan.request();
      final bluetoothConnectStatus = await Permission.bluetoothConnect.request();
      final locationStatus = await Permission.locationWhenInUse.request();

      if (bluetoothScanStatus.isGranted && bluetoothConnectStatus.isGranted && locationStatus.isGranted) {
        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
        print("🔍 Bluetooth Scanning Started...");
      } else {
        print("Bluetooth scan permissions denied");
        await showNotification('Bluetooth', 'Scan permissions denied', 'bluetooth_alerts');
      }
    } catch (e) {
      print('Error starting scan: $e');
    }
  }

  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
      print("⛔ Bluetooth Scanning Stopped.");
    } catch (e) {
      print('Error stopping scan: $e');
    }
  }

  void startBluetoothMonitoring() {
    _bluetoothSubscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async {
      print('📡 Bluetooth State Changed: $state');
      await showNotification('Bluetooth', 'Bluetooth State: $state', 'bluetooth_alerts');
    });
  }

  void stopBluetoothMonitoring() {
    _bluetoothSubscription?.cancel();
  }
}