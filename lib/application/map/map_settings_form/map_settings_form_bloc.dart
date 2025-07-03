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
    on<_RadiusChanged>(_onRadiusChanged);
    on<_TypeChanged>(_onTypeChanged);
    on<_CategoriesChanged>(_onCategoriesChanged);
    on<_ResetSettings>(_onResetSettings);
  }

  void _onRadiusChanged(_RadiusChanged event, Emitter emit) => emit(
    state.copyWith(
      settings: state.settings.copyWith(
        radius: MapRadius(event.radius),
      ),
    ),
  );

  void _onTypeChanged(_TypeChanged event, Emitter emit) => emit(
    state.copyWith(
      settings: state.settings.copyWith(
        type: event.type,
      ),
    ),
  );

  void _onCategoriesChanged(_CategoriesChanged event, Emitter emit) => emit(
    state.copyWith(
      settings: state.settings.copyWith(
        categories: event.categories,
      ),
    ),
  );

  void _onResetSettings(_, Emitter emit) => emit(
    MapSettingsFormState.initial(),
  );
}
