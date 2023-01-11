import 'package:flutter/material.dart';
import 'package:pdf_reader/offline/db_op.dart';
import 'package:pdf_reader/offline/models.dart';

class ShowDefinition extends StatefulWidget {
  const ShowDefinition({super.key, required this.selectedWord});

  final String selectedWord;

  @override
  State<ShowDefinition> createState() => _ShowDefinitionState();
}

class _ShowDefinitionState extends State<ShowDefinition> {
  String meaning = "";

  Future<String> fetchDefinition() async {
    DefinitionQueryResult result = await queryMeaning(widget.selectedWord);

    return result.isOk() ? result.definition.meaning : result.getError();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      alignment: Alignment.center,
      child: FutureBuilder(
        future: fetchDefinition(),
        initialData: "Fetching...",
        builder: (context, AsyncSnapshot<String> snapshot) =>
            SingleChildScrollView(
          child: Text(snapshot.data ?? ""),
        ),
      ),
    );
  }
}
