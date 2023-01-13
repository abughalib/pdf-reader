import 'package:flutter/material.dart';
import 'package:pdf_reader/offline/db_op.dart';
import 'package:pdf_reader/offline/models.dart';
import 'package:pdf_reader/online/fetch_definition.dart';
import 'package:pdf_reader/online/models.dart';

// To be moved to utils
enum Connectivity {
  online,
  offline,
}

class ShowDefinition extends StatefulWidget {
  const ShowDefinition({super.key, required this.selectedWord});

  final String selectedWord;

  @override
  State<ShowDefinition> createState() => _ShowDefinitionState();
}

class _ShowDefinitionState extends State<ShowDefinition> {
  // Check Internet Connectivity here;
  Connectivity connectivity = Connectivity.online;

  @override
  Widget build(BuildContext context) {
    switch (connectivity) {
      case Connectivity.online:
        return OnlineMeaning(selectedWord: widget.selectedWord);
      case Connectivity.offline:
        return OfflineMeaning(selectedWord: widget.selectedWord);
    }
  }
}

class OfflineMeaning extends StatelessWidget {
  const OfflineMeaning({super.key, required this.selectedWord});

  final String selectedWord;
  final String meaning = "";

  Future<String> queryDefinition() async {
    DefinitionQueryResult result = await queryMeaning(selectedWord);

    return result.isOk() ? result.definition.meaning : result.getError();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15.0),
      child: FutureBuilder(
        future: queryDefinition(),
        initialData: "Fetching...",
        builder: (context, AsyncSnapshot<String> snapshot) =>
            SingleChildScrollView(
          child: SizedBox(
            height: 250,
            width: 250,
            child: Center(child: Text(snapshot.data ?? "")),
          ),
        ),
      ),
    );
  }
}

class OnlineMeaning extends StatelessWidget {
  OnlineMeaning({super.key, required this.selectedWord});

  final String selectedWord;
  final Meaning meaning = Meaning(def: [], keywords: []);

  Future<DefinitionFormat> fetchDefinition() async {
    OnlineDefinitionResult result = await definitionResult(selectedWord);
    return DefinitionFormat(onlineDefinitionResult: result);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<Widget>(
        future: fetchDefinition(),
        initialData: DefinitionFormat(
          onlineDefinitionResult:
              OnlineDefinitionResult.status(FetchStatus.loading),
        ),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) =>
            snapshot.data!,
      ),
    );
  }
}

class DefinitionFormat extends StatelessWidget {
  const DefinitionFormat({Key? key, required this.onlineDefinitionResult})
      : super(key: key);

  final OnlineDefinitionResult onlineDefinitionResult;

  @override
  Widget build(BuildContext context) {
    if (onlineDefinitionResult.fetchStatus == FetchStatus.loading) {
      return const Center(child: Text("Loading Meaning..."));
    } else if (onlineDefinitionResult.fetchStatus == FetchStatus.error) {
      return const Center(child: Text("Error..."));
    } else {
      return SizedBox(
        height: 300,
        width: 200,
        // BoxConstraints are useless for Alert Dialog
        // constraints: const BoxConstraints(
        //   maxHeight: double.maxFinite,
        //   maxWidth: double.maxFinite,
        // ),
        child: FormatMeaning(
          meaning: onlineDefinitionResult.onlineDefinition.meaning,
        ),
      );
    }
  }
}

class FormatMeaning extends StatelessWidget {
  const FormatMeaning({Key? key, required this.meaning}) : super(key: key);

  final Meaning meaning;

  TextStyle getFontStyle(int index) {
    if (index.isEven) {
      return const TextStyle(fontWeight: FontWeight.bold);
    }
    return const TextStyle();
  }

  SizedBox listItemSpace(int index) {
    if (index.isEven) {
      return const SizedBox();
    }
    return const SizedBox(height: 15);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: meaning.def.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          // Move value to constants
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            meaning.def[index],
            style: getFontStyle(index),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return listItemSpace(index);
      },
    );
  }
}
