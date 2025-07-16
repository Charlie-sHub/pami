import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:pami/domain/core/misc/enums/category.dart';

/// Loader for our marker bitmaps.
abstract class BitmapIconLoader {
  /// Loads *once* all of our marker bitmaps, keyed by category name.
  /// afterwards returns the cached values.
  Future<Map<String, BitmapDescriptor>> loadAll();
}

/// Implementation of [BitmapIconLoader].
@LazySingleton(as: BitmapIconLoader)
class BitmapIconLoaderImplementation implements BitmapIconLoader {
  Map<String, BitmapDescriptor>? _cache;

  @override
  Future<Map<String, BitmapDescriptor>> loadAll() async {
    if (_cache != null) {
      return _cache!;
    } else {
      final entries = await Future.wait(
        Category.values.map(
          (category) async {
            final bitmap = await BitmapDescriptor.asset(
              const ImageConfiguration(devicePixelRatio: 5),
              'assets/images/markers/${category.name}.png',
            );
            return MapEntry(category.name, bitmap);
          },
        ),
      );
      _cache = Map.fromEntries(entries);
      return _cache!;
    }
  }
}
