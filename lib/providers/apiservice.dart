import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkURL {
  static final String baseUrl = "https://berita-indo-api-next.vercel.app/api/cnn-news/";

  static Future<Map<String, dynamic>> get(String partUrl) async {
    final String fullUrl = baseUrl + "/" + partUrl;
    debugPrint("Network - fullUrl : $fullUrl");
    final response = await http.get(Uri.parse(fullUrl));
    debugPrint("Network - response : ${response.body}");
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> _processResponse(
      http.Response response) async {
    final body = response.body;
    if (body.isNotEmpty) {
      final jsonBody = json.decode(body);
      return jsonBody;
    } else {
      print("processResponse error");
      return {"error": true};
    }
  }

  static void debugPrint(String value) {
    print("[NETWORK] - $value");
  }
}

class ApiRoutes {
  static ApiRoutes instance = ApiRoutes();
  Future<Map<String, dynamic>> loadCategory(String Category) {
    return NetworkURL.get(Category);
  }
}