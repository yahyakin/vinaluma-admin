import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Sunucu adresini değiştirin
  static const String baseUrl = 'https://api.vinaluma.com/api/v1';
  static const String apiKey = 'vnl_flutter_2026_sk_live';

  static String? _token;

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Api-Key': apiKey,
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // === Auth ===
  static Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({'identifier': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      // ApiResponse format: { success: true, data: { user: {...}, token: "..." } }
      final data = body['data'] ?? body;
      _token = data['token'];
      if (_token == null) return false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('user_name', data['user']?['name'] ?? '');
      await prefs.setString('user_email', data['user']?['email'] ?? '');
      return true;
    }
    return false;
  }

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  static Future<void> logout() async {
    try {
      await http.post(Uri.parse('$baseUrl/auth/logout'), headers: _headers);
    } catch (_) {}
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static bool get isLoggedIn => _token != null;

  // === GET ===
  static Future<dynamic> get(String endpoint, {Map<String, String>? params}) async {
    var uri = Uri.parse('$baseUrl/$endpoint');
    if (params != null) uri = uri.replace(queryParameters: params);
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('API Hata: ${res.statusCode}');
  }

  // === POST ===
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );
    if (res.statusCode == 200 || res.statusCode == 201) return jsonDecode(res.body);
    throw Exception('API Hata: ${res.statusCode}');
  }

  // === PUT ===
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('API Hata: ${res.statusCode}');
  }

  // === DELETE ===
  static Future<bool> delete(String endpoint) async {
    final res = await http.delete(Uri.parse('$baseUrl/$endpoint'), headers: _headers);
    return res.statusCode == 200 || res.statusCode == 204;
  }

  // === Kısa Yollar ===
  static Future<Map<String, dynamic>> getHome() async => await get('home');
  static Future<List<dynamic>> getProducts({int page = 1}) async {
    final data = await get('products', params: {'page': '$page', 'per_page': '20'});
    return data['data'] ?? [];
  }
  static Future<Map<String, dynamic>> getProduct(String slug) async => await get('products/$slug');
  static Future<List<dynamic>> getCategories() async => await get('categories');
  static Future<List<dynamic>> getOrders({int page = 1}) async {
    final data = await get('orders', params: {'page': '$page'});
    return data['data'] ?? [];
  }
  static Future<Map<String, dynamic>> getOrder(String orderNumber) async => await get('orders/$orderNumber');
  static Future<Map<String, dynamic>> getProfile() async => await get('me');
}
