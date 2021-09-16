import 'package:water2/models/summaryResp.dart';

import '../../models/counterpartyresponse.dart';

abstract class BaseSummaryResponse {
  Future<SummResp> getSummary(
      CounterParties user, String startDate, String finishDate);

  void dispose();
}
