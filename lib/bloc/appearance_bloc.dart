import 'package:photo_sync/models/appearance.dart';
import 'package:photo_sync/util/enums/appearance_mode_type.dart';
import 'package:rxdart/rxdart.dart';

class AppearanceBloc {
  late BehaviorSubject<Appearance> _appearanceSubject;
  Stream<Appearance> get appearanceStream => _appearanceSubject.stream;
  Appearance get appearance => _appearanceSubject.value;

  void changeAppearance(AppearanceModeType type) {}
}
