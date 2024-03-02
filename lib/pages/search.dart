import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:relayered/functions.dart';

import '../data.dart';
import '../task.dart';
import '../widgets/body.dart';

class Delegate extends SearchDelegate {
  @override
  buildLeading(BuildContext context) {
    if (query.isEmpty) {
      return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );
    } else {
      return IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.close_rounded),
      );
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  appBarTheme(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.apply(
          bodyColor: Theme.of(context).appBarTheme.foregroundColor,
        );

    return Theme.of(context).copyWith(
      textTheme: textTheme,
      inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
      hintColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SuggestionList(query: query, key: Key(query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SuggestionList(query: query, key: Key(query));
  }
}

class SuggestionList extends StatefulWidget {
  final String query;

  const SuggestionList({
    super.key,
    required this.query,
  });
  @override
  SuggestionListState createState() => SuggestionListState();
}

class SuggestionListState extends State<SuggestionList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: refreshLay,
      builder: (context, non, child) {
        List<Task> results = [];
        String query = widget.query.toLowerCase();
        for (Folder folder in structure.values) {
          if (folder.name.toLowerCase().contains(query)) {
            results.addAll(folder.items);
            continue;
          }
          for (Task task in folder.items) {
            if (task.name.toLowerCase().contains(query) ||
                Document.fromJson(
                  json.decode(task.desc),
                ).toPlainText().toLowerCase().contains(query)) {
              results.add(task);
            }
          }
        }
        results.sort((a, b) => a.name.compareTo(b.name));
        return Scaffold(
          body: Body(
            child: ListView.builder(
              itemCount: results.length,
              physics: scrollPhysics,
              padding: const EdgeInsets.symmetric(
                vertical: 32,
                horizontal: 16,
              ),
              itemBuilder: (context, i) => settingToTile(
                results[i].toSetting(),
                context,
              ),
            ),
          ),
        );
      },
    );
  }
}
