import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:samples/sample.dart';
import 'package:samples/src/features/samples/data/local/samples.api.dart';

part 'samples.repo.g.dart';

@riverpod
SamplesRepo samplesRepo(SamplesRepoRef ref) {
  return SamplesRepo(api: ref.read(samplesApiProvider));
}

class SamplesRepo {
  SamplesRepo({required this.api});

  final SamplesApi api;

  Future<List<Sample>> getSamples() async {
    return await api.getSamples();
  }
}
