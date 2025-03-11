import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('weight_data');
    final entries = box.toMap().entries.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final date = entries[index].key;
          final weight = entries[index].value;
          return ListTile(
            title: Text("$date"),
            subtitle: Text("Weight: $weight"),
          );
        },
      ),
    );
  }
}
