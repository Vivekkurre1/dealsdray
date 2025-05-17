import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';

Future<Map<String, dynamic>> getDevicePayload() async {
  final deviceInfo = DeviceInfoPlugin();
  final packageInfo = await PackageInfo.fromPlatform();
  final androidInfo = await deviceInfo.androidInfo;
  final info = NetworkInfo();

  final ipAddress = await info.getWifiIP() ?? '0.0.0.0';

  // Get location
  Position position = await Geolocator.getCurrentPosition(
    // ignore: deprecated_member_use
    desiredAccuracy: LocationAccuracy.high,
  );

  return {
    "deviceType": androidInfo.type.toString(),
    "deviceId": androidInfo.id,
    "deviceName": "${androidInfo.manufacturer}-${androidInfo.model}",
    "deviceOSVersion": androidInfo.version.release,
    "deviceIPAddress": ipAddress,
    "lat": position.latitude,
    "long": position.longitude,
    "buyer_gcmid": "", // For push notifications (e.g. Firebase token)
    "buyer_pemid": "",
    "app": {
      "version": packageInfo.version,
      "installTimeStamp":
          DateTime.now()
              .toIso8601String(), // Use proper install time if tracked
      "uninstallTimeStamp": DateTime.now().toIso8601String(), // Placeholder
      "downloadTimeStamp": DateTime.now().toIso8601String(), // Placeholder
    },
  };
}
