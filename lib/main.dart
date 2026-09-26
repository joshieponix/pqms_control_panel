import 'package:flutter/material.dart';
import 'package:print_queue_control/core/services/window_service.dart';
import 'package:provider/provider.dart';
import 'home/ServerControlDashboard.dart';
import 'provider/ServerControlProvider.dart';

void main() {
  WindowService.windowsOption(
    size: const Size(1280, 720),
    title: 'PRINTSERVER CONTROL CENTER',
    resizable: false, // Dili ma-resize
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ServerControlProvider()
      ..loadComputerIpAddress(),
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