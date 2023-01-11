import 'package:pdf_reader/offline/models.dart';
import 'package:sqflite/sqflite.dart';

import 'load_assets.dart';

const definitionTableName = "dict";
const queryLimit = 10;

Future<Database> openDictionaryDatabase() async {
  return await openDB();
}

Future<void> insertNewMeaning(Definition definition) async {
  final Database db = await openDictionaryDatabase();

  await db.insert(
    definitionTableName,
    definition.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<DefinitionQueryResult> queryMeaning(String word) async {
  final db = await openDictionaryDatabase();

  try {
    final List<Map<String, dynamic>> maps = await db.query(definitionTableName,
        limit: queryLimit, where: 'word = ?', whereArgs: [word.toLowerCase()]);

    if (maps.isEmpty) {
      return DefinitionQueryResult.error(QueryError.notFound);
    } else {
      Definition def = Definition(
        id: maps.first['id'],
        word: maps.first['word'],
        meaning: maps.first['meaning'],
      );
      return DefinitionQueryResult.define(def);
    }
  } catch (e) {
    // Log the error
    return DefinitionQueryResult.error(QueryError.internalError);
  }
}
