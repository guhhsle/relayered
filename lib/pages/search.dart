import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../data.dart';
import '../task.dart';
import '../template/data.dart';
import '../template/functions.dart';
import '../widgets/frame.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<StatefulWidget> createState() => SearchState();
}

class SearchState extends State<Search> {
  String query = '';
  String start = '';
  @override
  Widget build(BuildContext context) {
    List<String> chars = [''];
    for (var folder in structure.entries) {
      for (var task in folder.value.items) {
        String char = task.name[0];
        if (!chars.contains(char)) chars.add(char);
      }
    }
    chars.sort();
    return Frame(
      title: TextFormField(
        maxLines: 1,
        maxLength: 24,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: t('Search'),
          hintStyle: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor!.withOpacity(0.5),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (title) {
          query = title.toLowerCase();
          start = '';
          setState(() {});
        },
      ),
      child: ValueListenableBuilder(
        valueListenable: refreshLay,
        builder: (context, non, child) {
          List<Task> results = [];
          for (Folder folder in structure.values) {
            if (folder.name.toLowerCase().contains(query) && start == '') {
              results.addAll(folder.items);
              continue;
            }
            for (Task task in folder.items) {
              if (!task.name.startsWith(start)) continue;
              if (task.name.toLowerCase().contains(query) ||
                  Document.fromJson(
                    json.decode(task.desc),
                  ).toPlainText().toLowerCase().contains(query)) {
                results.add(task);
              }
            }
          }
          results.sort((a, b) => a.name.compareTo(b.name));
          return Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  physics: scrollPhysics,
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 8,
                  ),
                  itemBuilder: (context, i) => results[i].toSetting().toTile(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onPanUpdate: (details) {
                        late String next;
                        try {
                          double proportion = constraints.maxHeight / details.localPosition.dy;
                          int i = chars.length ~/ proportion;
                          next = chars[i];
                        } catch (e) {
                          next = '';
                        }
                        if (start != next) {
                          start = next;
                          query = '';
                          setState(() {});
                        }
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        margin: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var char in chars)
                                Text(
                                  char,
                                  style: TextStyle(
                                    color: start == char ? Theme.of(context).colorScheme.background : null,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
