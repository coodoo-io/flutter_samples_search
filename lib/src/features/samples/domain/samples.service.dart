import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:samples/sample.dart';
import 'package:samples/src/features/samples/data/samples.repo.dart';

part 'samples.service.g.dart';

@riverpod
SamplesService samplesService(SamplesServiceRef ref) {
  return SamplesService(repo: ref.read(samplesRepoProvider));
}

class SamplesService {
  SamplesService({required this.repo});

  final SamplesRepo repo;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<List<Sample>> getSamples() async {
    List<Sample> samples = await repo.getSamples();
    samples.sort((a, b) => a.element.toLowerCase().compareTo(b.element.toLowerCase()));
    return samples;
  }

  Future<List<Sample>> searchData(String searchTerm, List<String> selectedLibraries) async {
    List<Sample> samples = await repo.getSamples();
    samples.sort((a, b) => a.element.toLowerCase().compareTo(b.element.toLowerCase()));
    final libraryList = samples
        .where((s) => (selectedLibraries.isEmpty || selectedLibraries.contains(s.sampleLibrary.toLowerCase())))
        .toList();
    final filteredList = libraryList
        .where(
          (s) => ((selectedLibraries.isEmpty || selectedLibraries.contains(s.sampleLibrary.toLowerCase())) &&
                  s.element.toLowerCase().contains(searchTerm.toLowerCase()) ||
              s.id.toLowerCase().startsWith(searchTerm.toLowerCase()) ||
              s.description.toLowerCase().contains(searchTerm.toLowerCase())),
        )
        .toList();
    filteredList.sort((a, b) => a.element.toLowerCase().compareTo(b.element.toLowerCase()));
    await analytics.logEvent(
      name: 'search samples',
      parameters: <String, dynamic>{'searchTerm': '', 'selectedLibraries': selectedLibraries},
    );
    return filteredList;
  }
}
