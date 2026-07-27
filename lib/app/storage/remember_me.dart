import 'dart:developer';

import 'package:cost_it_mobile/app/storage/app_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RememberMeKeys {
  RememberMeKeys._(); 
  static const identifier = 'rememberIdentifier'; 
  static const enabled    = 'rememberMe';         
}

class RememberMeService {
  final _store = HiveStorageService<String, String>(boxName: 'authStore');

  Future<void> save(String identifier) async {
    try {
      await _store.addItem(RememberMeKeys.identifier, identifier);
      await _store.addItem(RememberMeKeys.enabled, 'true');
    } catch (e) {
      log('RememberMeService.save error: $e');
    }
  }

  
  Future<void> clear() async {
    try {
      await _store.removeItem(RememberMeKeys.identifier);
      await _store.removeItem(RememberMeKeys.enabled);
    } catch (e) {
      log('RememberMeService.clear error: $e');
    }
  }

  
  Future<String?> getSavedIdentifier() async {
    try {
      final enabled = await _store.getItem(RememberMeKeys.enabled);
      if (enabled != 'true') return null;
      return _store.getItem(RememberMeKeys.identifier);
    } catch (e) {
      log('RememberMeService.getSavedIdentifier error: $e');
      return null; 
    }
  }

  Future<bool> isEnabled() async {
    try {
      final enabled = await _store.getItem(RememberMeKeys.enabled);
      return enabled == 'true';
    } catch (e) {
      return false;
    }
  }
}

final rememberMeServiceProvider = Provider<RememberMeService>(
  (_) => RememberMeService(),
);