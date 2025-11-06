import 'dart:io';
import 'package:flutter/material.dart';

class ViewerPage extends StatelessWidget {
  const ViewerPage({super.key, required this.file});
  final File file;

  @override
  Widget build(BuildContext context) {
    final kb = (file.lengthSync() / 1024).round();
    final dt = file.lastModifiedSync();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: [
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete),
            onPressed: () async {
              if (await file.exists()) {
                await file.delete();
              }
              if (context.mounted) Navigator.pop(context, true);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Image.file(file, fit: BoxFit.contain)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${dt.toLocal()}'),
                Text('$kb kB'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}