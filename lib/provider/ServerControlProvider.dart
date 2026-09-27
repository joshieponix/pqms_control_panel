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
  List<String> _webAppUrls = [];
  String _localIp = '127.0.0.1';

  bool get isRunning => _isRunning;
  bool get isChecking => _isChecking;
  int get clientsConnected => _clientsConnected;
  List<String> get logs => List.unmodifiable(_logs);
  List<String> get webAppUrls => _webAppUrls;
  String get localIp => _localIp;


  ServerControlProvider(){
    initProvider();
  }

    Future<void> initProvider() async {
        await loadComputerIpAddress();
        await checkServerStatus();
    }


  void _addLog(String message) {
    final timestamp = DateTime.now().toString().split(' ')[1].substring(0, 8);
    _logs.add('[$timestamp] $message');
    notifyListeners();
  }

  Future<void> checkServerStatus() async{
    _isChecking = true;
     notifyListeners();
    try {
      dynamic ipaddress = await ComputerInfoServices.getLocalIp();
      final serverUrl = 'http://$ipaddress:3000/api/status';
      final response = await http.get(Uri.parse(serverUrl))
      .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200){
        _isRunning = true;
        _addLog('DETECTED EXISTING PQMS CONTROL PANEL SERVER RUNNING ON http://$ipaddress:3000 .');
        await fetchServerDetails();
        notifyListeners();
      }else {
        _isRunning = false;
      }
    } catch (e) {
      _isRunning = false;
      notifyListeners();
    }finally {
      _isChecking = false;
      notifyListeners();
    }
  }

    Future<void> fetchServerDetails() async {
    try {
      final url = 'http://$_localIp:3000/api/info';
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _localIp = data['ip'] ?? '127.0.0.1';
        _webAppUrls = List<String>.from(data['urls'] ?? []);

        for (var url in _webAppUrls) {
          _addLog('DETECTED WEB APP: $url');
        }
      }
    } catch (e) {
      _addLog('ERROR FETCHING SERVER INFO: $e');
    }
  }

  Future<void> startServer() async {
    if (_isRunning) return;
     
    try {
      _addLog('Attempting to start PrintQueue Server...'.toUpperCase());
      _process = await Process.start('${Directory.current.path}\\print-server.exe', [], runInShell: true);
      _isRunning = true;
      _clientsConnected = 1;
      final serverUrl = 'http://$_localIp:3000/operator.html';
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      await fetchServerDetails();

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
      _webAppUrls.clear();
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