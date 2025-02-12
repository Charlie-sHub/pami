import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/application/map/map_settings/map_settings_bloc.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';

void main() {
  late MapSettingsBloc mapSettingsBloc;

  const validRadius = 10.0;
  const validType = ShoutOutType.request;
  const validCategories = {Category.food, Category.volunteering};

  setUp(
    () {
      mapSettingsBloc = MapSettingsBloc();
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<MapSettingsBloc, MapSettingsState>(
        'emits a state with the changed radius when RadiusChanged is added',
        build: () => mapSettingsBloc,
        act: (bloc) => bloc.add(
          const MapSettingsEvent.radiusChanged(validRadius),
        ),
        expect: () => [
          MapSettingsState.initial().copyWith(
            settings: MapSettings.empty().copyWith(
              radius: MapRadius(validRadius),
            ),
          ),
        ],
      );

      blocTest<MapSettingsBloc, MapSettingsState>(
        'emits a state with the changed type when TypeChanged is added',
        build: () => mapSettingsBloc,
        act: (bloc) => bloc.add(
          const MapSettingsEvent.typeChanged(validType),
        ),
        expect: () => [
          MapSettingsState.initial().copyWith(
            settings: MapSettings.empty().copyWith(
              type: validType,
            ),
          ),
        ],
      );

      blocTest<MapSettingsBloc, MapSettingsState>(
        'emits a state with the changed categories '
        'when CategoriesChanged is added',
        build: () => mapSettingsBloc,
        act: (bloc) => bloc.add(
          const MapSettingsEvent.categoriesChanged(validCategories),
        ),
        expect: () => [
          MapSettingsState.initial().copyWith(
            settings: MapSettings.empty().copyWith(
              categories: validCategories,
            ),
          ),
        ],
      );

      blocTest<MapSettingsBloc, MapSettingsState>(
        'emits the initial state when ResetSettings is added',
        build: () => mapSettingsBloc,
        act: (bloc) => bloc.add(
          const MapSettingsEvent.resetSettings(),
        ),
        expect: () => [
          MapSettingsState.initial(),
        ],
      );
    },
  );
}
