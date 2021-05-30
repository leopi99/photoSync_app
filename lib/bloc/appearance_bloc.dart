import 'package:photo_sync/constants/appearance.dart';
import 'package:photo_sync/util/enums/appearance_mode_type.dart';
import 'package:photo_sync/util/enums/shared_type.dart';
import 'package:photo_sync/util/shared_manager.dart';
import 'package:rxdart/rxdart.dart';

class AppearanceBloc {
  AppearanceBloc() {
    _appearanceSubject = BehaviorSubject.seeded(Appearance());
    _appearanceSubject.listen((value) {
      print(
          'Changed app appearance to ${value.currentType.toValueWithSeparation}');
      SharedManager()
          .writeString(SharedType.AppAppearance, value.currentType.toValue);
    });
    _getSavedAppearance();
  }

  Future<void> _getSavedAppearance() async {
    String? appearance =
        await SharedManager().readString(SharedType.AppAppearance);
    if (appearance == null) return;
    AppearanceModeType _mode = AppearanceModeType.Follow_System;
    for (int i = 0; i < AppearanceModeType.values.length; i++) {
      if (AppearanceModeType.values[i].toValue == appearance) {
        _mode = AppearanceModeType.values[i];
        break;
      }
    }
    changeAppearance(_mode);
  }

  late BehaviorSubject<Appearance> _appearanceSubject;
  Stream<Appearance> get appearanceStream => _appearanceSubject.stream;
  Appearance get appearance => _appearanceSubject.value;

  void changeAppearance(AppearanceModeType type) =>
      _appearanceSubject.add(Appearance(type: type));

  dispose() {
    _appearanceSubject.close();
  }
}
