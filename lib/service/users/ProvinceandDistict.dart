import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tractor4your/model/users/provinceinTH.dart' as model;
import '../../model/users/provinceinTH.dart' as service;

Future<List<model.ProvinceinTh>> fetchProvinces() async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/kongvut/thai-province-data/master/api_province_with_amphure_tambon.json'));

  if (response.statusCode == 200) {
    // Convert response body to list of ProvinceinTh objects
    return model.provinceinThFromJson(response.body);
  } else {
    throw Exception('Failed to load provinces');
  }
}
