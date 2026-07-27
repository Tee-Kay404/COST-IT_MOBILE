import 'pagination.dart';

extension ListExtension<T> on List<T> {
  List<T> separatedBy(T separator) {
    if (isEmpty) return this;

    return expand((element) => [element, separator]).toList()..removeLast();
  }

  Map<int, T> get enumerate {
    var i = 0;
    return Map.fromEntries(map((e) => MapEntry(i++, e)));
  }

  List<dynamic> get flatten {
    List<dynamic> result = [];
    for (var element in this) {
      if (element is List) {
        result.addAll((element as List).flatten);
      } else {
        result.add(element);
      }
    }
    return result;
  }

  T? get safeFirst {
    return isEmpty ? null : first;
  }

  T? get safeLast {
    return isEmpty ? null : last;
  }

  T? safeElementAt(int index) {
    return isEmpty ? null : elementAt(index);
  }

  T? firstWhereOrNull(bool Function(T) test, {T? Function()? orElse}) {
    try {
      return firstWhere(test);
    } catch (error) {
      if (error is StateError) {
        return orElse?.call();
      }
      return null;
    }
  }

  PaginationResult<T> paginate(int pageSize, int pageNumber) {
    return ListPaginator.paginate(this, pageSize, pageNumber);
  }

  List<T> simplePaginate(int pageSize, int pageNumber) {
    return ListPaginator.simplePaginate(this, pageSize, pageNumber);
  }
}
