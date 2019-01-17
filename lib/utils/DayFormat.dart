import 'DateFormat.dart';

///(xx)Configurable output.
///(xx)为可配置输出.
enum DayFormat {
  ///(less than 10s->just now)、x minutes、x hours、(Yesterday)、x days.
  ///(小于10s->刚刚)、x分钟、x小时、(昨天)、x天.
  Simple,

  ///(less than 10s->just now)、x minutes、x hours、[This year:(Yesterday/a day ago)、(two days age)、MM-dd ]、[past years: yyyy-MM-dd]
  ///(小于10s->刚刚)、x分钟、x小时、[今年: (昨天/1天前)、(2天前)、MM-dd],[往年: yyyy-MM-dd].
  Common,

  ///日期 + HH:mm
  ///(less than 10s->just now)、x minutes、x hours、[This year:(Yesterday HH:mm/a day ago)、(two days age)、MM-dd HH:mm]、[past years: yyyy-MM-dd HH:mm]
  ///小于10s->刚刚)、x分钟、x小时、[今年: (昨天 HH:mm/1天前)、(2天前)、MM-dd HH:mm],[往年: yyyy-MM-dd HH:mm].
  Full,
}

class ZhInfo  {
  String suffixAgo='前';

  String suffixAfter='后';

  String lessThanTenSecond= '刚刚';

  String customYesterday='昨天';

  bool keepOneDay= true;

  bool keepTwoDays=true;

  String oneMinute(int minutes) => '$minutes分钟';

  String minutes(int minutes) => '$minutes分钟';

  String anHour(int hours) => '$hours小时';

  String hours(int hours) => '$hours小时';

  String oneDay(int days) => '$days天';

  String days(int days) => '$days天';
}



///
class TimelineUtil {
  /// format time by DateTime.
  /// dateTime
  /// locDateTime: current time or schedule time.
  /// locale: output key.
  static String formatByDateTime(DateTime dateTime,
      {DateTime locDateTime, String locale, DayFormat dayFormat}) {
    int _locDateTime =
        (locDateTime == null ? null : locDateTime.millisecondsSinceEpoch);
    return format(dateTime.millisecondsSinceEpoch,
        locTimeMillis: _locDateTime, locale: locale, dayFormat: dayFormat);
  }

  /// format time by millis.
  /// dateTime : millis.
  /// locDateTime: current time or schedule time. millis.
  /// locale: output key.
  static String format(int timeMillis,
      {int locTimeMillis, String locale, DayFormat dayFormat}) {
    int _locTimeMillis = locTimeMillis ?? DateTime.now().millisecondsSinceEpoch;
    var _info = ZhInfo();
    DayFormat _dayFormat =  DayFormat.Common;

    int elapsed = _locTimeMillis - timeMillis;
    String suffix;
    if (elapsed < 0) {
      elapsed = elapsed.abs();
      suffix = _info.suffixAfter;
      _dayFormat = DayFormat.Simple;
    } else {
      suffix = _info.suffixAgo;
    }

    String timeline;
    if (_info.customYesterday.isNotEmpty &&
        DateUtil.isYesterdayByMillis(timeMillis, _locTimeMillis)) {
      return _getYesterday(timeMillis, _info, _dayFormat);
    }

    if (!DateUtil.yearIsEqualByMillis(timeMillis, _locTimeMillis)) {
      timeline = _getYear(timeMillis, _dayFormat);
      if (timeline.isNotEmpty) return timeline;
    }

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    if (seconds < 120) {
      timeline = _info.oneMinute(1);
      if (suffix != _info.suffixAfter &&
          _info.lessThanTenSecond.isNotEmpty &&
          seconds < 10) {
        timeline = _info.lessThanTenSecond;
        suffix = "";
      }
    } else if (minutes < 60) {
      timeline = _info.minutes(minutes.round());
    } else if (hours < 24) {
      timeline = _info.hours(hours.round());
    } else {
      if ((days.round() == 1 && _info.keepOneDay== true) ||
          (days.round() == 2 && _info.keepTwoDays == true)) {
        _dayFormat = DayFormat.Simple;
      }
      timeline = _formatDays(timeMillis, days.round(), _info, _dayFormat);
      suffix = (_dayFormat == DayFormat.Simple ? suffix : "");
    }
    return timeline + suffix;
  }

  /// get Yesterday.
  /// 获取昨天.
  static String _getYesterday(
      int timeMillis, ZhInfo info, DayFormat dayFormat) {
    return info.customYesterday +
        (dayFormat == DayFormat.Full
            ? (" " +
                DateUtil.getDateStrByMs(timeMillis,
                    format: DateFormat.HOUR_MINUTE))
            : "");
  }

  /// get is not year info.
  /// 获取非今年信息.
  static String _getYear(int timeMillis, DayFormat dayFormat) {
    if (dayFormat != DayFormat.Simple) {
      return DateUtil.getDateStrByMs(timeMillis,
          format: (dayFormat == DayFormat.Common
              ? DateFormat.YEAR_MONTH_DAY
              : DateFormat.YEAR_MONTH_DAY_HOUR_MINUTE));
    }
    return "";
  }

  ///format Days.
  static String _formatDays(int timeMillis, num days, ZhInfo timelineInfo,
      DayFormat dayFormat) {
    String timeline;
    switch (dayFormat) {
      case DayFormat.Simple:
        timeline = (days == 1
            ? timelineInfo.oneDay(days.round())
            : timelineInfo.days(days.round()));
        break;
      case DayFormat.Common:
        timeline = DateUtil.getDateStrByMs(timeMillis,
            format: DateFormat.MONTH_DAY);
        break;
      case DayFormat.Full:
        timeline = DateUtil.getDateStrByMs(timeMillis,
            format: DateFormat.MONTH_DAY_HOUR_MINUTE);
        break;
    }
    return timeline;
  }
}
