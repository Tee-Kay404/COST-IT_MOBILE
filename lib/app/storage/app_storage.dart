import 'dart:developer';
import 'package:flutter/foundation.dart';
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

class HiveStorageService<K, T> implements IStorageService<K, T> {
  late Future<BoxBase<T>> _box;

  HiveStorageService({required boxName, lazy = false}) {
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
  Future<void> addItem(K key, T item) async {
    await (await _box).put(key, item);
  }

  @override
  Future<void> addItems(Map<K, T> itemsMap) async {
    await (await _box).putAll(itemsMap);
  }

  @override
  Future<void> updateItem(K key, T newItem) async {
    await (await _box).put(key, newItem);
  }

  @override
  Future<void> updateItems(Map<K, T> itemsMap) async {
    await (await _box).putAll(itemsMap);
  }

  @override
  Future<void> removeItem(K key) async {
    await (await _box).delete(key);
  }

  @override
  Future<void> removeItems(List<K> keys) async {
    await (await _box).deleteAll(keys);
  }

  @override
  Future<T?> getItem(K key) async {
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
  Future<Map<K, T>> getAllItemsMapped() async {
    if ((await _box).lazy) {
      throw Exception("Lazy boxes cannot return all items");
    }
    final result = (await _box) as Box<T>;
    log("Getting all items from box: ${result.name}");
    return result.toMap().cast<K, T>();
  }

  @override
  Future<List<T>> getItems(List<K>? keys) async {
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
  Future<Map<K, T>> getItemsMapped(List<K>? keys) async {
    if (keys == null || keys.isEmpty) {
      return getAllItemsMapped();
    }
    final itemsMap = <K, T>{};
    for (final key in keys) {
      final item = await getItem(key);
      if (item != null) {
        itemsMap[key] = item;
      }
    }
    return itemsMap;
  }
}
