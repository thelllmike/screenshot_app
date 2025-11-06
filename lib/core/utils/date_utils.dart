import 'package:intl/intl.dart';

/// Returns 'Today' if same day; otherwise 'd MMM y' (e.g., '1 Nov 2025')
String humanDate(DateTime dt) {
  final now = DateTime.now();
  final isToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
  if (isToday) return 'Today';
  return DateFormat('d MMM y').format(dt);
}