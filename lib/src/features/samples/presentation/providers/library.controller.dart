import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:samples/sample.dart';
import 'package:samples/src/features/samples/domain/samples.service.dart';
import 'package:samples/src/features/samples/presentation/providers/samples.controller.dart';

part 'library.controller.g.dart';

@riverpod
class LibraryController extends _$LibraryController {
  @override
  Map<String, bool> build() {
    getLibraries();
    return {};
  }

  Future<void> getLibraries() async {
    Map<String, bool> libraries = {};
    List<Sample> samples = await ref.read(samplesServiceProvider).getSamples();
    for (Sample sample in samples) {
      if (!libraries.keys.contains(sample.sampleLibrary)) {
        libraries.addAll({sample.sampleLibrary: false});
      }
    }
    state = libraries;
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
