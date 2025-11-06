import 'dart:io';

final class SnapImage {
  final File file;
  final DateTime modified;
  final int sizeBytes;

  const SnapImage({
    required this.file,
    required this.modified,
    required this.sizeBytes,
  });

  String get name => file.uri.pathSegments.last;
  int get sizeKB => (sizeBytes / 1024).round();
}