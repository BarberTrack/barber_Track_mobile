import '../../domain/entities/style_history.dart';
import '../../domain/repositories/style_history_repository.dart';
import '../datasources/style_history_remote_data_source.dart';
import '../mappers/style_history_mapper.dart';

class StyleHistoryRepositoryImpl implements StyleHistoryRepository {
  final StyleHistoryRemoteDataSource remoteDataSource;

  StyleHistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<StyleHistory> getStyleHistory() async {
    final styleHistoryModel = await remoteDataSource.getStyleHistory();
    return StyleHistoryMapper.toEntity(styleHistoryModel);
  }
}
