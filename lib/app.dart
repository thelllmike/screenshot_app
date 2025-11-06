import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/gallery/presentation/pages/gallery_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen Snap',
      theme: AppTheme.build(),
      home: const GalleryPage(),
    );
  }
}