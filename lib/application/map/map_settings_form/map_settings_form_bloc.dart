import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';

part 'map_settings_form_bloc.freezed.dart';
part 'map_settings_form_event.dart';
part 'map_settings_form_state.dart';

/// Map settings bloc
@injectable
class MapSettingsFormBloc
    extends Bloc<MapSettingsFormEvent, MapSettingsFormState> {
  /// Default constructor
  MapSettingsFormBloc() : super(MapSettingsFormState.initial()) {
    on<MapSettingsFormEvent>(
      (event, emit) => event.when(
        radiusChanged: (radius) => emit(
          state.copyWith(
            settings: state.settings.copyWith(
              radius: MapRadius(radius),
            ),
          ),
        ),
        typeChanged: (type) => emit(
          state.copyWith(
            settings: state.settings.copyWith(
              type: type,
            ),
          ),
        ),
        categoriesChanged: (categories) => emit(
          state.copyWith(
            settings: state.settings.copyWith(
              categories: categories,
            ),
          ),
        ),
        resetSettings: () => emit(
          MapSettingsFormState.initial(),
        ),
      ),
    );
  }
}
