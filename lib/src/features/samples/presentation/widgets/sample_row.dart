import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:samples/src/app.dart';
import 'package:samples/sample.dart';

class SampleRow extends StatelessWidget {
  SampleRow({
    Key? key,
    required this.sample,
  }) : super(key: key);

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final Sample sample;

  @override
  Widget build(BuildContext context) {
    var createFlutterSampleCmd =
        'flutter create --sample=${sample.id} ${sample.element.toLowerCase()}${sample.id.substring(sample.id.length - 1)}';
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 3, right: 3),
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(color: Color(0xffefefef), spreadRadius: 0, blurRadius: 5, offset: Offset(1, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    SelectableText(
                      sample.element,
                      style: theme.textTheme.subtitle2?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            sample.sampleLibrary,
                            style: theme.textTheme.caption?.copyWith(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SelectableText(
                        sample.description,
                        style: theme.textTheme.caption?.copyWith(height: 1.5, color: const Color(0xff676767)),
                      ),
                    ),
                    // Container(
                    //   width: 190.0,
                    //   height: 100.0,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.rectangle,
                    //     image: DecorationImage(
                    //       fit: BoxFit.fitHeight,
                    //       image: Image.asset('assets/screenshots/${sample.id}.png').image,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Color(0xffefefef)),
              ),
            ),
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: sample.id)).then((_) async {
                  rootScaffoldMessengerKey.currentState!.removeCurrentSnackBar();
                  rootScaffoldMessengerKey.currentState!
                      .showSnackBar(SnackBar(content: Text('🔗 ${sample.id} copied to your clipboard')));
                  await analytics.logEvent(
                    name: 'copy id',
                    parameters: <String, dynamic>{
                      'sample-id': sample.id,
                    },
                  );
                });
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.copy,
                    size: 13,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      sample.id,
                      style: const TextStyle(
                        fontFamily: 'Courier New',
                        letterSpacing: .5,
                        fontSize: 11,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Color(0xffefefef)),
              ),
            ),
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: createFlutterSampleCmd)).then((_) async {
                  rootScaffoldMessengerKey.currentState!.removeCurrentSnackBar();
                  rootScaffoldMessengerKey.currentState!.showSnackBar(
                    SnackBar(content: Text('👉 Flutter command for `${sample.id}` copied to your clipboard')),
                  );
                  await analytics.logEvent(
                    name: 'copy command',
                    parameters: <String, dynamic>{
                      'sample-id': sample.id,
                    },
                  );
                });
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.copy,
                    size: 13,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      createFlutterSampleCmd,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        letterSpacing: .5,
                        fontSize: 11,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
