import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../services/storage_service.dart';
import '../models/snap_image.dart';

final class SnapRepository {
  SnapRepository(this._storage);

  final StorageService _storage;

  Future<List<SnapImage>> list() async {
    final dir = await _storage.screenshotsDir();
    if (!await dir.exists()) return [];
    final files = dir.listSync().whereType<File>().toList();
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return files
        .map((f) => SnapImage(
              file: f,
              modified: f.lastModifiedSync(),
              sizeBytes: f.lengthSync(),
            ))
        .toList(growable: false);
  }

  Future<File> savePng(Uint8List bytes) async {
    final dir = await _storage.screenshotsDir();
    await dir.create(recursive: true);
    final ts = DateTime.now();
    final name =
        'Snap_${ts.year}${_two(ts.month)}${_two(ts.day)}_${_two(ts.hour)}${_two(ts.minute)}${_two(ts.second)}.png';
    final f = File('${dir.path}/$name');
    return f.writeAsBytes(bytes, flush: true);
  }

  Future<void> delete(SnapImage image) async {
    if (await image.file.exists()) {
      await image.file.delete();
    }
  }

  String _two(int v) => v.toString().padLeft(2, '0');
}