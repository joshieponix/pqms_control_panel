import 'package:flutter/material.dart';

class ServerControlButton extends StatelessWidget {
  final bool isRunning;
  final bool isStartButton;
  final VoidCallback? onPressed;
  final String text;
  final IconData icon;

  const ServerControlButton({
    super.key,
    required this.isRunning,
    required this.isStartButton,
    required this.onPressed,
    required this.text,
    required this.icon
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
                                    : const Color.fromARGB(255, 27, 92, 2)) //const Color(0xFF39E55A))
                                      : (isRunning
                                            ?  const Color.fromARGB(255, 182, 1, 1) 
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
        children: [
            Icon(icon, size: 28),
                SizedBox(height: 4),
                 Text(text,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
    ),
      ),
        ),
      );
    }
}
