import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samples/src/features/samples/presentation/providers/library.controller.dart';

class LibraryChips extends ConsumerWidget {
  const LibraryChips({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, bool> libraries = ref.watch(libraryControllerProvider);
    return Wrap(
      runSpacing: 8,
      spacing: 8,
      children: [
        for (int i = 0; i < libraries.length; i++)
          ChoiceChip(
            label: Text(
              libraries.keys.toList()[i],
              style: TextStyle(color: libraries.values.toList()[i] ? Colors.white : Colors.black, fontSize: 12),
            ),
            onSelected: (value) async {
              await ref
                  .read(libraryControllerProvider.notifier)
                  .setLibrary(libraries.keys.toList()[i], searchController.text);
            },
            selectedColor: Colors.purple,
            selected: libraries.values.toList()[i],
          ),
      ],
    );
  }
}
