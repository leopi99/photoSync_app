import 'package:rxdart/rxdart.dart';

abstract class BlocBase {
  late BehaviorSubject<bool> _loadingSubject;
  Stream<bool> get loadingStream => _loadingSubject.stream;

  void changeLoading(bool value) => _loadingSubject.add(value);

  BlocBase() {
    _loadingSubject = BehaviorSubject<bool>.seeded(false);
  }

  dispose() {
    _loadingSubject.close();
  }
}
