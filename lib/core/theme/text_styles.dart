import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class AppTextStyles {
  static final header = GoogleFonts.play(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.accentOrange,
  );

  static final subtitle = GoogleFonts.play(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.accentBlue,
  );

  static final body = GoogleFonts.play(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  static final buttonMain = GoogleFonts.play(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  static final buttonGame = GoogleFonts.play(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  static final buttonCommon = GoogleFonts.play(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}
