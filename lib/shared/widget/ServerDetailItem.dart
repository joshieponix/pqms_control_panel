import 'package:flutter/material.dart';
import 'package:print_queue_control/core/services/google_font_service.dart';

class Serverdetailitem extends StatefulWidget {
  final String label;
  final dynamic value;
  const Serverdetailitem({super.key, required this.label, required this.value});

  @override
  State<Serverdetailitem> createState() => _ServerdetailitemState();
}

class _ServerdetailitemState extends State<Serverdetailitem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            widget.label,
            style: GoogleFontServices.Poppins(
              PoppinsColor: Colors.white70,
              Poppinsfontsize: 13
            )
          ),
          const SizedBox(width: 8),
          Text(
            widget.value,
            style: GoogleFontServices.Poppins(
              PoppinsColor: Colors.white,
              PoppinsfontWeight: FontWeight.bold,
              Poppinsfontsize: 13,
            ),
          ),
        ],
      ),
    );
  }
}