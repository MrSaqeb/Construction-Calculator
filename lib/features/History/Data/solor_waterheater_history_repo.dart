import 'package:construction_calculator/Domain/entities/solor_waterheater_history_item.dart';
import 'package:construction_calculator/features/History/Data/solor_waterheater_local_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository
class SolarWaterRepository {
  // Save a history item
  Future<void> addHistory(SolarWaterHistoryItem item) async {
    await SolarWaterLocalData.saveHistory(item);
  }

  // Get all history items
  Future<List<SolarWaterHistoryItem>> getHistory() async {
    return await SolarWaterLocalData.getHistory();
  }

  // Delete a history item
  Future<void> deleteHistory(int index) async {
    await SolarWaterLocalData.deleteHistory(index);
  }

  // Clear all history
  Future<void> clearHistory() async {
    await SolarWaterLocalData.clearHistory();
  }
}

// Riverpod provider for repository
final solarWaterRepositoryProvider = Provider<SolarWaterRepository>((ref) {
  return SolarWaterRepository();
});
