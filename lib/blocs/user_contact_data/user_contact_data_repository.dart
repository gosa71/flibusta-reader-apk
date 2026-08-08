import 'package:flibusta/model/userContactData.dart';
import 'package:flibusta/services/http_client/http_client.dart';
import 'package:flibusta/utils/html_parsers.dart';

class UserContactDataRepository {
  Future<UserContactData> getUserContactData() async {
    final html = await ProxyHttpClient().getHtml('/user');
    return parseUserContactData(html);
  }
}
