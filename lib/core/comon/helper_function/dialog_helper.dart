import 'package:flutter/material.dart';

// تأكيد الحذف
Future<void> showDeleteConfirmationDialog({
  required BuildContext context,
  required String itemName, // اسم العنصر المراد حذفه
  required VoidCallback onConfirm, // الدالة التي سيتم تنفيذها عند التأكيد
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: Text(
          "هل أنت متأكد أنك تريد حذف $itemName؟ لا يمكن التراجع عن هذا الإجراء.",
        ),
        actions: [
          TextButton(
            child: const Text("إلغاء"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("تأكيد"),
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// تسجيل الخروج

Future<void> showLogoutConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirmLogout,
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("تأكيد تسجيل الخروج"),
        content: const Text(
          "هل أنت متأكد من أنك تريد تسجيل الخروج من هذا الحساب؟",
        ),
        actions: [
          TextButton(
            child: const Text("إلغاء"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("تأكيد"),
            onPressed: () {
              onConfirmLogout();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
