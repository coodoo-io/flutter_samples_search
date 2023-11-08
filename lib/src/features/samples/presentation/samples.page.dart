import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samples/src/core/widgets/loading.dart';
import 'package:samples/src/features/samples/presentation/providers/library.controller.dart';
import 'package:samples/src/features/samples/presentation/providers/samples.controller.dart';
import 'package:samples/src/features/samples/presentation/providers/samples_search.controller.dart';
import 'package:samples/src/features/samples/presentation/widgets/library_chips_list.dart';
import 'package:samples/src/features/samples/presentation/widgets/samples_list.dart';
import 'package:samples/src/features/samples/presentation/widgets/samples_search.dart';

class SamplePage extends ConsumerWidget {
  SamplePage({
    super.key,
    required this.theme,
  });

  final ThemeData theme;
  final TextEditingController searchController = TextEditingController();
  final double maxWidth = 960.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController searchController = ref.watch(samplesSearchControllerProvider);
    final Map<String, bool> libraries = ref.watch(libraryControllerProvider);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SampleSearch(
              libraries: libraries,
              maxWidth: maxWidth,
              searchController: searchController,
            ),
            const SizedBox(height: 16),
            Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: LibraryChips(
                searchController: searchController,
              ),
            ),
            const SizedBox(height: 16),
            ref.watch(samplesControllerProvider).when(
                  data: (samples) {
                    return SampleLists(
                      samples: samples,
                      maxWidth: maxWidth,
                    );
                  },
                  error: (error, _) => const Text('ERROR'),
                  loading: () => const Loading(),
                ),
          ],
        ),
      ),
    );
  }
}
