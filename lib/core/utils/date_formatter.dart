import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) return 'Il y a ${diff.inMinutes} min';
      return 'Il y a ${diff.inHours} h';
    }
    if (diff.inDays == 1) return 'Hier';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays} jours';
    return formatDate(date);
  }

  static DateTime? parseDate(String date) {
    try {
      return DateFormat('dd/MM/yyyy').parse(date);
    } catch (_) {
      return null;
    }
  }
}
