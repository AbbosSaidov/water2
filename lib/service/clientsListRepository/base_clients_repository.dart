import 'package:water2/models/loginrequest.dart';
import 'package:water2/models/counterpartyresponse.dart';

abstract class BaseClientsRepository {
  Future<CounterpartyResponse> getResult(LoginRequest req);

  void dispose();
}
