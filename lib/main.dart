import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:la3bob/core/setup.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  
  await Supabase.initialize(
    url: 'https://dwdyzumorfwynnainszz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR3ZHl6dW1vcmZ3eW5uYWluc3p6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM2MzgyMTMsImV4cCI6MjA3OTIxNDIxM30.s8VBthQuIynlqbi7AOVxgRuVASBMT2oZ-O2fyzCODys',
  );

  configureDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
