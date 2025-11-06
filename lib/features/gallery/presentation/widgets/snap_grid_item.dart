import 'dart:io';
import 'package:flutter/material.dart';

class SnapGridItem extends StatelessWidget {
  const SnapGridItem({
    super.key,
    required this.file,
    required this.dateLabel,
    required this.sizeKB,
    required this.onTap,
  });

  final File file;
  final String dateLabel;
  final int sizeKB;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(file, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              dateLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.deepOrange,
              ),
            ),
            Text(
              '$sizeKB kB',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}