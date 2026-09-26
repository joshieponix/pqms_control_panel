import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';


class WindowService {

  static void widgetFlutterBinding(){
     WidgetsFlutterBinding.ensureInitialized();
  }

  static Future<void> ensureInitializedWindow() async {
      await  windowManager.ensureInitialized();
  }

  static Future<void> initializeWindow({
    Size size = const Size(1200, 800),
    Size minSize = const Size(900, 600),
    String title = 'PRINTSERVER CONTROL CENTER',
    bool resizable = false,
  }) async {


      


  }
}