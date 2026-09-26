import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';




class WindowService {

 static void _widgetFlutterBinding(){
     WidgetsFlutterBinding.ensureInitialized();
  }

  static Future<void> _ensureInitializedWindow() async {
      await  windowManager.ensureInitialized();
  }

  static Future<void> windowsOption({
    Size size = const Size(1200, 800),
    Size minSize = const Size(900, 600),
    String title = 'PRINTSERVER CONTROL CENTER',
    bool resizable = false,
  }) async {

    _widgetFlutterBinding();
    _ensureInitializedWindow();

    WindowOptions windowOptions =  WindowOptions(
      size: size,
      minimumSize: minSize,
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: title,
    );

    _windowOptionUntilReadyToShow(windowOptions, resizable);

  }


  static void _windowOptionUntilReadyToShow(WindowOptions windows, bool isResizable){
      windowManager.waitUntilReadyToShow(windows, () async {
        await windowManager.show();
        await windowManager.focus();
        await windowManager.setResizable(isResizable);
        await windowManager.setPreventClose(true);
      });
  }




}