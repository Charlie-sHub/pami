import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/map/map_settings_form/map_settings_form_bloc.dart';
import 'package:pami/views/map/widgets/map_settings_sheet.dart';

/// Map settings button widget
class MapSettingsButton extends StatelessWidget {
  /// Default constructor
  const MapSettingsButton({super.key});

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        mini: true,
        heroTag: null,
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (_) => BlocProvider.value(
            value: context.read<MapSettingsFormBloc>(),
            child: const MapSettingsSheet(),
          ),
        ),
        child: const Icon(Icons.tune),
      );
}
