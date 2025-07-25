import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/map/map_controller/map_controller_bloc.dart';
import 'package:pami/application/map/map_settings_form/map_settings_form_bloc.dart';
import 'package:pami/application/map/map_watcher/map_watcher_bloc.dart';
import 'package:pami/domain/core/entities/map_settings.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/map/widgets/error_card.dart';
import 'package:pami/views/map/widgets/map_settings_button.dart';
import 'package:pami/views/map/widgets/map_widget.dart';

/// Map view widget
class MapView extends StatelessWidget {
  /// Default constructor
  const MapView({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<MapSettingsFormBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt<MapControllerBloc>()
              ..add(
                const MapControllerEvent.locationPermissionRequested(),
              ),
          ),
          BlocProvider(
            create: (context) => getIt<MapWatcherBloc>()
              ..add(
                MapWatcherEvent.watchStarted(MapSettings.empty()),
              ),
          ),
        ],
        child: BlocListener<MapSettingsFormBloc, MapSettingsFormState>(
          listener: _listener,
          child: BlocBuilder<MapWatcherBloc, MapWatcherState>(
            builder: (builderContext, state) {
              const space = kBottomNavigationBarHeight;
              return Stack(
                children: [
                  MapWidget(
                    shoutOuts: switch (state) {
                      LoadSuccess(:final shoutOuts) => shoutOuts,
                      _ => {},
                    },
                  ),
                  switch (state) {
                    ActionInProgress() => const Positioned(
                        top: space,
                        left: space,
                        child: CircularProgressIndicator(),
                      ),
                    LoadFailure(:final failure) => Positioned(
                        top: space,
                        left: space,
                        right: space,
                        child: ErrorCard(failure: failure),
                      ),
                    _ => const SizedBox.shrink(),
                  },
                  const Positioned(
                    bottom: space * 1.6,
                    right: 10,
                    child: MapSettingsButton(),
                  ),
                ],
              );
            },
          ),
        ),
      );

  void _listener(BuildContext context, MapSettingsFormState state) {
    context.read<MapWatcherBloc>().add(
          MapWatcherEvent.watchStarted(state.settings),
        );
  }
}
