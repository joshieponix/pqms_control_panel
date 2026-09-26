import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleFontServices{

   static  Poppins({
    double? Poppinsfontsize,
    FontWeight? PoppinsfontWeight,
    Color? PoppinsColor
   }){
      GoogleFonts.poppins(
        fontSize: Poppinsfontsize,
        fontWeight:PoppinsfontWeight,
        color: PoppinsColor
      );
   }

   

}