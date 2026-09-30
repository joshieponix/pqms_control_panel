import 'package:flutter/material.dart';
import 'package:print_queue_control/core/services/window_service.dart';
import 'package:provider/provider.dart';
import 'home/ServerControlDashboard.dart';
import 'provider/ServerControlProvider.dart';
import 'package:auto_updater/auto_updater.dart';

void main() async {
  WindowService.windowsOption(
    size: const Size(1280, 720),
    title: 'PQMS CONTROL PANEL',
    resizable: false, // Dili ma-resize
  );

  // Replace with your GitHub repository details
  // Using GitHub Pages URL: https://<username>.github.io/<repo-name>/appcast.xml
  // Or raw GitHub file URL: https://raw.githubusercontent.com/<username>/<repo>/main/appcast.xml
  String feedURL = 'https://raw.githubusercontent.com/YOUR_GITHUB_USER/YOUR_REPO/main/appcast.xml';

  await autoUpdater.setFeedURL(feedURL);
  await autoUpdater.checkForUpdates(inBackground: false);
  await autoUpdater.setScheduledCheckInterval(3600); // Check every 1 hour
  runApp(
    ChangeNotifierProvider(
      create: (_) => ServerControlProvider(),
      child: const PrintServerControlApp(),
    ),
  );
}

class PrintServerControlApp extends StatelessWidget {
  const PrintServerControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PQMS CONTROL PANEL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF18191C),
        cardColor: const Color(0xFF22242A),
      ),
      home: const ServerControlDashboard(),
    );
  }
}