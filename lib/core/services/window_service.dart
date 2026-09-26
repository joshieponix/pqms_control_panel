import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowsEvent{

  
  @override
  void onWindowClose(BuildContext context) async {
    bool isPreventClose = await windowManager.isPreventClose();
    bool mounted = true;
    if (isPreventClose && mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Confirm Exit'),
          content: const Text('Are you sure you want to exit the PrintServer?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Exit'),
              onPressed: () async {
                Navigator.of(context).pop();
                // Destroy the window completely
                await windowManager.destroy();
              },
            ),
          ],
        ),
      );
    }
  }
}


class WindowService extends WindowsEvent{

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


