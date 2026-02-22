import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../features/auth/domain/user_model.dart';
import '../../features/dashboard/domain/models.dart';

class LocalDataSource {
  final Box _userBox;
  final Box _walletsBox;
  final Box _transactionsBox;
  final _uuid = const Uuid();

  LocalDataSource({
    required Box userBox,
    required Box walletsBox,
    required Box transactionsBox,
  })  : _userBox = userBox,
        _walletsBox = walletsBox,
        _transactionsBox = transactionsBox;

  // User Profile
  Future<void> cacheUserProfile(User user) async {
    await _userBox.put('profile', user.toJson());
  }

  User? getCachedUserProfile() {
    final data = _userBox.get('profile');
    if (data != null) {
      return User.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  // PIN Support
  Future<void> savePin(String pin) async {
    await _userBox.put('pin', pin);
  }

  bool verifyPin(String pin) {
    final storedPin = _userBox.get('pin');
    return storedPin == pin;
  }

  bool hasPin() {
    return _userBox.containsKey('pin');
  }

  // Wallets
  Future<List<Wallet>> getWallets() async {
    final List<Wallet> wallets = [];
    for (var key in _walletsBox.keys) {
      final data = _walletsBox.get(key);
      if (data != null) {
        wallets.add(Wallet.fromJson(Map<String, dynamic>.from(data)));
      }
    }
    return wallets;
  }

  Future<Wallet> saveWallet(Wallet wallet) async {
    final id = wallet.id == 0 ? DateTime.now().millisecondsSinceEpoch : wallet.id;
    final walletToSave = Wallet(
      id: id,
      name: wallet.name,
      type: wallet.type,
      typeDisplay: wallet.typeDisplay,
      balance: wallet.balance,
      currency: wallet.currency,
      color: wallet.color,
      icon: wallet.icon,
    );
    
    await _walletsBox.put(id, {
      'id': walletToSave.id,
      'name': walletToSave.name,
      'type': walletToSave.type,
      'type_display': walletToSave.typeDisplay,
      'balance': walletToSave.balance,
      'currency': walletToSave.currency,
      'color': walletToSave.color,
      'icon': walletToSave.icon,
    });
    return walletToSave;
  }

  Future<void> deleteWallet(int id) async {
    await _walletsBox.delete(id);
    // Optionnel: supprimer aussi les transactions liées
    final keysToDelete = [];
    for (var key in _transactionsBox.keys) {
      final t = _transactionsBox.get(key);
      if (t != null && t['wallet'] == id) {
        keysToDelete.add(key);
      }
    }
    for (var key in keysToDelete) {
      await _transactionsBox.delete(key);
    }
  }

  // Transactions
  Future<List<Transaction>> getTransactions() async {
    final List<Transaction> transactions = [];
    for (var key in _transactionsBox.keys) {
      final data = _transactionsBox.get(key);
      if (data != null) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(data);
        // On récupère le nom du wallet pour l'affichage
        final walletData = _walletsBox.get(json['wallet']);
        final walletName = walletData != null ? walletData['name'] : 'Inconnu';
        json['wallet_name'] = walletName;
        transactions.add(Transaction.fromJson(json));
      }
    }
    // Trier par date décroissante
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
  }

  Future<Transaction> saveTransaction(Transaction transaction) async {
    final id = transaction.id == 0 ? DateTime.now().millisecondsSinceEpoch : transaction.id;
    
    // Mettre à jour la balance du wallet
    final walletData = _walletsBox.get(transaction.walletId);
    if (walletData != null) {
      final Map<String, dynamic> updatedWallet = Map<String, dynamic>.from(walletData);
      double balance = (updatedWallet['balance'] as num).toDouble();
      
      if (transaction.type == 'EXPENSE') {
        balance -= transaction.amount;
      } else if (transaction.type == 'INCOME') {
        balance += transaction.amount;
      } else if (transaction.type == 'TRANSFER' && transaction.receiverWalletId != null) {
        balance -= transaction.amount;
        // Créditer le receveur
        final receiverData = _walletsBox.get(transaction.receiverWalletId);
        if (receiverData != null) {
          final Map<String, dynamic> updatedReceiver = Map<String, dynamic>.from(receiverData);
          double rBalance = (updatedReceiver['balance'] as num).toDouble();
          rBalance += transaction.amount;
          updatedReceiver['balance'] = rBalance;
          await _walletsBox.put(transaction.receiverWalletId, updatedReceiver);
        }
      }
      
      updatedWallet['balance'] = balance;
      await _walletsBox.put(transaction.walletId, updatedWallet);
    }

    final dataToSave = {
      'id': id,
      'wallet': transaction.walletId,
      'receiver_wallet': transaction.receiverWalletId,
      'name': transaction.name,
      'amount': transaction.amount,
      'category': transaction.category,
      'type': transaction.type,
      'type_display': transaction.typeDisplay,
      'status': transaction.status,
      'status_display': transaction.statusDisplay,
      'date': transaction.date.toIso8601String(),
      'icon': transaction.icon,
    };
    
    await _transactionsBox.put(id, dataToSave);
    return Transaction.fromJson(dataToSave);
  }

  Future<void> deleteTransaction(int id) async {
    // Note: On ne réverse pas la balance ici par simplicité pour ce MVP
    await _transactionsBox.delete(id);
  }

  Future<void> clearCache() async {
    await _userBox.clear();
    await _walletsBox.clear();
    await _transactionsBox.clear();
  }
}
