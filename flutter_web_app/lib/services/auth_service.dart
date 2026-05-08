import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/user_model.dart';
import 'api_exception.dart';

class AuthResult {
  const AuthResult({required this.token, required this.user});

  final String token;
  final UserModel user;
}

class AuthService {
  Future<AuthResult> login(String email, String password) {
    return _postAuth('/auth/login', {
      'email': email.trim(),
      'password': password,
    });
  }

  Future<AuthResult> register({
    required String firstName,
    String? middleName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
    String? city,
    String? country,
  }) {
    return _postAuth('/auth/register', {
      'firstName': firstName.trim(),
      'middleName': _emptyToNull(middleName),
      'lastName': lastName.trim(),
      'email': email.trim(),
      'password': password,
      'phoneNumber': _emptyToNull(phoneNumber),
      'birthDate': null,
      'gender': null,
      'address': null,
      'city': _emptyToNull(city),
      'country': _emptyToNull(country),
    });
  }

  Future<AuthResult> _postAuth(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final json = _decode(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        json['message']?.toString() ?? 'Authentication request failed',
        statusCode: response.statusCode,
      );
    }

    return AuthResult(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.body.isEmpty) {
      return {};
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  String? _emptyToNull(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value.trim();
  }
}
