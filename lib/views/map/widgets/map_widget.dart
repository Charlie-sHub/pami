import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pami/application/interested_shout_outs/interested_shout_outs_actor/interested_shout_outs_actor_bloc.dart';
import 'package:pami/application/map/map_controller/map_controller_bloc.dart';
import 'package:pami/domain/core/entities/coordinates.dart';
import 'package:pami/domain/core/entities/shout_out.dart';
import 'package:pami/domain/core/validation/objects/latitude.dart';
import 'package:pami/domain/core/validation/objects/longitude.dart';
import 'package:pami/injection.dart';
import 'package:pami/views/core/misc/bitmap_icon_loader.dart';
import 'package:pami/views/map/widgets/shout_out_modal.dart';

/// Google map widget
class MapWidget extends StatelessWidget {
  /// Default constructor
  const MapWidget({
    required this.shoutOuts,
    super.key,
  });

  /// Markers to display
  final Set<ShoutOut> shoutOuts;

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<Map<String, BitmapDescriptor>>(
        future: getIt<BitmapIconLoader>().loadAll(),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return BlocBuilder<MapControllerBloc, MapControllerState>(
              builder: (context, state) {
                if (!state.initialized) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return GoogleMap(
                    mapType: MapType.hybrid,
                    myLocationEnabled: true,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        state.coordinates.latitude.getOrCrash(),
                        state.coordinates.longitude.getOrCrash(),
                      ),
                      zoom: state.zoom,
                      tilt: 45,
                    ),
                    markers: _mapToMarker(
                      shoutOuts,
                      snapshot.data!,
                      context,
                    ),
                    onCameraMove: (position) => _onMoved(
                      context.read<MapControllerBloc>(),
                      position,
                    ),
                  );
                }
              },
            );
          }
        },
      );

  Set<Marker> _mapToMarker(
    Set<ShoutOut> shoutOuts,
    Map<String, BitmapDescriptor> icons,
    BuildContext context,
  ) => shoutOuts.map(
    (shout) {
      String? categoryKey;
      if (shout.categories.isNotEmpty) {
        categoryKey = shout.categories.first.name;
      }
      return Marker(
        markerId: MarkerId(shout.id.toString()),
        position: LatLng(
          shout.coordinates.latitude.getOrCrash(),
          shout.coordinates.longitude.getOrCrash(),
        ),
        icon: (categoryKey != null && icons.containsKey(categoryKey))
            ? icons[categoryKey]!
            : BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: shout.title.getOrCrash(),
          snippet: shout.description.getOrCrash(),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            useRootNavigator: true,
            builder: (_) => BlocProvider(
              create: (ctx) => getIt<InterestedShoutOutsActorBloc>(),
              child: ShoutOutModal(shoutOut: shout),
            ),
          );
        },
      );
    },
  ).toSet();

  void _onMoved(MapControllerBloc bloc, CameraPosition position) {
    bloc.add(
      MapControllerEvent.cameraPositionChanged(
        coordinates: Coordinates(
          latitude: Latitude(position.target.latitude),
          longitude: Longitude(position.target.longitude),
        ),
        zoom: position.zoom,
      ),
    );
  }
}
