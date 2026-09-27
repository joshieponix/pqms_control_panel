import 'package:flutter/material.dart';
import 'package:print_queue_control/core/services/google_font_service.dart';

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
        Text(
          'DETECTED WEB APPS:',
          style: GoogleFontServices.Poppins(PoppinsColor:Colors.white70, PoppinsfontWeight:FontWeight.bold),
        ),
        const SizedBox(height: 6),
        if (webAppUrls.isEmpty)
        Text(
            'No Web Apps Detected',
            style: TextStyle(color: Colors.grey)
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
                    style: GoogleFontServices.Poppins(PoppinsColor:Colors.greenAccent, PoppinsDecoration: TextDecoration.underline)
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
