import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home/ServerControlDashboard.dart';
import 'provider/ServerControlProvider.dart';

void main() {
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
      title: 'PRINTSERVER CONTROL CENTER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF18191C),
        cardColor: const Color(0xFF22242A),
      ),
      home: const ServerControlDashboard(),
    );
  }
}