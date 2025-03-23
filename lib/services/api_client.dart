import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'api_endpoints.dart';

class ApiClient extends GetxService {
  final String baseUrl = ApiEndpoints.baseUrl;
  final String token = ApiEndpoints.token;
  
  // Headers for requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
  
  // GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl + endpoint),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // POST request
  Future<dynamic> post(String endpoint, {dynamic body}) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // PUT request
  Future<dynamic> put(String endpoint, {dynamic body}) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl + endpoint),
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse(baseUrl + endpoint),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw HttpException(
        response.statusCode,
        json.decode(response.body)['message'] ?? 'Unknown error occurred',
      );
    }
  }
  
  Exception _handleError(dynamic error) {
    if (error is HttpException) {
      return error;
    }
    return Exception('Network error occurred: ${error.toString()}');
  }
}

class HttpException implements Exception {
  final int statusCode;
  final String message;

  HttpException(this.statusCode, this.message);

  @override
  String toString() => 'HttpException: $statusCode - $message';
}
