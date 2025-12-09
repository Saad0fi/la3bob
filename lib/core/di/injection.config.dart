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
import 'package:local_auth/local_auth.dart' as _i152;
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
import '../../features/profiles/data/datasource/profiles_utility_datasource.dart'
    as _i382;
import '../../features/profiles/data/repositories/profiles_repository.dart'
    as _i282;
import '../../features/profiles/domain/repositories/profiles_repository.dart'
    as _i141;
import '../../features/profiles/domain/usecase/profile_usecase.dart' as _i1022;
import '../../features/videos/data/datasource/videos_datasource.dart' as _i889;
import '../../features/videos/data/repositories/videos_repository.dart'
    as _i622;
import '../../features/videos/domain/repositories/videos_repository.dart'
    as _i836;
import '../../features/videos/domain/usecase/videos_usecase.dart' as _i362;
import '../../features/videos/presentation/bloc/videos_bloc.dart' as _i135;
import 'injection.dart' as _i464;

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
    gh.factory<_i382.ProfilesUtilityDataSource>(
      () => _i382.ProfilesUtilityDataSourceImpl(
        gh<_i792.GetStorage>(),
        gh<_i152.LocalAuthentication>(),
      ),
    );
    gh.lazySingleton<_i998.AuthRepositoryDomain>(
      () => _i596.AuthRepositoryImpl(gh<_i107.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i544.AuthUseCases>(
      () => _i544.AuthUseCases(gh<_i998.AuthRepositoryDomain>()),
    );
    gh.factory<_i889.VideosDatasource>(
      () => _i889.ApiVideosDatasource(gh<_i454.SupabaseClient>()),
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
    gh.factory<_i836.VideosRepository>(
      () => _i622.VideosRepositoryData(gh<_i889.VideosDatasource>()),
    );
    gh.factory<_i1022.ProfileUsecase>(
      () => _i1022.ProfileUsecase(gh<_i141.ProfilesRepository>()),
    );
    gh.factory<_i362.VideosUsecase>(
      () => _i362.VideosUsecase(gh<_i836.VideosRepository>()),
    );
    gh.factory<_i135.VideosBloc>(
      () => _i135.VideosBloc(
        gh<_i362.VideosUsecase>(),
        gh<_i1022.ProfileUsecase>(),
        gh<_i544.AuthUseCases>(),
      ),
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i464.ThirdPartyModule {}
