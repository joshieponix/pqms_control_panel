import 'package:flutter/material.dart';
import 'package:print_queue_control/provider/ServerControlProvider.dart';
import './home/print_server_control.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(
      ChangeNotifierProvider(
        create: (context) => Servercontrolprovider(),
          child:PrintServerControlApp()
      )
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