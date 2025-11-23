// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:get_storage/get_storage.dart' as _i792;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../features/profiles/data/datasource/profiles_datasource.dart' as _i415;
import '../features/profiles/data/repositories/profiles_repository.dart'
    as _i1022;
import '../features/profiles/domain/repositories/profiles_repository.dart'
    as _i874;
import '../features/profiles/domain/usecase/profile_usecase.dart' as _i733;
import 'setup.dart' as _i450;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final thirdPartyModule = _$ThirdPartyModule();
    gh.lazySingleton<_i792.GetStorage>(() => thirdPartyModule.storage);
    gh.lazySingleton<_i454.SupabaseClient>(
      () => thirdPartyModule.supabaseClient,
    );
    gh.factory<_i415.ProfilesDatasource>(
      () => _i415.ApiProfileDatasource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i874.ProfilesRepository>(
      () => _i1022.ProfilesRepositoryData(gh<_i415.ProfilesDatasource>()),
    );
    gh.factory<_i733.ProfileUsecase>(
      () => _i733.ProfileUsecase(gh<_i874.ProfilesRepository>()),
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i450.ThirdPartyModule {}
