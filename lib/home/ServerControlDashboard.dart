import 'package:flutter/material.dart';
import 'package:print_queue_control/core/services/google_font_service.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import '../provider/ServerControlProvider.dart';
import '../shared/widget/ServerControlButton .dart';
import 'package:google_fonts/google_fonts.dart';

class ServerControlDashboard extends StatefulWidget {
  const ServerControlDashboard({super.key});

  @override
  State<ServerControlDashboard> createState() => _ServerControlDashboardState();
}

class _ServerControlDashboardState extends State<ServerControlDashboard> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

 

  @override
  Widget build(BuildContext context) {
    // context.watch ensures the widget rebuilds when state changes
    final provider = context.watch<ServerControlProvider>();

    // Scroll down automatically whenever logs update
    _scrollToBottom();

    return Scaffold(
      body: Column(
        children: [
          // HEADER BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF111215),
            child: const Row(
              children: [
                Icon(Icons.print_outlined, color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text(
                  'PRINTSERVER CONTROL CENTER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
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
                          color: provider.isRunning
                              ? const Color(0xFF39E55A)
                              : const Color(0xFFFF4D4D),
                          boxShadow: [
                            BoxShadow(
                              color: (provider.isRunning
                                      ? const Color(0xFF39E55A)
                                      : const Color(0xFFFF4D4D))
                                  .withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'System Status: ${provider.isRunning ? "ONLINE" : "OFFLINE"}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // MAIN CONTENT
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT PANEL: CONTROLS
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
                                      icon: Icons.play_arrow,
                                      text: 'START',
                                      isRunning: provider.isRunning,
                                      isStartButton: true,
                                      onPressed: provider.isRunning
                                          ? null
                                          : provider.startServer,
                                    ),
                                    const SizedBox(width: 12),
                                    ServerControlButton(
                                      icon: Icons.stop,
                                      text: 'STOP',
                                      isRunning: provider.isRunning,
                                      isStartButton: false,
                                      onPressed: provider.isRunning
                                          ? provider.stopServer
                                          : null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                _buildDetailItem(
                                  'Server Type:',
                                  'Standalone .EXE',
                                ),
                                _buildDetailItem(
                                  'Status:',
                                  provider.isRunning ? 'Running' : 'Stopped',
                                ),
                                _buildDetailItem('Port:', '3000'),
                                _buildDetailItem(
                                  'Clients Connected:',
                                  '${provider.clientsConnected}',
                                ),
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
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'REAL-TIME LOGS',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Text(
                                          'MGA LOGS SA PANAHON',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white38,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.terminal,
                                      size: 16,
                                      color: Colors.white54,
                                    ),
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
                                      border: Border.all(
                                        color: Colors.white10,
                                      ),
                                    ),
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: provider.logs.length,
                                      itemBuilder: (context, index) {
                                        final log = provider.logs[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2.0,
                                          ),
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
                  Center(
                    child: Text(
                      'PQMS CONTROL PANEL Version: v1.0.0 | © 2026 Print Queue Managment System',
                      style: GoogleFontServices.Poppins(
                        PoppinsColor: Colors.white38,
                        Poppinsfontsize: 14,
                        PoppinsfontWeight: FontWeight.bold,
                      ),
                      // TextStyle(color: Colors.white38, fontSize: 11),
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
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}