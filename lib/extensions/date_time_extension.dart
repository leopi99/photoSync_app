extension DateTimeExtension on DateTime {
  ///Input: DateTime => 05/11/2021
  String get toDayMonthYear =>
      "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";

  ///Input: DateTime => 05-11-2021
  String get toDayMonthYearScoreDivided =>
      "${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-$year";
}
