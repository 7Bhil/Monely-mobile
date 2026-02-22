import '../../../../core/data/local_data_source.dart';
import '../../dashboard/domain/models.dart';
import '../domain/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final LocalDataSource _localDataSource;

  TransactionRepositoryImpl(this._localDataSource);

  @override
  Future<List<Transaction>> getTransactions() async {
    return _localDataSource.getTransactions();
  }

  @override
  Future<Transaction> createTransaction({
    required int walletId,
    int? receiverWalletId,
    required String name,
    required double amount,
    required String type,
    required String category,
    required DateTime date,
  }) async {
    final transaction = Transaction(
      id: 0, // Sera généré par LocalDataSource
      walletId: walletId,
      receiverWalletId: receiverWalletId,
      walletName: '', // Sera rempli par LocalDataSource au chargement
      name: name,
      amount: amount,
      category: category,
      type: type,
      typeDisplay: type,
      status: 'COMPLETED',
      statusDisplay: 'Confirmé',
      date: date,
      icon: _getIconForCategory(category),
    );
    return _localDataSource.saveTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await _localDataSource.deleteTransaction(id);
  }

  String _getIconForCategory(String category) {
    // Logique simple pour les icônes
    switch (category.toLowerCase()) {
      case 'food': return 'restaurant';
      case 'shopping': return 'shopping_bag';
      case 'transport': return 'directions_car';
      case 'entertainment': return 'movie';
      case 'health': return 'medical_services';
      default: return 'attach_money';
    }
  }
}
