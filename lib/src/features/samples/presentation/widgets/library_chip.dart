import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samples/src/features/samples/presentation/providers/library.controller.dart';

class LibraryChip extends ConsumerWidget {
  const LibraryChip({
    super.key,
    required this.library,
    required this.isSelected,
    required this.searchController,
  });

  final String library;
  final bool isSelected;
  final TextEditingController searchController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ChoiceChip(
      label: Text(
        library,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12),
      ),
      onSelected: (value) async {
        await ref.read(libraryControllerProvider.notifier).setLibrary(library, searchController.text);
      },
      selectedColor: Colors.purple,
      selected: isSelected,
    );
  }
}
