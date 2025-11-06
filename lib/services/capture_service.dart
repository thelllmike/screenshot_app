import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';
import '../data/repositories/snap_repository.dart';

final class CaptureService {
  CaptureService(this._repo);

  final SnapRepository _repo;

  /// Captures the current Flutter UI bound to [controller] and persists it.
  Future<void> captureNow(ScreenshotController controller) async {
    final bytes = await controller.capture(pixelRatio: 2.0);
    if (bytes == null) throw StateError('Capture returned null');
    await _repo.savePng(bytes);
  }

  /// Waits [seconds], then captures once.
  Future<void> captureAfter(ScreenshotController controller, int seconds) async {
    await Future<void>.delayed(Duration(seconds: seconds));
    await captureNow(controller);
  }
}