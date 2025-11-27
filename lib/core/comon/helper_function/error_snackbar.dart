// lib/core/widgets/error_snackbar.dart

import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String message) {
  // 1. إخفاء أي SnackBar مفتوح حالياً
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  // 2. عرض SnackBar جديد
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.red, // لون أحمر لتنبيه الخطأ
      duration: const Duration(seconds: 4),
      // إضافة سلوك لعرض SnackBar فوق الـ BottomNavigationBar إذا وُجد
      behavior: SnackBarBehavior.floating,
    ),
  );
}
