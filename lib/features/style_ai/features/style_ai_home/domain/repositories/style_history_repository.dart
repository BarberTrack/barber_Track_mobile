import '../entities/style_history.dart';

abstract class StyleHistoryRepository {
  Future<StyleHistory> getStyleHistory();
}
