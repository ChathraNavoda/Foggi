import 'package:flutter/material.dart';

// class CustomSnackbar {
//   static void showCustomSnackbar(BuildContext context, String message,
//       {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.redAccent : Colors.green,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }

class CustomSnackbar {
  static void showCustomSnackbar(
    BuildContext context,
    String message, {
    bool isError = false,
    IconData? icon,
  }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 3),
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isError ? Colors.redAccent : Colors.green.shade600,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon ??
                  (isError ? Icons.error_outline : Icons.check_circle_outline),
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
