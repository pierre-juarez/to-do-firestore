import 'package:flutter/material.dart';

enum AlertType { info, warning, danger }

void showAlert(BuildContext context, String message, AlertType type) {
  Color bgColor;
  Color borderColor;
  Color iconColor;
  IconData icon;
  Color textColor;

  switch (type) {
    case AlertType.info:
      bgColor = const Color(0xFFEEF5FF);
      borderColor = const Color(0xFF90CAF9);
      iconColor = const Color(0xFF1976D2);
      textColor = const Color(0xFF0D47A1);
      icon = Icons.info_outline;
      break;
    case AlertType.warning:
      bgColor = const Color(0xFFFFF8E1);
      borderColor = const Color(0xFFFFE082);
      iconColor = const Color(0xFFF9A825);
      textColor = const Color.fromARGB(255, 215, 140, 1);
      icon = Icons.warning_amber_rounded;
      break;
    case AlertType.danger:
      bgColor = const Color(0xFFFFEBEE);
      borderColor = const Color(0xFFEF9A9A);
      iconColor = const Color(0xFFD32F2F);
      textColor = const Color(0xFFB71C1C);
      icon = Icons.error_outline;
      break;
  }

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: TextStyle(fontSize: 16, color: textColor))),
        ],
      ),
    ),
    duration: const Duration(seconds: 5),
  );

  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(snackBar);
}
