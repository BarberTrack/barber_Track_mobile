import '../entities/style_history.dart';
import '../repositories/style_history_repository.dart';

class GetStyleHistory {
  final StyleHistoryRepository repository;

  GetStyleHistory(this.repository);

  Future<StyleHistory> call() async {
    return await repository.getStyleHistory();
  }
}
