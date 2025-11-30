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

import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart'
    as _i123;
import '../../features/auth/data/repositories/auth_repository_data.dart'
    as _i596;
import '../../features/auth/domain/repositories/auth_repository_domain.dart'
    as _i998;
import '../../features/auth/domain/usecases/auth_use_cases.dart' as _i544;
import '../../features/auth/presentation/bloc/auth_bloc/cubit/auth_cubit.dart'
    as _i157;
import '../../features/profiles/data/datasource/profiles_datasource.dart'
    as _i452;
import '../../features/profiles/data/repositories/profiles_repository.dart'
    as _i282;
import '../../features/profiles/domain/repositories/profiles_repository.dart'
    as _i141;
import '../../features/profiles/domain/usecase/profile_usecase.dart' as _i1022;
import 'injection.dart' as _i450;

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
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
      () => _i123.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i998.AuthRepositoryDomain>(
      () => _i596.AuthRepositoryImpl(gh<_i107.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i544.AuthUseCases>(
      () => _i544.AuthUseCases(gh<_i998.AuthRepositoryDomain>()),
    );
    gh.factory<_i452.ProfilesDatasource>(
      () => _i452.ApiProfileDatasource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i157.AuthCubit>(
      () => _i157.AuthCubit(gh<_i544.AuthUseCases>()),
    );
    gh.factory<_i141.ProfilesRepository>(
      () => _i282.ProfilesRepositoryData(gh<_i452.ProfilesDatasource>()),
    );
    gh.factory<_i1022.ProfileUsecase>(
      () => _i1022.ProfileUsecase(gh<_i141.ProfilesRepository>()),
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i450.ThirdPartyModule {}
