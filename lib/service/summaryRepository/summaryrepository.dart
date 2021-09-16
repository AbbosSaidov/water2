import 'dart:convert';

import 'package:water2/models/summaryResp.dart';
import 'package:water2/service/summaryRepository/base_summaryRepository.dart';
import 'package:http/http.dart' as http;

import '../../models/counterpartyresponse.dart';
import '../const.dart';

class SummaryRepository extends BaseSummaryResponse {
  @override
  void dispose() {}
  final http.Client _httpClient;

  SummaryRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<SummResp> getSummary(
      CounterParties user, String startDate, String finishDate) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$BASELOGIN:$BASEPASSWORD'));
    final response = await _httpClient.post(
      Uri.parse(LOGINBASEURL + SUMMPARTYURL)
      ,
      headers: {'authorization': basicAuth},
      body: jsonEncode(<String, dynamic>{
        "auth": {'login': LOGIN, 'password': PASSWORD},
        "counterparty": {
          'name': "${user.name}",
          'code': "${user.code}",
        },
        "dateN": "${startDate}",
        "dateK": "${finishDate}"
      }),
    );
    print('DATA PRINTER2 = ${response.request}');
    print('DATA PRINTER2 = ${response.headers}');
    print('DATA PRINTER2 = ${response.body}');
    print('DATA PRINTER2 = ${user.name}');
    print('DATA PRINTER2 = ${user.code}');
    print('DATA PRINTER2START = ${startDate}');
    print('DATA PRINTER2FINISH = ${finishDate}');

    if (response.statusCode == 200) {
      if (response.body == 'error in json data' ||
          response.body == 'counterparty not found') {
        throw Exception('Failed to get summ.=' + response.toString());
      } else {
        String map = response.body + '\n}';
        print('DATA PRINTER2 = ${map}');
        return SummResp.fromJson(jsonDecode(map));
      }
    } else {
      throw Exception('Failed to get summ.=' + response.toString());
    }
  }
}
