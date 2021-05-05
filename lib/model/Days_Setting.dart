import 'package:meta/meta.dart';

class DaysSetting {
  String title;
  bool value;

  DaysSetting({
    @required this.title,
    this.value = false,
  });
}