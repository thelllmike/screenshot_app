import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';


import '../../../../core/utils/date_utils.dart';
import '../../../../data/models/snap_image.dart';
import '../../../../data/repositories/snap_repository.dart';
import '../../../../services/capture_service.dart';
import '../../../../services/storage_service.dart';
import '../../../viewer/presentation/pages/viewer_page.dart';
import '../widgets/snap_grid_item.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final _screenshot = ScreenshotController();
  late final SnapRepository _repo;
  late final CaptureService _capture;

  bool _showBubble = false;
  Offset _bubblePos = const Offset(24, 200);

  List<SnapImage> _images = [];

  @override
  void initState() {
    super.initState();
    final storage = StorageService();
    _repo = SnapRepository(storage);
    _capture = CaptureService(_repo);
    _refresh();
  }

  Future<void> _refresh() async {
    final list = await _repo.list();
    if (mounted) setState(() => _images = list);
  }

  Future<void> _captureNow() async {
    try {
      await _capture.captureNow(_screenshot);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
      await _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Capture failed: $e')));
    }
  }

  Future<void> _captureTimer() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Capturing in 3s…')));
    try {
      await _capture.captureAfter(_screenshot, 3);
      await _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Capture failed: $e')));
    }
  }

  void _toggleBubble() {
    setState(() => _showBubble = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Drag & tap the bubble to save')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with Screenshot to capture the visible Flutter UI.
    return Screenshot(
      controller: _screenshot,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('Your Screenshots'),
              actions: [
                IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
              ],
            ),
            body: _images.isEmpty
                ? const Center(child: Text('No screenshots yet'))
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      itemCount: _images.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.62,
                      ),
                      itemBuilder: (ctx, i) {
                        final snap = _images[i];
                        return SnapGridItem(
                          file: snap.file,
                          dateLabel: humanDate(snap.modified),
                          sizeKB: snap.sizeKB,
                          onTap: () async {
                            final deleted = await Navigator.of(context).push<bool>(
                              MaterialPageRoute(
                                builder: (_) => ViewerPage(file: snap.file),
                              ),
                            );
                            if (deleted == true) _refresh();
                          },
                        );
                      },
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    title: const Text('Choose method'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _captureTimer();
                        },
                        child: const Text('Timer'),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _toggleBubble();
                        },
                        child: const Text('On-screen button'),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.camera),
            ),
          ),

          // Draggable on-screen button (inside THIS app)
          if (_showBubble)
            Positioned(
              left: _bubblePos.dx,
              top: _bubblePos.dy,
              child: GestureDetector(
                onPanUpdate: (details) =>
                    setState(() => _bubblePos += details.delta),
                onTap: _captureNow,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}