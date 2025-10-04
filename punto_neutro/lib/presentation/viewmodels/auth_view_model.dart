import 'package:flutter/foundation.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_login.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  AuthViewModel(this._repository);

  UserLogin? _currentUser;
  bool _loading = false;
  String? _error;

  UserLogin? get currentUser => _currentUser;
  bool get loading => _loading;
  String? get error => _error;
  bool get loggedIn => _currentUser != null;

  Future<void> loginWithPassword(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _repository.loginWithPassword(
        email: email,
        password: password,
      );
      _currentUser = user;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithBiometric() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final ok = await _repository.refreshSession();
      if (ok) {
        _currentUser = UserLogin(
          userLoginId: 'biometric',
          email: 'test@demo.com',
          password: 'password123',
          fingerprintEnabled: true,
        );
      } else {
        _error = 'No biometric session found';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _currentUser = null;
    notifyListeners();
  }
}
