import 'package:flutter/material.dart';

class LibraryChips extends StatelessWidget {
  const LibraryChips({
    Key? key,
    required this.libraries,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  final List<String> libraries;
  final List<bool> selected;
  final Function(int index, bool value) onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      spacing: 8,
      children: [
        for (int i = 0; i < libraries.length; i++)
          ChoiceChip(
            label: Text(
              libraries[i],
              style: TextStyle(color: selected[i] ? Colors.white : Colors.black, fontSize: 12),
            ),
            onSelected: (value) => onSelected(i, value),
            selectedColor: Colors.purple,
            selected: selected[i],
          ),
      ],
    );
  }
}
