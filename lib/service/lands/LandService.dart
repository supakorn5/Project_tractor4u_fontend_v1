import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../model/lands/getlandsbyuser_id.dart';


String ip = '10.0.2.45';
class LandService {
  final String apiUrl =
      'http://10.0.2.45:5000/api/lands/GetLandsByUserid';

  Future<Getlandsbyuserid> fetchLand(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$id'), // Append the ID to the URL
      headers: {'Content-Type': 'application/json'},
    );

    return getlandsbyuseridFromJson(response.body);
  }
}


Future<List<dynamic>> api_GetLandStatus(int? lands_id) async {
  final url = Uri.parse("http://" + ip + ":5000/api/lands/GetLandStatus");
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    "lands_id": lands_id,
  });

  
  try {
    final response = await http.post(url, headers: headers, body:body);
    if(response.statusCode == 200){
      final decodeResponse = jsonDecode(response.body);
      print('--------------------api_GetLandInOrder--------------');
      print(decodeResponse['data']);
      return decodeResponse['data'];
    }else if(response.statusCode == 404 || response.statusCode == 401){
      print("Fail load data api_GetLandInStatus: Status code: ${response.statusCode}");
      return [];
    } else {
      print("Unexpected status code: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load data');
  }
}
