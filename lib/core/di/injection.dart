import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'injection.config.dart';

@module
abstract class ThirdPartyModule {
  @lazySingleton
  GetStorage get storage => GetStorage();

  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => getIt.init();
