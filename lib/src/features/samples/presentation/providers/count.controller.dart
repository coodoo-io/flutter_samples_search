import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count.controller.g.dart';

@riverpod
class CountController extends _$CountController {
  @override
  int build() {
    return 0;
  }

  setValue(int newValue) {
    state = newValue;
  }
}
