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
import 'package:pami/views/map/widgets/shout_out_pop_up_card.dart';

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
          markers: shoutOuts
              .map(
                (shoutOut) => _mapShoutOutToMarker(shoutOut, context),
              )
              .toSet(),
          onCameraMove: (position) => _onCameraMoved(context, position),
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

  Marker _mapShoutOutToMarker(
    ShoutOut shoutOut,
    BuildContext context,
  ) =>
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
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
            isScrollControlled: true, // Full-screen modal feel
            backgroundColor: Colors.transparent,
            builder: (_) => BlocProvider(
              create: (context) => getIt<InterestedShoutOutsActorBloc>(),
              child: ShoutOutPopupCard(shoutOut: shoutOut),
            ),
          );
        },
      );

  void _onCameraMoved(BuildContext context, CameraPosition position) =>
      context.read<MapControllerBloc>().add(
            MapControllerEvent.cameraPositionChanged(
              coordinates: Coordinates(
                latitude: Latitude(position.target.latitude),
                longitude: Longitude(position.target.longitude),
              ),
              zoom: position.zoom,
            ),
          );
}
