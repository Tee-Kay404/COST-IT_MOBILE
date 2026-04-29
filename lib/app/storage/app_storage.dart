import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ← add this import
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

abstract class IStorageService<K, T> {
  Future<void> addItem(K key, T item);
  Future<void> addItems(Map<K, T> itemsMap);
  Future<void> updateItem(K key, T item);
  Future<void> updateItems(Map<K, T> itemsKeyValueMap);
  Future<void> removeItem(K key);
  Future<void> removeItems(List<K> keys);
  Future<T?> getItem(K identifier);
  Future<List<T>> getItems(List<K>? identifiers);
  Future<Map<K, T>> getItemsMapped(List<K>? keys);
  Future<Map<K, T>> getAllItemsMapped();
  Future<void> clear();
}

class HiveStorageService<String, T> implements IStorageService<String, T> {
  late Future<BoxBase<T>> _box;

  HiveStorageService({
    required boxName,
    lazy = false,
  }) {
    log("Initializing Box: $boxName");
    _box = initialise(boxName, lazy);
  }

  Future<BoxBase<T>> initialise(String boxName, bool lazy) async {
    log("Initializing Box Future: $boxName");
    if (!kIsWeb) {
      final dir = await path_provider.getApplicationSupportDirectory();
      final hiveFolder = path.join(dir.path);
      Hive.init(hiveFolder);
    }
    if (lazy == true) {
      return await Hive.openLazyBox<T>(boxName.toString());
    } else {
      return await Hive.openBox<T>(boxName.toString());
    }
  }

  @override
  Future<void> addItem(String key, T item) async {
    await (await _box).put(key, item);
  }

  @override
  Future<void> addItems(Map<String, T> itemsMap) async {
    await (await _box).putAll(itemsMap);
  }

  @override
  Future<void> updateItem(String key, T newItem) async {
    await (await _box).put(key, newItem);
  }

  @override
  Future<void> updateItems(Map<String, T> itemsMap) async {
    await (await _box).putAll(itemsMap);
  }

  @override
  Future<void> removeItem(String key) async {
    await (await _box).delete(key);
  }

  @override
  Future<void> removeItems(List<String> keys) async {
    await (await _box).deleteAll(keys);
  }

  @override
  Future<T?> getItem(String key) async {
    if ((await _box).lazy) {
      return ((await _box) as LazyBox<T>).get(key);
    }
    return ((await _box) as Box<T>).get(key);
  }

  Future<List<T>> getAllItems() async {
    if ((await _box).lazy) {
      throw Exception("Lazy boxes cannot return all items");
    }
    return ((await _box) as Box<T>).values.toList();
  }

  @override
  Future<Map<String, T>> getAllItemsMapped() async {
    if ((await _box).lazy) {
      throw Exception("Lazy boxes cannot return all items");
    }
    final result = (await _box) as Box<T>;
    log("Getting all items from box: ${result.name}");
    return result.toMap().cast<String, T>();
  }

  @override
  Future<List<T>> getItems(List<String>? keys) async {
    if (keys == null || keys.isEmpty) {
      return getAllItems();
    }
    final items = <T>[];
    for (final key in keys) {
      final item = await getItem(key);
      if (item != null) {
        items.add(item);
      }
    }
    return items;
  }

  Future<List<T>> query(bool Function(T) predicate) async {
    if ((await _box).lazy) {
      throw Exception("Cannot filter lazy boxes");
    }
    return ((await _box) as Box<T>).values.where(predicate).toList();
  }

  @override
  Future<void> clear() async {
    await (await _box).clear();
  }

  @override
  Future<Map<String, T>> getItemsMapped(List<String>? keys) async {
    if (keys == null || keys.isEmpty) {
      return getAllItemsMapped();
    }
    final itemsMap = <String, T>{};
    for (final key in keys) {
      final item = await getItem(key);
      if (item != null) {
        itemsMap[key] = item;
      }
    }
    return itemsMap;
  }
}

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