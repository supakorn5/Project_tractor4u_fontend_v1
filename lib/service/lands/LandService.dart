import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../model/lands/getlandsbyuser_id.dart';

class LandService {
  final String apiUrl =
      'http://192.168.165.188:5000/api/lands/GetLandsByUserid';

  Future<Getlandsbyuserid> fetchLand(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$id'), // Append the ID to the URL
      headers: {'Content-Type': 'application/json'},
    );

    return getlandsbyuseridFromJson(response.body);
  }
}
