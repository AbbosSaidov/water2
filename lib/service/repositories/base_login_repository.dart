import 'package:water2/models/loginrequest.dart';
import 'package:water2/models/loginresponse.dart';

abstract class BaseLoginRepository {
  Future<LoginResponse> getResult(LoginRequest req);

  void dispose();
}
