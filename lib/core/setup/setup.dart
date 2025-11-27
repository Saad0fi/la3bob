import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:la3bob/core/setup/setup.config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class RegisterModule {
  @LazySingleton()
  SupabaseClient get supabaseClient => Supabase.instance.client;
}

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true, //
)
void configureDependencies() => getIt.init();
