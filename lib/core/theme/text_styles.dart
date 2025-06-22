import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/colors.dart';

class AppTextStyles {
  static final header = GoogleFonts.play(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static final subtitle = GoogleFonts.play(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.grey.shade600,
  );

  static final body = GoogleFonts.play(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
