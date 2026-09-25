import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../shared/widget/ServerControlButton .dart';


class ServerControlDashboard extends StatefulWidget {
  const ServerControlDashboard({super.key});

  @override
  State<ServerControlDashboard> createState() => _ServerControlDashboardState();
}

class _ServerControlDashboardState extends State<ServerControlDashboard> {
  Process? _process;
  bool _isRunning = false;
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();
  int _clientsConnected = 0;
  

  void _addLog(String message) {
    final timestamp = DateTime.now().toString().split(' ')[1].substring(0, 8);
    setState(() {
      _logs.add('[$timestamp] $message');
    });

    // Auto scroll down sa terminal log window
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _startServer() async {
    if (_isRunning) return;

    try {
      _addLog('Attempting to start PrintQueue Server...');
      
      // I-execute ang standalone executable
      _process = await Process.start('print-server.exe', [], runInShell: true);

      setState(() {
        _isRunning = true;
        _clientsConnected = 1; // Sample initial connection
      });

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
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _stopServer() async{
    if (!_isRunning) return;
  
    try {
      // Patyon ang process gamit ang taskkill sa Windows
      Process.run('taskkill', ['/F', '/IM', 'print-server.exe']);

      _process?.kill();
      _process = null;

      setState(() {
        _isRunning = false;
        _clientsConnected = 0;
      });

      _addLog('Server process stopped by user.');
    } catch (e) {
      _addLog('Error stopping process: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // CUSTOM WINDOW HEADER BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF111215),
            child: Row(
              children: [
                const Icon(Icons.print_outlined, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'PRINTSERVER CONTROL CENTER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                // const Icon(Icons.remove, size: 16, color: Colors.white54),
                // const SizedBox(width: 16),
                // const Icon(Icons.crop_square, size: 14, color: Colors.white54),
                // const SizedBox(width: 16),
                // const Icon(Icons.close, size: 16, color: Colors.white54),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // STATUS BADGE
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isRunning ? const Color(0xFF39E55A) : const Color(0xFFFF4D4D),
                          boxShadow: [
                            BoxShadow(
                              color: (_isRunning ? const Color(0xFF39E55A) : const Color(0xFFFF4D4D)).withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'System Status: ${_isRunning ? "ONLINE" : "OFFLINE"}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // MAIN CONTROLS & LOGS SECTION
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT PANEL: CONTROLS & DETAILS
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22242A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CONTROLS',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 16),
                               Row(
                                  children: [
                                    ServerControlButton(
                                      isRunning: _isRunning,
                                      isStartButton: true,
                                      onPressed: _isRunning ? null : _startServer,
                                    ),

                                    const SizedBox(width: 12),

                                    ServerControlButton(
                                      isRunning: _isRunning,
                                      isStartButton: false,
                                      onPressed: _isRunning ? _stopServer : null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                _buildDetailItem('Server Type:', 'Standalone .EXE'),
                                _buildDetailItem('Status:', _isRunning ? 'Running' : 'Stopped'),
                                _buildDetailItem('Port:', '3000'),
                                _buildDetailItem('Clients Connected:', '$_clientsConnected'),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        // RIGHT PANEL: TERMINAL LOGS
                        Expanded(
                          flex: 7,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22242A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'REAL-TIME LOGS',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white70),
                                        ),
                                        Text(
                                          'MGA LOGS SA PANAHON',
                                          style: TextStyle(fontSize: 10, color: Colors.white38),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Icon(Icons.terminal, size: 16, color: Colors.white54),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF141518),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.white10),
                                    ),
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: _logs.length,
                                      itemBuilder: (context, index) {
                                        final log = _logs[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                                          child: Text(
                                            log,
                                            style: TextStyle(
                                              fontFamily: 'monospace',
                                              fontSize: 12,
                                              color: log.contains('ERROR') 
                                                  ? Colors.redAccent 
                                                  : const Color(0xFF39E55A),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // FOOTER
                  const Center(
                    child: Text(
                      'App Version: v1.0.3 | © 2026 Print Solutions Cebu',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}