import 'package:construction_calculator/Domain/entities/plywood_sheet_history_item.dart';
import 'package:construction_calculator/features/History/Data/plywood_sheet_history_local_data.dart';

class PlywoodSheetRepository {
  final PlywoodSheetLocalDataSource localDataSource;

  PlywoodSheetRepository(this.localDataSource);

  Future<void> addSheet(PlywoodSheetItem item) async {
    await localDataSource.addSheet(item);
  }

  List<PlywoodSheetItem> getAllSheets() {
    return localDataSource.getAllSheets();
  }

  Future<void> deleteSheet(int index) async {
    await localDataSource.deleteSheet(index);
  }

  Future<void> clearAll() async {
    await localDataSource.clearAll();
  }
}
