import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/concreteblock_history_item.dart';

/// Local Data Source for ConcreteBlock History
class ConcreteBlockHistoryLocalDataSource {
  late final Box<ConcreteBlockHistory> _box;

  /// Initialize the box
  Future<void> init() async {
    _box = await Hive.openBox<ConcreteBlockHistory>(
      HiveBoxes.concreteBlockHistory, // 'concrete_block_history'
    );
  }

  /// Get all history items
  List<ConcreteBlockHistory> getHistory() {
    return _box.values.toList();
  }

  /// Add new history item (avoid duplicates)
  Future<void> addHistory(ConcreteBlockHistory item) async {
    final exists = _box.values.any(
      (e) =>
          e.dateTime == item.dateTime &&
          e.unitType == item.unitType &&
          e.length == item.length &&
          e.height == item.height &&
          e.thickness == item.thickness,
    );

    if (!exists) {
      await _box.add(item);
    }
  }

  /// Delete specific history item safely
  Future<void> deleteHistoryItem(ConcreteBlockHistory item) async {
    final key = _box.keys.firstWhere(
      (k) => _box.get(k) == item,
      orElse: () => null,
    );
    if (key != null) {
      await _box.delete(key);
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await _box.clear();
  }
}

/// Riverpod Notifier
class ConcreteBlockHistoryNotifier
    extends StateNotifier<List<ConcreteBlockHistory>> {
  final ConcreteBlockHistoryLocalDataSource localDataSource;

  ConcreteBlockHistoryNotifier(this.localDataSource)
    : super(localDataSource.getHistory());

  /// Add new item
  Future<void> addHistory(ConcreteBlockHistory item) async {
    await localDataSource.addHistory(item);
    state = localDataSource.getHistory();
  }

  /// Delete item
  Future<void> deleteHistoryItem(ConcreteBlockHistory item) async {
    await localDataSource.deleteHistoryItem(item);
    state = localDataSource.getHistory();
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await localDataSource.clearHistory();
    state = [];
  }
}

/// Riverpod Provider
final concreteBlockHistoryProvider =
    StateNotifierProvider<
      ConcreteBlockHistoryNotifier,
      List<ConcreteBlockHistory>
    >((ref) {
      final localDataSource = ConcreteBlockHistoryLocalDataSource();
      return ConcreteBlockHistoryNotifier(localDataSource);
    });
