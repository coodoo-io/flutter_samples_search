import 'dart:convert';
import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:samples/firebase_options.dart';
import 'package:samples/library_chips.dart';
import 'package:samples/sample.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
      home: HomePage(
        theme: theme,
        analytics: analytics,
        observer: observer,
        searchParam: Uri.base.queryParameters["q"] ?? '',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.theme,
    required this.analytics,
    required this.observer,
    required this.searchParam,
  }) : super(key: key);

  final ThemeData theme;
  final String? searchParam;

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

  List<String> libraries = [
    'material',
    'widgets',
    'cupertino',
    'dart:ui',
    'services',
    'rendering',
    'chip',
    'focus_manager',
    'painting',
    'animation',
    'gestures',
    'scrollbar',
  ];
  List<bool> selectedLibrariesValue = [];

  List<String> selectedLibraries = [];

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
      final libraryList = sampleList
          .where((s) => (selectedLibraries.isEmpty || selectedLibraries.contains(s.sampleLibrary.toLowerCase())))
          .toList();
      final filteredList = libraryList
          .where((s) => ((selectedLibraries.isEmpty || selectedLibraries.contains(s.sampleLibrary.toLowerCase())) &&
                  s.element.toLowerCase().contains(searchTerm.toLowerCase()) ||
              s.id.toLowerCase().startsWith(searchTerm.toLowerCase()) ||
              s.description.toLowerCase().contains(searchTerm.toLowerCase())))
          .toList();
      await widget.analytics.logEvent(
        name: 'search samples',
        parameters: <String, dynamic>{'searchTerm': searchTerm, 'selectedLibraries': selectedLibraries},
      );
      setState(() {
        searchList = filteredList;
      });
    });
  }

  void getQueryParam() {
    if (widget.searchParam != '') {
      searchData(widget.searchParam!);
      setState(() => searchController.text = widget.searchParam!);
    }
  }

  void initLibraryChips() async {
    for (int i = 0; i < libraries.length; i++) {
      selectedLibrariesValue.add(false);
    }
  }

  void setLibrary(int index, bool value) {
    setState(() {
      selectedLibrariesValue[index] = value;
      if (value) {
        selectedLibraries.add(libraries[index]);
      } else {
        selectedLibraries.remove(libraries[index]);
      }
    });
    searchData(searchController.text);
  }

  @override
  void initState() {
    super.initState();
    initLibraryChips();
    fetchData();
    getQueryParam();
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
              const SizedBox(height: 16),
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: LibraryChips(
                  libraries: libraries,
                  selected: selectedLibrariesValue,
                  onSelected: (index, value) => setLibrary(index, value),
                ),
              ),
              const SizedBox(height: 16),
              searchList.isNotEmpty
                  ? Flexible(
                      child: ListView.builder(
                          shrinkWrap: true,
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
                  : const Padding(padding: EdgeInsets.only(top: 10), child: Center(child: Text('No results.'))),
            ],
          ),
        ),
      ),
      bottomSheet: Footer(maxWidth: maxWidth),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

class Footer extends StatelessWidget {
  const Footer({
    Key? key,
    required this.maxWidth,
  }) : super(key: key);

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40.0,
      alignment: Alignment.center,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Text(
                  '@coodoo_io',
                  style: theme.textTheme.caption?.copyWith(fontSize: 11),
                ),
                onTap: () async => await launchUrl(
                  Uri(scheme: 'https', host: 'www.twitter.com', path: 'coodoo_io'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              InkWell(
                child: Text(
                  'Imprint',
                  style: theme.textTheme.caption?.copyWith(fontSize: 11),
                ),
                onTap: () async => await launchUrl(
                  Uri(scheme: 'https', host: 'www.coodoo.de', path: 'impressum'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SampleRow extends StatelessWidget {
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
                        child: SelectableText(sample.description,
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
                Clipboard.setData(ClipboardData(text: sample.id)).then((_) async {
                  rootScaffoldMessengerKey.currentState!.removeCurrentSnackBar();
                  rootScaffoldMessengerKey.currentState!
                      .showSnackBar(SnackBar(content: Text("🔗 ${sample.id} copied to your clipboard")));
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
                      SnackBar(content: Text("👉 Flutter command for `${sample.id}` copied to your clipboard")));
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
