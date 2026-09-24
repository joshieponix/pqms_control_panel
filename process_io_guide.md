import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
String text = "";
  void process() {

      try {

 stdout.write('Ipasok ang Unang Numero: ');
  String? num1Input = stdin.readLineSync();
    //     Process myprocess = await Process.start("ping", ['127.0.0.1']);

    //     myprocess.stdout.transform(utf8.decoder).listen((data){
    //       text += data.trim();
    //       print(data.trim());
    //     });

    //     // Paminaw sa Real-time Errors (stderr)
    // myprocess.stderr.transform(utf8.decoder).listen((data) {
    //   print('[ERROR LOG]: ${data.trim()}');
    // });

    //   // stdout.write("Hello fucking world");

    //   // stdin.transform(utf8.decoder).listen((data) {
    //   //   print('Natanggap na Input: ${data.trim()}');
    //   // });
    

    //     myprocess.exitCode.then((exitCode) {
    //   print('\n[SYSTEM]: Process ended with Exit Code: $exitCode');
    // });

    // await Future.delayed(const Duration(seconds: 3));

    // print('\n[SYSTEM]: Stopping process manually (Simulating STOP BUTTON click)...');



        // ProcessResult result = await Process.run('cmd', ['/c', 'start www.facebook.com']);
        // if(result.stdout == 0){
        //   print(result.exitCode);
        // }


      } catch (e) {
        print(e);
      }

  }



  @override
  Widget build(BuildContext context) {
      process();
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Text(text),
        ),
      ),
    );
  }
}