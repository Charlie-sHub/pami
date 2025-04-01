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
      BlocBuilder<MapControllerBloc, MapControllerState>(
        builder: (context, state) => GoogleMap(
          mapType: MapType.hybrid,
          myLocationEnabled: true,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          markers: _mapToMarker(shoutOuts, context),
          onCameraMove: (position) => _onMoved(
            context.read<MapControllerBloc>(),
            position,
          ),
          initialCameraPosition: CameraPosition(
            target: LatLng(
              state.coordinates.latitude.getOrCrash(),
              state.coordinates.longitude.getOrCrash(),
            ),
            zoom: state.zoom,
            tilt: 45,
          ),
        ),
      );

  Set<Marker> _mapToMarker(Set<ShoutOut> shoutOuts, BuildContext context) {
    final markers = <Marker>{};
    for (final shoutOut in shoutOuts) {
      markers.add(
        Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          markerId: MarkerId(shoutOut.id.toString()),
          position: LatLng(
            shoutOut.coordinates.latitude.getOrCrash(),
            shoutOut.coordinates.longitude.getOrCrash(),
          ),
          infoWindow: InfoWindow(
            title: shoutOut.title.getOrCrash(),
            snippet: shoutOut.description.getOrCrash(),
          ),
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              useRootNavigator: true,
              builder: (_) => BlocProvider(
                create: (context) => getIt<InterestedShoutOutsActorBloc>(),
                child: ShoutOutModal(shoutOut: shoutOut),
              ),
            );
          },
        ),
      );
    }
    return markers;
  }

  void _onMoved(MapControllerBloc bloc, CameraPosition position) => bloc.add(
        MapControllerEvent.cameraPositionChanged(
          coordinates: Coordinates(
            latitude: Latitude(position.target.latitude),
            longitude: Longitude(position.target.longitude),
          ),
          zoom: position.zoom,
        ),
      );
}
