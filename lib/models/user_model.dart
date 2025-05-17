class UserDevice {
  final String deviceType;
  final String deviceId;
  final String deviceName;
  final String deviceOSVersion;
  final String deviceIPAddress;
  final double lat;
  final double long;
  final String buyerGcmid;
  final String buyerPemid;
  final AppInfo app;

  UserDevice({
    required this.deviceType,
    required this.deviceId,
    required this.deviceName,
    required this.deviceOSVersion,
    required this.deviceIPAddress,
    required this.lat,
    required this.long,
    required this.buyerGcmid,
    required this.buyerPemid,
    required this.app,
  });

  Map<String, dynamic> toJson() => {
        'deviceType': deviceType,
        'deviceId': deviceId,
        'deviceName': deviceName,
        'deviceOSVersion': deviceOSVersion,
        'deviceIPAddress': deviceIPAddress,
        'lat': lat,
        'long': long,
        'buyer_gcmid': buyerGcmid,
        'buyer_pemid': buyerPemid,
        'app': app.toJson(),
      };
}

class AppInfo {
  final String version;
  final String installTimestamp;
  final String uninstallTimestamp;
  final String downloadTimestamp;
  AppInfo({
    required this.version,
    required this.installTimestamp,
    required this.uninstallTimestamp,
    required this.downloadTimestamp,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'installTimeStamp': installTimestamp,
        'uninstallTimeStamp': uninstallTimestamp,
        'downloadTimeStamp': downloadTimestamp,
      };
}

class UserModel {
  final String? userId;
  final String? deviceId;
  final String? phone;
  final String? email;
  UserModel({this.userId, this.deviceId, this.phone, this.email});
}
