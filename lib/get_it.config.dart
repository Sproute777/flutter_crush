// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_crush/level/data/level_repository.dart' as _i3;
import 'package:flutter_crush/level/domain/level_interactor.dart' as _i4;
import 'package:flutter_crush/level/view/levels_cubit.dart' as _i5;
import 'package:flutter_crush/level/view/selected_level_cubit.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.ILevelRepository>(() => _i3.LevelRepository());
    gh.lazySingleton<_i4.LevelInteractor>(
      () => _i4.LevelInteractor(gh<_i3.ILevelRepository>()),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i5.LevelsCubit>(
        () => _i5.LevelsCubit(gh<_i4.LevelInteractor>()));
    gh.factory<_i6.SelectedLevel>(
        () => _i6.SelectedLevel(gh<_i4.LevelInteractor>()));
    return this;
  }
}
