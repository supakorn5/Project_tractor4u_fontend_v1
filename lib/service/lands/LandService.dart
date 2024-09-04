import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tractor4your/Ipglobals.dart';
import 'package:tractor4your/model/lands/getlandsnotreserve.dart';
import '../../../model/lands/getlandsbyuser_id.dart';

String ip = IPGlobals;

class LandService {
  final String apiUrl = 'http://${ip}:5000/api/lands/GetLandsByUserid';
  final String apiUrl1 = 'http://${ip}:5000/api/lands/GetLandNotReserve';

  Future<GetLandsByUserid> fetchLand(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$id'), // Append the ID to the URL
      headers: {'Content-Type': 'application/json'},
    );

    return getLandsByUseridFromJson(response.body);
  }

  Future<GetLandNotReserve> fetchLandNotReserve(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl1/$id'), // Append the ID to the URL
      headers: {'Content-Type': 'application/json'},
    );

    return getLandNotReserveFromJson(response.body);
  }
}

Future<List<dynamic>> api_GetLandStatus(int? lands_id) async {
  final url = Uri.parse("http://" + ip + ":5000/api/lands/GetLandStatus");
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    "lands_id": lands_id,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final decodeResponse = jsonDecode(response.body);
      print('--------------------api_GetLandInOrder--------------');
      print(decodeResponse['data']);
      return decodeResponse['data'];
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      print(
          "Fail load data api_GetLandInStatus: Status code: ${response.statusCode}");
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
