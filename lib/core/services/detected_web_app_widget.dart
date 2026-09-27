import 'package:flutter/material.dart';

class DetectedWebAppsWidget extends StatelessWidget {
  final List<String> webAppUrls;
  final Function(String url)? onUrlTap;

  const DetectedWebAppsWidget({
    super.key,
    required this.webAppUrls,
    this.onUrlTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'DETECTED WEB APPS:',
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        if (webAppUrls.isEmpty)
          const Text(
            'No Web Apps Detected',
            style: TextStyle(color: Colors.grey),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: webAppUrls.map((url) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: InkWell(
                  onTap: onUrlTap != null ? () => onUrlTap!(url) : null,
                  borderRadius: BorderRadius.circular(4),
                  child: SelectableText(
                    url,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
