import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../utils/token_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  UserModel? _user;
  String? _token;
  bool _isBootstrapping = true;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  
  String? get token => _token;

  bool get isAuthenticated => _token != null && _user != null;

  bool get isBootstrapping => _isBootstrapping;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> bootstrap() async {
    _token = await TokenStorage.getToken();

    if (_token != null) {
      try {
        _user = await _userService.getProfile(_token!);
      } catch (_) {
        await TokenStorage.clearToken();
        _token = null;
      }
    }

    _isBootstrapping = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    return _authenticate(() => _authService.login(email, password));
  }

  Future<bool> register({
    required String firstName,
    String? middleName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
    String? city,
    String? country,
  }) {
    return _authenticate(
      () => _authService.register(
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        city: city,
        country: country,
      ),
    );
  }

  Future<void> refreshProfile() async {
    if (_token == null) {
      return;
    }

    _user = await _userService.getProfile(_token!);
    notifyListeners();
  }

  Future<bool> updateProfile(UserModel user) async {
    if (_token == null) {
      return false;
    }

    _setLoading();

    try {
      _user = await _userService.updateProfile(_token!, user);
      _errorMessage = null;
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await TokenStorage.clearToken();
    _token = null;
    _user = null;
    notifyListeners();
  }

  Future<bool> _authenticate(Future<AuthResult> Function() request) async {
    _setLoading();

    try {
      final result = await request();
      _token = result.token;
      _user = result.user;
      await TokenStorage.saveToken(result.token);
      _errorMessage = null;
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }
}
