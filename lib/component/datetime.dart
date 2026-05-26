import 'package:intl/intl.dart';

import '../libs.dart';

class CompDateTime {
  static DateTime _parseAny(String? dateTime) {
    if ((dateTime ?? "").isEmpty) {
      return Constants.defaultDate;
    }

    // Try standard ISO parsing first
    DateTime? parsed = DateTime.tryParse(dateTime!);
    if (parsed != null) return parsed;

    // Try common formats
    List<String> formats = [
      'yyyy-MM-dd',
      'dd-MM-yyyy',
      'dd/MM/yyyy',
      'MM/dd/yyyy',
      'yyyy/MM/dd',
      'dd MMM yyyy',
      'MMM dd, yyyy',
      'd MMMM yyyy',
    ];

    for (var format in formats) {
      try {
        return DateFormat(format).parse(dateTime);
      } catch (_) {}
    }

    return Constants.defaultDate;
  }

  static String deliverDate(String? dateTime) {
    //Tue, 28 Oct'25, 1:45 PM
    if ((dateTime ?? "").isEmpty) {
      return Constants.defaultString;
    } else {
      return DateFormat("EEE, d MMM''yy, h:mm a").format(_parseAny(dateTime));
    }
  }

  static String showMCZenDate(String? dateTime) {
    // 1 January 1990
    if ((dateTime ?? "").isEmpty) {
      return Constants.defaultString;
    } else {
      return DateFormat("d MMMM  yyyy").format(_parseAny(dateTime));
    }
  }

  static String getDateFormatFromDate({required DateTime dateTime}) {
    return DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
  }

  static String getDateFormatFromString({required String? dateTime}) {
    return DateFormat(
      'yyyy/MM/dd HH:mm',
    ).format(DateTime.parse(dateTime ?? Constants.defaultDate.toString()));
  }

  static String showDateForApiCall(String? dateTime) {
    // Thursday, January 23, 2025
    if ((dateTime ?? "").isEmpty) {
      return Constants.defaultString;
    } else {
      return DateFormat('yyyy-MM-dd').format(_parseAny(dateTime));
    }
  }

  static String showDayOnly(String? dateTime) {
    if ((dateTime ?? "").isEmpty) {
      return Constants.defaultString;
    } else {
      return DateFormat('E').format(_parseAny(dateTime));
    }
  }

  static String showDateOnly(String? dateTime) {
    if ((dateTime ?? "").isEmpty) {
      return Constants.defaultString;
    } else {
      return DateFormat('d').format(_parseAny(dateTime));
    }
  }

  static String showDateTime(String? dateTime) {
    if ((dateTime ?? "").isEmpty) {
      return Constants.defaultString;
    } else {
      return DateFormat('E, d LLL hh:mm a').format(_parseAny(dateTime));
    }
  }

  static String showCardValidity(String? dateTime) {
    if ((dateTime ?? "").isEmpty) {
      return Constants.defaultString;
    } else {
      return DateFormat('d/MM').format(_parseAny(dateTime));
    }
  }

  static String showMonthOnly(String? dateTime) {
    if ((dateTime ?? "").isEmpty) {
      return Constants.defaultString;
    } else {
      return DateFormat('MMM').format(_parseAny(dateTime));
    }
  }

  static String showApiCalling(String? dateTime) {
    if ((dateTime ?? "").isEmpty) {
      return Constants.defaultString;
    } else {
      return DateFormat('yyyy-MM-dd').format(_parseAny(dateTime));
    }
  }

  static String showAge(String? dateString) {
    if ((dateString ?? "").trim().isEmpty) {
      return Constants.defaultString;
    }

    DateTime birthDate = _parseAny(dateString);

    if (birthDate == Constants.defaultDate) {
      return Constants.defaultString;
    }

    final today = DateTime.now();

    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return "$age Years";
  }

  static String showTimeOnly(String? dateTime) {
    if ((dateTime ?? "").isEmpty) {
      return Constants.defaultString;
    } else {
      return DateFormat('jm').format(_parseAny(dateTime));
    }
  }

  static String agoFrom(String? dateTime) {
    if ((dateTime ?? "").isEmpty) {
      return "0 days ago";
    } else {
      DateTime dd = _parseAny(dateTime);

      Duration difference = DateTime.now().difference(dd);

      if (difference.inDays >= 365) {
        int years = (difference.inDays / 365).floor();
        return "$years ${years == 1 ? 'year' : 'years'} ago";
      } else if (difference.inDays >= 30) {
        int months = (difference.inDays / 30).floor();
        return "$months ${months == 1 ? 'month' : 'months'} ago";
      } else if (difference.inDays >= 1) {
        return "${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago";
      } else if (difference.inHours >= 1) {
        return "${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago";
      } else if (difference.inMinutes >= 1) {
        return "${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
      } else {
        return "Just now";
      }
    }
  }

  static String eventDuration(String? minutes) {
    if ((minutes ?? "").isEmpty) {
      return "0h 0m";
    } else {
      int min = int.tryParse(minutes ?? "") ?? 0;
      int hours = min ~/ 60; // Calculate the hours
      int remainingMinutes = min % 60;

      return "${hours}h ${remainingMinutes}m";
    }
  }
}

// Date = 2024-09-11 10:49:45:383528

// d          - 11                           - DAY
// E          - Wed                          - ABBR_WEEKDAY
// EEEE       - Wednesday                    - WEEKDAY
// LLL        - Sep                          - ABBR_STANDALONE_MONTH
// LLLL       - September                    - STANDALONE_MONTH
// M          - 9                            - NUM_MONTH
// Md         - 911                          - NUM_MONTH_DAY
// MEd        - 9Wed11                       - NUM_MONTH_WEEKDAY_DAY
// MMM        - Sep                          - ABBR_MONTH
// MMMd       - Sep 11                       - ABBR_MONTH_DAY
// MMMEd      - Wed, Sep 11                  - ABBR_MONTH_WEEKDAY_DAY
// MMMM       - September                    - MONTH
// MMMMd      - September 11                 - MONTH_DAY
// MMMMEEEEd  - Wednesday, September 11      - MONTH_WEEKDAY_DAY
// QQQ        - Q3                           - ABBR_QUARTER
// QQQQ       - 3rd quarter                  - QUARTER
// y          - 2024                         - YEAR
// yM         - 9/2024                       - YEAR_NUM_MONTH
// yMd        - 9/11/2024                    - YEAR_NUM_MONTH_DAY
// yMEd       - Wed, 9/11/2024               - YEAR_NUM_MONTH_WEEKDAY_DAY
// yMMM       - Sep 2024                     - YEAR_ABBR_MONTH
// yMMMd      - Sep 11,2024                  - YEAR_ABBR_MONTH_DAY
// yMMMEd     - Wed, Sep 11,2024             - YEAR_ABBR_MONTH_WEEKDAY_DAY
// yMMMM      - September 2024               - YEAR_MONTH
// yMMMMd     - September 11,2024            - YEAR_MONTH_DAY
// yMMMMEEEEd - Wednesday, September 11,2024 - YEAR_MONTH_WEEKDAY_DAY
// yQQQ       - Q3 2024                      - YEAR_ABBR_QUARTER
// yQQQQ      - 3rd quarter 2024             - YEAR_QUARTER
// H          - 10                           - HOUR24
// Hm         - 10:49                        - HOUR24_MINUTE
// Hms        - 10:49:45                     - HOUR24_MINUTE_SECOND
// j          - 10 AM                        - HOUR
// jm         - 10:49 AM                     - HOUR_MINUTE
// jms        - 10:49:45 AM                  - HOUR_MINUTE_SECOND
// m          - 49                           - MINUTE
// ms         - 49:45                        - MINUTE_SECOND
// s          - 45                           - SECOND
// jmv        - 10:49 AM                     - HOUR_MINUTE_GENERIC_TZ (not yet implemented)
// jv         - j                            - HOUR_GENERIC_TZ (not yet implemented)
// jz         - 10 Am                        - HOUR_TZ (not yet implemented)
