class Definition {
  final int id;
  final String word;
  final String meaning;

  const Definition(
      {required this.id, required this.word, required this.meaning});

  Map<String, dynamic> toMap() {
    return {'id': id, 'word': word, 'meaning': meaning};
  }

  @override
  String toString() {
    return "Definition{id: $id, word: $word, meaning: $meaning}";
  }
}

enum QueryError { notFound, internalError, noError }

class DefinitionQueryResult {
  late Definition definition;
  late QueryError queryError;
  late bool err;

  DefinitionQueryResult.define(this.definition) {
    err = false;
    queryError = QueryError.noError;
  }

  DefinitionQueryResult.error(QueryError error) {
    definition = const Definition(id: 0, word: "", meaning: "");
    queryError = error;
    err = true;
  }

  bool isOk() {
    return !err;
  }

  bool isError() {
    return err;
  }

  String getError() {
    switch (queryError) {
      case QueryError.notFound:
        return "Meaning not Found";
      case QueryError.internalError:
        return "SQLite Internal Error";
      case QueryError.noError:
        return "No Error Occurred";
    }
  }

  Definition unwrap() {
    return definition;
  }
}
