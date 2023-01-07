import 'package:http/http.dart' as http;

Future<http.Response> fetchDefinition() {
  const url = 'http://localhost:8081/api/dict';

  return http.post(
    Uri.parse(url),
    headers: {},
    body: {
      'word': 'apple'
    },
  );
}
