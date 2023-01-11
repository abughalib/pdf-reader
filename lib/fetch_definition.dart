import 'dart:convert';
import "package:http/http.dart" as http;

Future<http.Response> fetchDefinition(String word) async {
  Uri uri = Uri.parse("https://18aa-202-142-81-154.in.ngrok.io/dict/api");

  var resp = await http.post(
    uri,
    headers: {'content-type': 'application/json'},
    body: jsonEncode({"word": word}),
  );

  return resp;
}
