class StringUtil {
  static String formatDuration(int timeParam) {
    int second = timeParam % 60;
    int minuteTemp = timeParam ~/ 60;
    if (minuteTemp > 0) {
      int minute = minuteTemp % 60;
      return (minute >= 10 ? ("$minute") : ("0$minute")) +
          ":" +
          (second >= 10 ? ("$second") : ("0$second"));
    } else {
      return "00:" + (second >= 10 ? ("$second") : ("0$second"));
    }
  }

  static String formatDuration2(int timeParam) {
    int second = timeParam % 60;
    int minuteTemp = timeParam ~/ 60;
    if (minuteTemp > 0) {
      int minute = minuteTemp % 60;
      return (minute >= 10 ? ("$minute'") : ("0$minute'")) +
          (second >= 10 ? ("$second''") : ("0$second''"));
    } else {
      return "00'" + (second >= 10 ? ("$second''") : ("0$second''"));
    }
  }

  static String buildTags(List tags) {
    if (tags.length > 3) tags.removeRange(2, tags.length - 1);
    var tagStr = '#';
    for (int i = 0; i < tags.length; i++) {
      tagStr += tags[i]['name'];
      if (i != tags.length - 1) {
        tagStr += '/';
      }
    }
    return tagStr;
  }

  static formatMileToDate({int miles = 0, String separator = '/'}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(miles);
    var year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    String monthStr = month < 10 ? '0$month' : month.toString();
    String dayStr = day < 10 ? '0$day' : day.toString();
    return '$year$separator$monthStr$separator$dayStr';
  }
}
