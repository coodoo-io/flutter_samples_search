import 'package:flutter/material.dart';
import 'package:samples/sample.dart';
import 'package:samples/src/features/samples/presentation/widgets/sample_row.dart';

class SampleLists extends StatelessWidget {
  const SampleLists({
    Key? key,
    required this.samples,
    required this.maxWidth,
  }) : super(key: key);

  final List<Sample> samples;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return samples.isNotEmpty
        ? Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: samples.length,
              primary: false,
              itemBuilder: (context, index) {
                final sample = samples[index];
                return Align(
                  child: SizedBox(
                    width: maxWidth,
                    child: SampleRow(
                      sample: sample,
                    ),
                  ),
                );
              },
            ),
          )
        : const Padding(padding: EdgeInsets.only(top: 10), child: Center(child: Text('No results.')));
  }
}
