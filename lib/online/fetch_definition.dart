import 'dart:convert';
import 'dart:io';

import 'package:pdf_reader/online/models.dart';

Future<HttpClientResponse> _fetchDefinition(String word) async {
  // TODO Move URI to Constants
  Uri uri = Uri.parse("https://27ee-202-142-81-154.in.ngrok.io/dict/api");

  final HttpClient httpClient = HttpClient();

  final request = await httpClient.postUrl(uri);

  // TODO Adding User Agent
  request.headers.contentType = ContentType("application", "json");
  request.add(utf8.encode(jsonEncode({"word": word})));

  final response = await request.close();

  return response;
}

Future<OnlineDefinitionResult> definitionResult(String word) async {
  final HttpClientResponse response = await _fetchDefinition(word);

  switch (response.statusCode) {
    case HTTPResponseStatusCode.ok:
      final responseBody = await response.transform(utf8.decoder).join();
      return OnlineDefinitionResult.fromJson(jsonDecode(responseBody));
    case HTTPResponseStatusCode.contentNotFound:
      return OnlineDefinitionResult.error(FetchError.contentNotFound);
    default:
      return OnlineDefinitionResult.error(FetchError.internalError);
  }
}
