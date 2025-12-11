import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//  تحديد مدة ظهور التوست
const Toast length = Toast.LENGTH_LONG; //هنا بتكون 5 ثوانٍ

// هنا  نحدد ألوان محددة
enum ToastType {
  success, // أخضر للنجاح
  failure, // أحمر للفشل والخطأ
  warning, // برتقالي للتحذير
  info, // أزرق للمعلومات العامة (مثل جارٍ الانتقال)
}

//  هيلبر ميثود لاختيار اللون بناءً على النوع
Color _getToastColor(ToastType type) {
  switch (type) {
    case ToastType.success:
      return Colors.green.shade700;
    case ToastType.failure:
      return Colors.red.shade700;
    case ToastType.warning:
      return Colors.orange.shade700;
    case ToastType.info:
      return Colors.blue.shade700;
  }
}

void showAppToast({
  required String message,
  ToastType type = ToastType.info, // القيمة الافتراضية هي info
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: length,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: _getToastColor(type),
    textColor: Colors.white,
    fontSize: 14.0,
  );
}
