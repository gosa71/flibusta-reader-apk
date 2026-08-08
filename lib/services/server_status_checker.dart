import 'package:flibusta/model/connectionCheckResult.dart';

class ServerStatusChecker {
  Future<ConnectionCheckResult> check(String url) async {
    return ConnectionCheckResult(latency: 100, error: null);
  }
}
