import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/models/location_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationsNotifier extends Notifier<List<SavedLocation>> {
  @override
  List<SavedLocation> build() {
    _loadLocations();
    return [
      const SavedLocation(id: 'loc_1', address: ''),
      const SavedLocation(id: 'loc_2', address: ''),
    ];
  }

  Future<void> _loadLocations() async {
    final storage = ref.read(appStorageServiceProvider);
    final data = await storage.getItem('user_locations');
    if (data != null && data is List) {
      state = data.map((e) => SavedLocation.fromMap(Map<String, dynamic>.from(e as Map))).toList();
    }
  }

  Future<void> _persistLocations(List<SavedLocation> locations) async {
    final storage = ref.read(appStorageServiceProvider);
    final data = locations.map((e) => e.toMap()).toList();
    await storage.addItem('user_locations', data);
  }

  void setLocations(List<SavedLocation> locations) {
    state = locations;
    _persistLocations(state);
  }

  void updateLocation(SavedLocation updated) {
    state = [
      for (final loc in state)
        if (loc.id == updated.id) updated else loc,
    ];
    _persistLocations(state);
  }

  void addLocation(SavedLocation location) {
    state = [...state, location];
    _persistLocations(state);
  }

  void removeLocation(String id) {
    state = state.where((l) => l.id != id).toList();
    _persistLocations(state);
  }
}

final locationsProvider =
    NotifierProvider<LocationsNotifier, List<SavedLocation>>(
      LocationsNotifier.new,
    );

final activeLocationEditsProvider = StateProvider.autoDispose<int>((ref) => 0);

class DefaultLocationNotifier extends Notifier<String?> {
  @override
  String? build() {
    _loadDefaultLocation();
    return null;
  }

  Future<void> _loadDefaultLocation() async {
    final storage = ref.read(appStorageServiceProvider);
    final data = await storage.getItem('default_location_id');
    if (data != null && data is String) {
      state = data;
    }
  }

  void setDefaultLocation(String? id) {
    state = id;
    ref.read(appStorageServiceProvider).addItem('default_location_id', id);
  }
}

final defaultLocationIdProvider =
    NotifierProvider<DefaultLocationNotifier, String?>(
      DefaultLocationNotifier.new,
    );
