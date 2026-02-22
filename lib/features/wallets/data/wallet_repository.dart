import '../../../../core/data/local_data_source.dart';
import '../../dashboard/domain/models.dart';
import '../domain/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final LocalDataSource _localDataSource;

  WalletRepositoryImpl(this._localDataSource);

  @override
  Future<List<Wallet>> getWallets() async {
    return _localDataSource.getWallets();
  }

  @override
  Future<Wallet> createWallet({
    required String name,
    required String type,
    required double balance,
    required String currency,
    required String color,
    required String icon,
  }) async {
    final wallet = Wallet(
      id: 0, // Sera généré par LocalDataSource
      name: name,
      type: type,
      typeDisplay: type,
      balance: balance,
      currency: currency,
      color: color,
      icon: icon,
    );
    return _localDataSource.saveWallet(wallet);
  }

  @override
  Future<void> deleteWallet(int id) async {
    await _localDataSource.deleteWallet(id);
  }
}
