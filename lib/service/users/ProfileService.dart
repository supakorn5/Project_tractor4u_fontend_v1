import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tractor4your/model/users/getuserbyid.dart'; // Correct import path

class ProfileService {
  final String apiUrl = 'http://192.168.144.69:5000/api/users/GetUserById';

  Future<Getuserbyid> getUsersById(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$id'), // Append the ID to the URL
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return getuserbyidFromJson(response.body);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
