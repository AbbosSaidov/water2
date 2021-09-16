import 'dart:convert';

import 'package:water2/models/loginrequest.dart';
import 'package:water2/models/counterpartyresponse.dart';
import 'package:water2/service/const.dart';
import 'package:water2/service/clientsListRepository/base_clients_repository.dart';
import 'package:http/http.dart' as http;

class ClientListRepository extends BaseClientsRepository {
  final http.Client _httpClient;

  ClientListRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<CounterpartyResponse> getResult(LoginRequest req) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$BASELOGIN:$BASEPASSWORD'));
    final response = await _httpClient.post(
      //post==get
        Uri.parse(LOGINBASEURL + COUNTERPARTYURL),
      headers: {'authorization': basicAuth},
      body: jsonEncode(<String, dynamic>{
        'auth': {'login': '${LOGIN}', 'password': '${PASSWORD}'}
      }),
    );

    print('DATA Client List PRINTER2 = ${response.statusCode}');
    print('DATA Client LOGIN PASSWORD = ${LOGIN}+${LOGIN}');
    if (response.statusCode == 200){
      print('DATA PRINTER3 = ${response.body}');
      return CounterpartyResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create album.=' + response.toString());
    }
  }

  @override
  void dispose() {
    _httpClient.close();
  }
}
