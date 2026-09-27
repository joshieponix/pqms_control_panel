import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:print_queue_control/core/services/computer_info_services.dart';
import 'package:print_queue_control/core/services/url_launcher_services.dart';
import 'package:http/http.dart' as http;


class ServerControlProvider extends ChangeNotifier {
  Process? _process;
  bool _isRunning = false;
  bool _isChecking = true;
  int _clientsConnected = 0;
  final List<String> _logs = [];
  String _localIp = 'Loading...';

  bool get isRunning => _isRunning;
  bool get isChecking => _isChecking;
  int get clientsConnected => _clientsConnected;
  List<String> get logs => List.unmodifiable(_logs);
  String get localIp => _localIp;

  void _addLog(String message) {
    final timestamp = DateTime.now().toString().split(' ')[1].substring(0, 8);
    _logs.add('[$timestamp] $message');
    notifyListeners();
  }

  Future<void> checkServerStatus() async{
    _isChecking = true;
     notifyListeners();
    try {
      final ipaddress = await ComputerInfoServices.getLocalIp();
      final serverUrl = 'http://$ipaddress:3000/';
      final response = await http.get(Uri.parse(serverUrl))
      .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200){
        _isRunning = true;
        _addLog('DETECTED EXISTING PRINT SERVER RUNNING ON PORT 3000.');
        notifyListeners();
      }else {
        _isRunning = false;
      }
    } catch (e) {
      _isRunning = false;
      notifyListeners();
    }finally {
      _isChecking = false;
      notifyListeners(); // I-notify ang UI para mag-change sa STOP button
    }
  }

  Future<void> startServer() async {
    if (_isRunning) return;
     
    try {
      _addLog('Attempting to start PrintQueue Server...'.toUpperCase());
      _process = await Process.start('${Directory.current.path}\\print-server.exe', [], runInShell: true);
      _isRunning = true;
      _clientsConnected = 1;
      final ipaddress = await ComputerInfoServices.getLocalIp();
      final serverUrl = 'http://$ipaddress:3000/';
      notifyListeners();

      _addLog('System started...'.toUpperCase());
      _addLog('Server is running on: ${serverUrl}');
      _addLog('pqms control panel server active on port 3000.'.toUpperCase());

      UrlLauncherServices.urlLauncher(serverUrl);

      _process?.stdout.transform(utf8.decoder).listen((data) {
        final lines = data.trim().split('\n');
        for (var line in lines) {
          if (line.isNotEmpty) _addLog(line);
        }
      });

      _process?.stderr.transform(utf8.decoder).listen((data) {
        final lines = data.trim().split('\n');
        for (var line in lines) {
          if (line.isNotEmpty) _addLog('ERROR: $line'.toUpperCase());
        }
      });
    } catch (e) {
      _addLog('Failed to start server process: $e'.toUpperCase());
      _isRunning = false;
      notifyListeners();
    }
  }

  Future<void> stopServer() async {
    if (!_isRunning) return;

    try {
      await Process.run('taskkill', ['/F', '/IM', 'print-server.exe']);

      _process?.kill();
      _process = null;

      _isRunning = false;
      _clientsConnected = 0;
      _addLog('Server process stopped by ${ComputerInfoServices.userName}.'.toUpperCase());
      notifyListeners();
    } catch (e) {
      _addLog('Error stopping process: $e'.toUpperCase());
    }
  }

  Future<void> loadComputerIpAddress() async {
      _localIp = await ComputerInfoServices.getLocalIp() ?? 'Not available';
      notifyListeners();
  }
}