import 'package:flutter/material.dart';

class ServerControlButton extends StatelessWidget {
  final bool isRunning;
  final bool isStartButton;
  final VoidCallback? onPressed;

  const ServerControlButton({
    super.key,
    required this.isRunning,
    required this.isStartButton,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isStart = isStartButton;
    return Expanded(
      child: SizedBox(
          height: 90,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        backgroundColor: isStart
                            ? (isRunning
                                ? const Color(0xFF33363F)
                                    : const Color(0xFF39E55A))
                                      : (isRunning
                                            ? const Color(0xFF2D2F36)
                                          : const Color(0xFF1E2025)),
                                        foregroundColor: isStart ? Colors.black : Colors.white,
                                    shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                              ),
                          elevation: isRunning ? 0 : 4,
                        ),
                    onPressed: onPressed,
                child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: const [
            Icon(Icons.play_arrow, size: 28),
                SizedBox(height: 4),
                    Text(
                        'START SERVER',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                    Text(
                'STOP SERVER',
              style: TextStyle(fontSize: 10, color: Colors.black54),
            ),
        ],
    ),
      ),
        ),
      );
    }
}
