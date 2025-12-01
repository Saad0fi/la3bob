import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:la3bob/core/di/injection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// دالة مسؤولة عن  التهيئة والخدمات قبل تشغيل التطبيق
Future<void> setupAppDependencies() async {
  await dotenv.load(fileName: '.env');

  await GetStorage.init();

  final url = dotenv.env['urlSupa'];
  final anonKey = dotenv.env['keySupa'];

  await Supabase.initialize(url: url!, anonKey: anonKey!);

  configureDependencies();
}
