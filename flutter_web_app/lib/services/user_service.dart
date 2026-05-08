import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/user_model.dart';
import 'api_exception.dart';

class UserService {
  Future<UserModel> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users/profile'),
      headers: _headers(token),
    );

    return _handleUserResponse(response);
  }

  Future<List<UserModel>> getAllUsers(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users'),
      headers: _headers(token),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final json = response.body.isEmpty ? {} : jsonDecode(response.body);
      throw ApiException(
        json['message']?.toString() ?? 'Request failed',
        statusCode: response.statusCode,
      );
    }

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }

    Future<UserModel> updateProfile(String token, UserModel user) async {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/users/profile'),
        headers: _headers(token),
        body: jsonEncode(user.toUpdateJson()),
      );

      return _handleUserResponse(response);
    }

    Future<UserModel> updateUser(String token, int id, UserModel user) async {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/users/$id'),
        headers: _headers(token),
        body: jsonEncode(user.toUpdateJson()),
      );

      return _handleUserResponse(response);
    }

  Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  UserModel _handleUserResponse(http.Response response) {
    final json = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        json['message']?.toString() ?? 'Profile request failed',
        statusCode: response.statusCode,
      );
    }

    return UserModel.fromJson(json);
  }
}
