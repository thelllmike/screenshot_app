import 'dart:io';
import 'package:path_provider/path_provider.dart';

final class StorageService {
  Future<Directory> appDocsDir() async => getApplicationDocumentsDirectory();

  Future<Directory> screenshotsDir() async {
    final root = await appDocsDir();
    return Directory('${root.path}/Screenshots');
  }
}