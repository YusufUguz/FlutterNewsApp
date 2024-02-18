import 'package:intl/intl.dart';

String calculateTimeAgo(String publishedAt) {
  DateTime now = DateTime.now();
  int nowYear = DateTime.now().year;
  DateTime publicationDate = DateTime.parse(publishedAt);
  int publicationDateYear = publicationDate.year;

  Duration difference = now.difference(publicationDate);

  if (difference.inDays > 0 && publicationDateYear != nowYear) {
    return DateFormat('d MMM y\nHH:mm', 'tr_TR').format(publicationDate);
  } else if (difference.inDays > 0 && publicationDateYear == nowYear) {
    return '${difference.inDays} gün önce';
  }

  if (difference.inHours > 0 && difference.inHours < 100) {
    return '${difference.inHours} saat önce';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} dak. önce';
  } else {
    return 'Şimdi';
  }
}
