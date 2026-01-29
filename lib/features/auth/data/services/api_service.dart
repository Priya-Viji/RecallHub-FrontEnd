import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "https://propitiable-autotypic-tiesha.ngrok-free.dev";

  Future<void> sendUserDetails({
    required String uid,
    required String name,
    required String email,
    required String photoUrl,
  }) async {

    //print('API service: $uid, $name, $email, $photoUrl');

    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "googleId": uid,
        "name": name,
        "email": email,
        "profileImage": photoUrl,
      }),
      
    );
   //print('response: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception("Failed to sync user with backend: ${response.body}");
    }
  }
}
