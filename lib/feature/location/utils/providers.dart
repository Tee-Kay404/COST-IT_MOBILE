// lib/feature/location/utils/providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Holds the user's selected location display string, e.g. "Ikeja, Lagos State"
final selectedLocationProvider = StateProvider<String?>((ref) => null);

/// Holds just the selected LGA name
final selectedLgaProvider = StateProvider<String?>((ref) => null);

/// Holds the selected state name
final selectedStateProvider = StateProvider<String?>((ref) => null);

/// GPS location detection state
enum GpsStatus { idle, loading, success, error }

class GpsLocationNotifier extends StateNotifier<AsyncValue<String?>> {
  GpsLocationNotifier() : super(const AsyncValue.data(null));

  Future<void> detectLocation(WidgetRef ref) async {
    state = const AsyncValue.loading();
    try {
      // 1. Check & request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = AsyncValue.error(
            'Location permission denied',
            StackTrace.current,
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        state = AsyncValue.error(
          'Location permission permanently denied',
          StackTrace.current,
        );
        return;
      }

      // 2. Get position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3. Reverse geocode to get LGA / area name
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // subLocality = LGA/area, administrativeArea = State
        final lga = place.subLocality ?? place.locality ?? '';
        final stateRaw = place.administrativeArea ?? '';

        final displayText = lga.isNotEmpty ? '$lga, $stateRaw' : stateRaw;

        ref.read(selectedLocationProvider.notifier).state = displayText;
        ref.read(selectedLgaProvider.notifier).state = lga;
        ref.read(selectedStateProvider.notifier).state = stateRaw;

        state = AsyncValue.data(displayText);
      } else {
        state = AsyncValue.error(
          'Could not determine location',
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
}

final gpsLocationProvider =
    StateNotifierProvider<GpsLocationNotifier, AsyncValue<String?>>(
      (ref) => GpsLocationNotifier(),
    );
