import 'dart:convert';

import 'package:water2/models/loginrequest.dart';
import 'package:water2/models/loginresponse.dart';
import 'package:water2/service/const.dart';
import 'package:water2/service/repositories/base_login_repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository extends BaseLoginRepository {
  final http.Client _httpClient;

  LoginRepository({http.Client httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<LoginResponse> getResult(LoginRequest req)async{
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$BASELOGIN:$BASEPASSWORD'));
    final response = await _httpClient.post(
        Uri.parse(LOGINBASEURL + HEADERURL),
      headers: {'authorization': basicAuth},
      body: jsonEncode(<String, dynamic>{
        'auth': {
          'login': '${req.auth.login}',
          'password': '${req.auth.password}'
        }
      }),
    );
    print('DATA PRINTER2 = ${response.statusCode}');
    print('DATA PRINTER2 = ${response.body.toString()}');
    if (response.statusCode == 200){
      SharedPreferences savePrimecheniya = await SharedPreferences.getInstance();
      savePrimecheniya.setInt("rayonLength", jsonDecode(response.body)['districts'].length);
      for(int i=0;i<jsonDecode(response.body)['districts'].length;i++){
        savePrimecheniya.setString("rayon"+i.toString(),jsonDecode(response.body)['districts'][i]['district'].toString());
      }
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create album.=' + response.toString());
    }
  }

  @override
  void dispose() {
    _httpClient.close();
  }
}
