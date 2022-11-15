import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:samples/src/features/samples/presentation/providers/samples.controller.dart';

part 'library.controller.g.dart';

@riverpod
class LibraryController extends _$LibraryController {
  @override
  Map<String, bool> build() {
    return {
      'material': false,
      'widgets': false,
      'cupertino': false,
      'dart:ui': false,
      'services': false,
      'rendering': false,
      'chip': false,
      'focus_manager': false,
      'painting': false,
      'animation': false,
      'gestures': false,
      'scrollbar': false,
    };
  }

  Future<void> setLibrary(String libraryName, String searchTerm) async {
    // make deep copy to force change
    Map<String, bool> currentLibraries = Map<String, bool>.from(state);
    if (currentLibraries.containsKey(libraryName)) {
      currentLibraries[libraryName] = !currentLibraries[libraryName]!;
    }
    await ref.read(samplesControllerProvider.notifier).searchData(searchTerm, currentLibraries);
    state = currentLibraries;
  }
}
