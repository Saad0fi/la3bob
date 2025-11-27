// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
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
    as _i117;
import 'setup.dart' as _i450;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
      () => _i123.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i998.AuthRepositoryDomain>(
      () => _i596.AuthRepositoryImpl(gh<_i107.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i544.AuthUseCases>(
      () => _i544.AuthUseCases(gh<_i998.AuthRepositoryDomain>()),
    );
    gh.factory<_i117.AuthCubit>(
      () => _i117.AuthCubit(gh<_i544.AuthUseCases>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i450.RegisterModule {}
