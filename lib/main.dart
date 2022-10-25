import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:samples/sample.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const App());
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Samples',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.15,
            ),
      ),
      home: HomePage(theme: theme),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Sample> sampleList = [];
  List<Sample> searchList = [];
  Timer? _debounce;
  final double maxWidth = 960.0;

  Future<void> fetchData() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/samples.json");
    final jsonResult = json.decode(data);

    setState(() {
      jsonResult.forEach((json) => sampleList.add(Sample.fromJson(json)));
      searchList = sampleList;
    });
  }

  void searchData(String searchTerm) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final filteredList = sampleList
          .where((s) => s.element.toLowerCase().startsWith(searchTerm) || s.id.toLowerCase().startsWith(searchTerm))
          .toList();
      setState(() {
        searchList = filteredList;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        clipBehavior: Clip.none,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: TextField(
                  onChanged: (value) {
                    searchData(value.trim().toLowerCase());
                  },
                  decoration: const InputDecoration(
                    hintText: "Search for Flutter Samples...",
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      borderSide: BorderSide(color: Color(0xffefefef), width: 2.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (searchList.isNotEmpty)
                Expanded(
                  child: SizedBox(
                    width: maxWidth,
                    child: ListView.builder(
                        clipBehavior: Clip.none,
                        itemCount: searchList.length,
                        itemBuilder: (context, index) {
                          final sample = searchList[index];
                          return SampleRow(sample: sample);
                        }),
                  ),
                )
              else
                const Center(child: Text('No results.'))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

class SampleRow extends StatelessWidget {
  const SampleRow({
    Key? key,
    required this.sample,
  }) : super(key: key);

  final Sample sample;

  @override
  Widget build(BuildContext context) {
    String sampleId = sample.id;
    String createFlutterSampleCmd = 'flutter create --sample=$sampleId app_name';

    final theme = Theme.of(context);
    return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(color: Color(0xffefefef), spreadRadius: 0, blurRadius: 5, offset: Offset(1, 1)),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    SelectableText(sample.element,
                        style: theme.textTheme.subtitle2?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100, borderRadius: const BorderRadius.all(Radius.circular(50))),
                        child: Row(
                          children: [
                            Text(sample.sampleLibrary,
                                style: theme.textTheme.caption?.copyWith(fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        )),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: SelectableText(sample.description.replaceAll("\n", " "),
                            style: theme.textTheme.caption?.copyWith(height: 1.5, color: const Color(0xff676767)))),
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
                Clipboard.setData(ClipboardData(text: sampleId)).then((_) {
                  rootScaffoldMessengerKey.currentState!.removeCurrentSnackBar();
                  rootScaffoldMessengerKey.currentState!
                      .showSnackBar(SnackBar(content: Text("🔗 $sampleId copied to your clipboard")));
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
                      sampleId,
                      style: const TextStyle(
                          fontFamily: "Courier New", letterSpacing: .5, fontSize: 11, color: Colors.purple),
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
                Clipboard.setData(ClipboardData(text: sampleId)).then((_) {
                  rootScaffoldMessengerKey.currentState!.removeCurrentSnackBar();
                  rootScaffoldMessengerKey.currentState!
                      .showSnackBar(SnackBar(content: Text("👉 Flutter command for `$sampleId` copied to your clipboard")));
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
                          fontFamily: "monospace", letterSpacing: .5, fontSize: 11, color: Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]));
  }
}
