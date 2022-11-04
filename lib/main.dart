import 'dart:convert';
import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:samples/firebase_options.dart';
import 'package:samples/sample.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Samples',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xfff9f9f9),
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: Colors.purple,
            ),
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.15,
            ),
      ),
      home: HomePage(theme: theme, analytics: analytics, observer: observer),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.theme,
    required this.analytics,
    required this.observer,
  }) : super(key: key);

  final ThemeData theme;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  List<Sample> sampleList = [];
  List<Sample> searchList = [];
  int count = 0;
  Timer? _debounce;
  final double maxWidth = 960.0;

  Future<void> fetchData() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/samples.json");
    final jsonResult = json.decode(data);

    setState(() {
      jsonResult.forEach((json) => sampleList.add(Sample.fromJson(json)));
      searchList = sampleList;
      searchList.sort((a, b) => a.element.toLowerCase().compareTo(b.element.toLowerCase()));
      count = searchList.length;
    });
  }

  void searchData(String searchTerm) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final filteredList = sampleList
          .where((s) =>
              s.element.toLowerCase().contains(searchTerm) ||
              s.id.toLowerCase().startsWith(searchTerm) ||
              s.sampleLibrary.toLowerCase().contains(searchTerm) ||
              s.description.toLowerCase().contains(searchTerm))
          .toList();
      await widget.analytics.logEvent(
        name: 'search samples',
        parameters: <String, dynamic>{
          'searchTerm': searchTerm,
        },
      );
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    searchData(value.trim().toLowerCase());
                  },
                  decoration: InputDecoration(
                    hintText: "Search in $count Flutter Samples...",
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
                            onPressed: () {
                              searchController.clear();
                              searchData("");
                              setState(() {});
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              searchList.isNotEmpty
                  ? Flexible(
                      child: ListView.builder(
                          itemCount: searchList.length,
                          primary: false,
                          itemBuilder: (context, index) {
                            final sample = searchList[index];
                            return Align(
                              child: SizedBox(
                                width: maxWidth,
                                child: SampleRow(
                                  sample: sample,
                                  analytics: widget.analytics,
                                  observer: widget.observer,
                                ),
                              ),
                            );
                          }),
                    )
                  : const Center(child: Text('No results.'))
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

class SampleRow extends StatefulWidget {
  const SampleRow({
    Key? key,
    required this.sample,
    required this.analytics,
    required this.observer,
  }) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final Sample sample;

  @override
  State<SampleRow> createState() => _SampleRowState();
}

class _SampleRowState extends State<SampleRow> {
  late final String createFlutterSampleCmd;

  @override
  void initState() {
    createFlutterSampleCmd =
        'flutter create --sample=${widget.sample.id} ${widget.sample.element.toLowerCase()}${widget.sample.id.substring(widget.sample.id.length - 1)}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    SelectableText(widget.sample.element,
                        style: theme.textTheme.subtitle2?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100, borderRadius: const BorderRadius.all(Radius.circular(50))),
                        child: Row(
                          children: [
                            Text(widget.sample.sampleLibrary,
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
                        child: SelectableText(widget.sample.description,
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
              onTap: () async {
                Clipboard.setData(ClipboardData(text: widget.sample.id)).then((_) async {
                  rootScaffoldMessengerKey.currentState!.removeCurrentSnackBar();
                  rootScaffoldMessengerKey.currentState!
                      .showSnackBar(SnackBar(content: Text("🔗 ${widget.sample.id} copied to your clipboard")));
                  await widget.analytics.logEvent(
                    name: 'copy id',
                    parameters: <String, dynamic>{
                      'sample-id': widget.sample.id,
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
                      widget.sample.id,
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
                Clipboard.setData(ClipboardData(text: createFlutterSampleCmd)).then((_) async {
                  rootScaffoldMessengerKey.currentState!.removeCurrentSnackBar();
                  rootScaffoldMessengerKey.currentState!.showSnackBar(
                      SnackBar(content: Text("👉 Flutter command for `${widget.sample.id}` copied to your clipboard")));
                  await widget.analytics.logEvent(
                    name: 'copy command',
                    parameters: <String, dynamic>{
                      'sample-id': widget.sample.id,
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
