import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/data/local_data_source.dart';
import '../domain/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;
  final LocalDataSource _localDataSource;
  
  // In-memory session flag (lost on app restart)
  bool _isAuthenticated = false;

  AuthRepository(this._apiClient, this._prefs, this._localDataSource);

  // Setup initial profile with Name and PIN
  Future<User> setupProfile(String name, String pin) async {
    final user = User(
      id: 1,
      email: '', 
      name: name,
      username: name.toLowerCase().replaceAll(' ', '_'),
      currency: 'USD',
      language: 'fr',
      monthlyIncome: 0,
    );
    await _localDataSource.cacheUserProfile(user);
    await _localDataSource.savePin(pin);
    _isAuthenticated = true; // Set current session as authenticated
    return user;
  }

  // Verify PIN for every connection
  bool verifyPin(String pin) {
    final isValid = _localDataSource.verifyPin(pin);
    if (isValid) {
      _isAuthenticated = true;
    }
    return isValid;
  }

  // Check if it's the first time
  bool get isFirstTime => !_localDataSource.hasPin();

  Future<User> getProfile() async {
    final cached = _localDataSource.getCachedUserProfile();
    if (cached != null) return cached;
    
    return const User(
      id: 1,
      email: '',
      name: 'Utilisateur Offline',
      username: 'offline_user',
      currency: 'USD',
      language: 'fr',
      monthlyIncome: 0,
    );
  }

  Future<void> logout() async {
    _isAuthenticated = false; // "Lock" the app session
  }

  // Entirely clear data (reset app)
  Future<void> resetApp() async {
    await _prefs.clear();
    await _localDataSource.clearCache();
    _isAuthenticated = false;
  }
    
  bool get isAuthenticated => _isAuthenticated;

  User? get currentUser => _localDataSource.getCachedUserProfile();
}
