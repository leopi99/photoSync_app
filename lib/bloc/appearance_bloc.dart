import 'package:flutter/foundation.dart';
import 'package:photo_sync/constants/appearance.dart';
import 'package:photo_sync/util/enums/appearance_mode_type.dart';
import 'package:photo_sync/util/enums/shared_type.dart';
import 'package:photo_sync/util/shared_manager.dart';
import 'package:rxdart/rxdart.dart';

class AppearanceBloc {
  AppearanceBloc() {
    _appearanceSubject = BehaviorSubject.seeded(Appearance());
    _appearanceSubject.listen((value) {
      debugPrint(
          'Changed app appearance to ${value.currentType.toValueWithSeparation}');
      SharedManager()
          .writeString(SharedType.appAppearance, value.currentType.toValue);
    });
    _getSavedAppearance();
  }

  //Fetches the saved preference for the app theme
  Future<void> _getSavedAppearance() async {
    String? appearance =
        await SharedManager().readString(SharedType.appAppearance);
    if (appearance == null) return;
    //If The value is not saved (or not available in the types), sets the follow system
    AppearanceModeType _mode = AppearanceModeType.followSystem;
    for (int i = 0; i < AppearanceModeType.values.length; i++) {
      if (AppearanceModeType.values[i].toValue == appearance) {
        _mode = AppearanceModeType.values[i];
        break;
      }
    }
    changeAppearance(_mode);
  }

  //
  //  Appearance
  //

  late BehaviorSubject<Appearance> _appearanceSubject;
  Stream<Appearance> get appearanceStream => _appearanceSubject.stream;
  Appearance get appearance => _appearanceSubject.value;

  void changeAppearance(AppearanceModeType type) =>
      _appearanceSubject.add(Appearance(type: type));

  dispose() {
    _appearanceSubject.close();
  }
}
