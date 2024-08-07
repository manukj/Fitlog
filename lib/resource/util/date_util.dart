class DateUtil {
  static DateTime getToday() {
    return getOnlyDate(DateTime.now());
  }

  static DateTime getOnlyDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
