import 'dart:convert';
import 'dart:io';

import 'package:pdf_reader/online/models.dart';

Future<HttpClientResponse> _fetchDefinition(String word) async {
  Uri uri = Uri.parse("https://27ee-202-142-81-154.in.ngrok.io/dict/api");

  final HttpClient httpClient = HttpClient();

  final request = await httpClient.postUrl(uri);

  request.headers.contentType = ContentType("application", "json");
  request.add(utf8.encode(jsonEncode({"word": word})));

  final response = await request.close();

  return response;
}

Future<OnlineDefinitionResult> definitionResult(String word) async {
  final HttpClientResponse response = await _fetchDefinition(word);

  if (response.statusCode == 200) {
    final responseBody = await response.transform(utf8.decoder).join();
    final result = OnlineDefinitionResult.fromJson(jsonDecode(responseBody));
    return result;
  } else if (response.statusCode == 404) {
    return OnlineDefinitionResult.error(FetchError.notFound);
  } else {
    return OnlineDefinitionResult.error(FetchError.internalError);
  }
}
