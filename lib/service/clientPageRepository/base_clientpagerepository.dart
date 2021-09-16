import 'package:water2/models/counterpartyresponse.dart';

abstract class BaseClientsPageRepository {
  Future<String> addLocation(CounterParties user, String locationLink);
  void dispose();
}
