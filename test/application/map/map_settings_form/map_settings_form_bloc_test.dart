import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pami/application/map/map_settings_form/map_settings_form_bloc.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';

void main() {
  late MapSettingsFormBloc mapSettingsFormBloc;

  const validRadius = 10.0;
  const validType = ShoutOutType.request;
  const validCategories = {Category.food, Category.volunteering};

  setUp(
    () {
      mapSettingsFormBloc = MapSettingsFormBloc();
    },
  );

  group(
    'Testing on success',
    () {
      blocTest<MapSettingsFormBloc, MapSettingsFormState>(
        'emits a state with the changed radius when RadiusChanged is added',
        build: () => mapSettingsFormBloc,
        act: (bloc) => bloc.add(
          const MapSettingsFormEvent.radiusChanged(validRadius),
        ),
        expect: () => [
          MapSettingsFormState.initial().copyWith(
            settings: MapSettings.empty().copyWith(
              radius: MapRadius(validRadius),
            ),
          ),
        ],
      );

      blocTest<MapSettingsFormBloc, MapSettingsFormState>(
        'emits a state with the changed type when TypeChanged is added',
        build: () => mapSettingsFormBloc,
        act: (bloc) => bloc.add(
          const MapSettingsFormEvent.typeChanged(validType),
        ),
        expect: () => [
          MapSettingsFormState.initial().copyWith(
            settings: MapSettings.empty().copyWith(
              type: validType,
              radius: MapRadius(validRadius),
            ),
          ),
        ],
      );

      blocTest<MapSettingsFormBloc, MapSettingsFormState>(
        'emits a state with the changed categories '
        'when CategoriesChanged is added',
        build: () => mapSettingsFormBloc,
        act: (bloc) => bloc.add(
          const MapSettingsFormEvent.categoriesChanged(validCategories),
        ),
        expect: () => [
          MapSettingsFormState.initial().copyWith(
            settings: MapSettings.empty().copyWith(
              categories: validCategories,
              radius: MapRadius(validRadius),
            ),
          ),
        ],
      );

      blocTest<MapSettingsFormBloc, MapSettingsFormState>(
        'emits the initial state when ResetSettings is added',
        build: () => mapSettingsFormBloc,
        act: (bloc) => bloc.add(
          const MapSettingsFormEvent.resetSettings(),
        ),
        expect: () => [
          MapSettingsFormState.initial(),
        ],
      );
    },
  );
}
