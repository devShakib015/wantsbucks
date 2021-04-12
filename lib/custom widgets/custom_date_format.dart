String customDateFormat(DateTime _date) {
  var _hour = _date.hour;
  var _minute = _date.minute;
  var _year = _date.year;
  var _month = _date.month;
  var _day = _date.day;
  return "$_day/$_month/$_year $_hour:$_minute";
}
