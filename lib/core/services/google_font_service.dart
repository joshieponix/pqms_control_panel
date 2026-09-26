import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleFontServices{

   static  Poppins({
    double? Poppinsfontsize,
    double? PoppinsSpacing,
    FontWeight? PoppinsfontWeight,
    Color? PoppinsColor
   }){
      GoogleFonts.poppins(
        fontStyle: FontStyle.italic,
        fontSize: Poppinsfontsize,
        fontWeight:PoppinsfontWeight,
        color: PoppinsColor,
        letterSpacing: PoppinsSpacing
      );
   }



}