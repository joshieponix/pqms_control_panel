import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/widget/ServerControlButton .dart';
import '../provider/ServerControlProvider.dart';

class ServerControlDashboard extends StatefulWidget {
  const ServerControlDashboard({super.key});

  @override
  State<ServerControlDashboard> createState() => _ServerControlDashboardState();
}

class _ServerControlDashboardState extends State<ServerControlDashboard> {
  // final List<String> context.of<Servercontrolprovider>().logs = [];
  final ScrollController _scrollController = ScrollController();

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
                const Icon(
                  Icons.print_outlined,
                  color: Colors.white70,
                  size: 20,
                ),
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
                          color: context.read<Servercontrolprovider>().isRunning
                              ? const Color(0xFF39E55A)
                              : const Color(0xFFFF4D4D),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (context
                                              .read<Servercontrolprovider>()
                                              .isRunning
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
                        'System Status: ${context.read<Servercontrolprovider>().isRunning ? "ONLINE" : "OFFLINE"}',
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
                                      isRunning: context
                                          .read<Servercontrolprovider>()
                                          .isRunning,
                                      isStartButton: true,
                                      onPressed:
                                          context
                                              .read<Servercontrolprovider>()
                                              .isRunning
                                          ? null
                                          : context
                                                .read<Servercontrolprovider>()
                                                .startServer,
                                    ),

                                    const SizedBox(width: 12),

                                    ServerControlButton(
                                      isRunning: context
                                          .read<Servercontrolprovider>()
                                          .isRunning,
                                      isStartButton: false,
                                      onPressed:
                                          context
                                              .read<Servercontrolprovider>()
                                              .isRunning
                                          ? context
                                                .read<Servercontrolprovider>()
                                                .stopServer
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
                                  context
                                          .read<Servercontrolprovider>()
                                          .isRunning
                                      ? 'Running'
                                      : 'Stopped',
                                ),
                                _buildDetailItem('Port:', '3000'),
                                _buildDetailItem(
                                  'Clients Connected:',
                                  '${context.read<Servercontrolprovider>().clientsConnected}',
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
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
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Icon(
                                        Icons.terminal,
                                        size: 16,
                                        color: Colors.white54,
                                      ),
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
                                      border: Border.all(color: Colors.white10),
                                    ),
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: context
                                          .read<Servercontrolprovider>()
                                          .logs
                                          .length,
                                      itemBuilder: (context, index) {
                                        final log = context
                                            .read<Servercontrolprovider>()
                                            .logs[index];
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
