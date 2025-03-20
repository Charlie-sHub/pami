import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pami/application/map/map_settings_form/map_settings_form_bloc.dart';
import 'package:pami/domain/core/misc/enums/category.dart';
import 'package:pami/domain/core/misc/enums/shout_out_type.dart';
import 'package:pami/domain/core/validation/objects/map_radius.dart';

/// Map settings sheet widget
class MapSettingsSheet extends StatelessWidget {
  /// Default constructor
  const MapSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MapSettingsFormBloc, MapSettingsFormState>(
        builder: (context, state) {
          final bloc = context.read<MapSettingsFormBloc>();
          final settings = state.settings;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Radius: ${settings.radius} km'),
                Slider(
                  value: settings.radius.getOrCrash(),
                  divisions: MapRadius.limit.toInt() - 1,
                  min: 1,
                  max: MapRadius.limit,
                  onChanged: (value) => bloc.add(
                    MapSettingsFormEvent.radiusChanged(value),
                  ),
                ),
                const Text('Type'),
                DropdownButton<ShoutOutType>(
                  value: settings.type,
                  onChanged: (value) {
                    if (value != null) {
                      bloc.add(MapSettingsFormEvent.typeChanged(value));
                    }
                  },
                  items: ShoutOutType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        ),
                      )
                      .toList(),
                ),
                const Text('Categories'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 8,
                    children: Category.values.map(
                      (category) {
                        final isSelected = settings.categories.contains(
                          category,
                        );
                        return ChoiceChip(
                          label: Text(category.name),
                          selected: isSelected,
                          onSelected: (_) {
                            final updatedCategories = isSelected
                                ? settings.categories.difference({category})
                                : settings.categories.union({category});
                            bloc.add(
                              MapSettingsFormEvent.categoriesChanged(
                                updatedCategories,
                              ),
                            );
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
                TextButton(
                  onPressed: () => bloc.add(
                    const MapSettingsFormEvent.resetSettings(),
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
          );
        },
      );
}
