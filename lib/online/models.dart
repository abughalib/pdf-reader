class Meaning {
  final List<String> def;
  final List<String> keywords;

  Meaning({required this.def, required this.keywords});

  @override
  String toString() {
    return "Definition{def: $def, keywords: $keywords}";
  }
}

class OnlineDefinition {
  final String word;
  final Meaning meaning;
  final List<String> synonyms;
  final List<String> antonyms;

  OnlineDefinition({
    required this.word,
    required this.meaning,
    required this.synonyms,
    required this.antonyms,
  });

  @override
  String toString() {
    return "Definition{word: $word, meaning: $meaning, synonyms: $synonyms, antonyms: $antonyms}";
  }
}

enum FetchError { contentNotFound, internalError, serverError, noError }

enum FetchStatus { loading, completed, error }

class OnlineDefinitionResult {
  late OnlineDefinition onlineDefinition;
  late FetchError fetchError;
  late FetchStatus fetchStatus;
  late bool err;

  OnlineDefinitionResult.error(this.fetchError) {
    onlineDefinition = OnlineDefinition(
      word: "",
      meaning: Meaning(def: [], keywords: []),
      synonyms: [],
      antonyms: [],
    );
    fetchStatus = FetchStatus.error;
    err = true;
  }

  OnlineDefinitionResult.define(this.onlineDefinition) {
    err = false;
    fetchStatus = FetchStatus.completed;
    fetchError = FetchError.noError;
  }

  OnlineDefinitionResult.status(this.fetchStatus) {
    onlineDefinition = OnlineDefinition(
      word: "",
      meaning: Meaning(def: [], keywords: []),
      synonyms: [],
      antonyms: [],
    );
    err = false;
    fetchError = FetchError.contentNotFound;
  }

  OnlineDefinitionResult.fromJson(Map<String, dynamic> json) {
    String word = json["word"];
    List<String> def = List<String>.from(json["meaning"]["def"]);
    List<String> keywords = List<String>.from(json["meaning"]["keywords"]);
    List<String> synonyms = List<String>.from(json["synonyms"]);
    List<String> antonyms = List<String>.from(json["antonyms"]);

    Meaning meaning = Meaning(def: def, keywords: keywords);
    onlineDefinition = OnlineDefinition(
      word: word,
      meaning: meaning,
      synonyms: synonyms,
      antonyms: antonyms,
    );

    err = false;
    fetchStatus = FetchStatus.completed;
    fetchError = FetchError.noError;
  }

  OnlineDefinition getDefinition() {
    return onlineDefinition;
  }

  bool isOk() {
    return !err;
  }

  bool isError() {
    return err;
  }
}

class HTTPResponseStatusCode {
  static const int ok = 200;
  static const int contentNotFound = 204;
  static const int badRequest = 400;
  static const int forbidden = 403;
  static const int resourceExhausted = 429;
  static const int pageNotFound = 404;
  static const int internalServerError = 500;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
}
