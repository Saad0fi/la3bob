import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionDialog extends StatelessWidget {
  const CameraPermissionDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CameraPermissionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("مطلوب إذن الكاميرا"),
      content: const Text(
        "نحتاج إلى الوصول للكاميرا لبدء اللعبة وتشغيلها بشكل صحيح.",
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Pop dialog then pop page to go back
            Navigator.of(context).pop();
            // Verify if we can pop the page as well
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          },
          child: const Text("إلغاء", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            // Close dialog first, then open settings
            Navigator.of(context).pop();
            openAppSettings();
          },
          child: const Text("تغيير الإذن"),
        ),
      ],
    );
  }
}
