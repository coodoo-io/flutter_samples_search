import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samples/src/core/utils/responsive.util.dart';
import 'package:samples/src/features/samples/presentation/providers/library.controller.dart';
import 'package:samples/src/features/samples/presentation/widgets/library_chip.dart';

class LibraryChips extends ConsumerWidget {
  const LibraryChips({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, bool> libraries = ref.watch(libraryControllerProvider);

    if (MediaQuery.of(context).size.width <= ResponsiveUtil.md) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 8),
            for (int i = 0; i < libraries.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: LibraryChip(
                  library: libraries.keys.toList()[i],
                  isSelected: libraries.values.toList()[i],
                  searchController: searchController,
                ),
              ),
          ],
        ),
      );
    }

    return Wrap(
      runSpacing: 8,
      spacing: 8,
      children: [
        for (int i = 0; i < libraries.length; i++)
          LibraryChip(
            library: libraries.keys.toList()[i],
            isSelected: libraries.values.toList()[i],
            searchController: searchController,
          ),
      ],
    );
  }
}
