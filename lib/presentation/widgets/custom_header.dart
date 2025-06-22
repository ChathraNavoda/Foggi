import 'package:flutter/material.dart';

import '../../core/theme/text_styles.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  const CustomHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.header);
  }
}
