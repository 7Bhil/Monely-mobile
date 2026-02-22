import '../../../../core/api/api_client.dart';
import '../../../../core/data/local_data_source.dart';
import '../domain/models.dart';

class DashboardRepository {
  final ApiClient _apiClient;
  final LocalDataSource _localDataSource;

  DashboardRepository(this._apiClient, this._localDataSource);

  Future<List<Wallet>> getWallets() async {
    return _localDataSource.getWallets();
  }

  Future<List<Transaction>> getRecentTransactions() async {
    final allTransactions = await _localDataSource.getTransactions();
    // Retourner les 5 plus récentes par exemple
    return allTransactions.take(5).toList();
  }
}
