import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:water2/models/counterpartyresponse.dart';
import 'package:water2/service/clientPageRepository/base_clientpagerepository.dart';
import 'package:water2/service/const.dart';

class ClientPageRepository extends BaseClientsPageRepository {
  final http.Client _httpClient;

  ClientPageRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  void dispose() {
    _httpClient.close();
  }

  @override
  Future<String> addLocation(CounterParties user, String locationLink) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$BASELOGIN:$BASEPASSWORD'));
    if (locationLink.isNotEmpty) {
      final response = await _httpClient.post(
          Uri.parse(LOGINBASEURL + LOCATIONURL),
        headers: {'authorization': basicAuth},
        body: jsonEncode(<String, dynamic>{
          "auth": {'login': LOGIN, 'password': PASSWORD},
          "counterparty": {
            'name': user.name.toString(),
            'code': user.code.toString(),
            "location": locationLink
          }
        }),
      );
      if (response.statusCode == 200) {
        print('!!!SUCCES!!!SUCCES!!!SUCCES!!!SUCCES!!!SUCCES!!!SUCCES!!!');
        return 'success';
      } else {
        print('!!!ERROR!!!ERROR!!!ERROR!!!ERROR!!!ERROR!!!ERROR!!!ERROR!!!');
        throw Exception('Failed to create album.=' + response.toString());
      }
    } else {
      throw Exception('Failed to create album');
    }
  }
}
