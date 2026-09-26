import 'dart:io';

class ComputerInfoServices {

  static String get userName => Platform.environment['USERNAME'] ?? "UNKNOWN";
  static String get computerName => Platform.environment['COMPUTERNAME'] ?? "UNKNOWN";
  static String get localHostName => Platform.localHostname;


  static Future<String?> getLocalIp() async {
   final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: true,
      );

      for (final interface in interfaces) {
          for (final address in interface.addresses) {
            if (!address.isLoopback){
              return address.address;
            }
          }
      }
  }

 

}