import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Backend {
  static Future<List> fetchNearby(List location, List categories) async {
    var url = Uri.https(
        'us-central1-unihack-team-v.cloudfunctions.net', '/api/nearby');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({
          "location": "${location[0]},${location[1]}",
          "categories": categories
        }));
    return convert.jsonDecode(response.body)["results"];
  }

  static Future<String> fetchImage(String imageRef) async {
    var url = Uri.https('us-central1-unihack-team-v.cloudfunctions.net',
        '/api/photo/$imageRef');
    var response = await http.get(url);
    return convert.jsonDecode(response.body)["url"];
  }
}
