import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samples/src/features/samples/presentation/providers/count.controller.dart';
import 'package:samples/src/features/samples/presentation/providers/samples.controller.dart';

class SampleSearch extends ConsumerWidget {
  const SampleSearch({
    Key? key,
    required this.maxWidth,
    required this.libraries,
    required this.searchController,
  }) : super(key: key);

  final double maxWidth;
  final Map<String, bool> libraries;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(countControllerProvider);
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: TextField(
        controller: searchController,
        onChanged: (value) async {
          await ref.read(samplesControllerProvider.notifier).searchData(value, libraries);
        },
        decoration: InputDecoration(
          hintText: 'Search in $count Flutter Samples...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            borderSide: BorderSide(color: Color(0xffefefef), width: 2.0),
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () async {
                    searchController.clear();
                    await ref.read(samplesControllerProvider.notifier).searchData('', libraries);
                  },
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
