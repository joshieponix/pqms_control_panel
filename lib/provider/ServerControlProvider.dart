
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class Servercontrolprovider  extends ChangeNotifier{

  Process? _process;
  bool _isRunning = false;
  int _clientsConnected = 0;
  final ScrollController _scrollController = ScrollController();
  final List<String> _logs = [];


  bool get isRunning => _isRunning;

  void _addLog(String message) {
    final timestamp = DateTime.now().toString().split(' ')[1].substring(0, 8);
        notifyListeners();
          _logs.add('[$timestamp] $message');
    // Auto scroll down sa terminal log window
          Future.delayed(const Duration(milliseconds: 100), () {
            if (_scrollController.hasClients) {
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            }
          });
  }

 Future<void> _startServer() async {
    if (_isRunning) return;

    try {
      _addLog('Attempting to start PrintQueue Server...');
      // I-execute ang standalone executable
        _process = await Process.start('print-server.exe', [], runInShell: true);
          _isRunning = true;
              _clientsConnected = 1; // Sample initial connection
      notifyListeners();

      _addLog('System started (Node.js/PKG).');
      _addLog('PrintQueue server active on port 3000.');

      // Capture stdout (normal logs)
      _process?.stdout.transform(utf8.decoder).listen((data) {
        final lines = data.trim().split('\n');
        for (var line in lines) {
          if (line.isNotEmpty) _addLog(line);
        }
      });

      // Capture stderr (errors)
      _process?.stderr.transform(utf8.decoder).listen((data) {
        final lines = data.trim().split('\n');
        for (var line in lines) {
          if (line.isNotEmpty) _addLog('ERROR: $line');
        }
      });

    } catch (e) {
      _addLog('Failed to start server process: $e');
      _isRunning = false;
      notifyListeners();
    }
  }



}