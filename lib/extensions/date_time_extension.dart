extension DateTimeExtension on DateTime {
  ///Input: DateTime => 05/11/2021
  String get toDayMonthYear =>
      "${this.day.toString().padLeft(2, '0')}/${this.month.toString().padLeft(2, '0')}/${this.year}";

  ///Input: DateTime => 05-11-2021
  String get toDayMonthYearScoreDivided =>
      "${this.day.toString().padLeft(2, '0')}-${this.month.toString().padLeft(2, '0')}-${this.year}";
}
