import 'package:url_launcher/url_launcher.dart';

class UrlLauncherServices {

  static Uri _urlParse(String serviceUrl){
     final Uri url = Uri.parse(serviceUrl);
     return url;
  }

   static Future<void> urlLauncher(String serviceUrl)async{
      Uri url = _urlParse(serviceUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication
        );
      }
    }

}