import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:samples/sample.dart';
import 'package:samples/src/features/samples/domain/samples.service.dart';
import 'package:samples/src/features/samples/presentation/providers/count.controller.dart';

part 'samples.controller.g.dart';

@riverpod
class SamplesController extends _$SamplesController {
  Timer? _debounce;

  @override
  Future<List<Sample>> build() async {
    String param = Uri.base.queryParameters['q'] ?? '';
    final filteredSamples = await ref.read(samplesServiceProvider).searchData(param, []);
    ref.read(countControllerProvider.notifier).setValue(filteredSamples.length);
    ref.onDispose(() => _debounce?.cancel());
    return filteredSamples;
  }

  Future<void> searchData(String searchTerm, Map<String, bool> libraries) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      List<String> selectedLibraries =
          libraries.entries.where((entrie) => entrie.value).map((library) => library.key).toList();
      final filteredSamples = await ref.read(samplesServiceProvider).searchData(searchTerm, selectedLibraries);
      ref.read(countControllerProvider.notifier).setValue(filteredSamples.length);
      state = AsyncValue.data(filteredSamples);
    });
  }
}
