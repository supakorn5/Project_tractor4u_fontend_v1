import 'package:http/http.dart' as http;
import 'package:tractor4your/Ipglobals.dart';
import 'package:tractor4your/model/users/getuserbyid.dart'; // Correct import path
import 'dart:developer'; // For logging

class ProfileService {
  final String apiUrl = 'http://${IPGlobals}:5000/api/users/GetUserById';

  Future<Getuserbyid> getUsersById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$id'), // Append the ID to the URL
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return getuserbyidFromJson(response.body);
      } else {
        log('Failed to load user, status code: ${response.statusCode}');
        log('Response body: ${response.body}');
        throw Exception('Failed to load user');
      }
    } catch (e) {
      log('Error fetching user data: $e');
      throw Exception('Failed to load user');
    }
  }
}
