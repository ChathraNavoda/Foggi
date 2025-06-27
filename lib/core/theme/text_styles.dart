import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class AppTextStyles {
  static final header = GoogleFonts.play(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static final subtitle = GoogleFonts.play(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static final body = GoogleFonts.play(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static final buttonMain = GoogleFonts.play(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static final buttonGame = GoogleFonts.play(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final buttonCommon = GoogleFonts.play(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static final warning = GoogleFonts.play(
    color: AppColors.textDark,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
