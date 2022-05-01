import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:samples/sample.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
      theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.grey[50]),
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
      final filteredList = sampleList.where((s) => s.element.toLowerCase().startsWith(searchTerm) || s.id.toLowerCase().startsWith(searchTerm)).toList();
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
            children: [
              Text('Flutter Samples', style: widget.theme.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: TextField(
                  onChanged: (value) {
                    searchData(value.trim().toLowerCase());
                  },
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Search by title or id",
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              if (searchList.isNotEmpty)
                Expanded(
                  child: SizedBox(
                    width: 800,
                    child: ListView.builder(
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
    String sampleProjectName = sampleId.replaceAll('.', '_').toLowerCase();
    String createFlutterSampleCmd = 'flutter create --sample=$sampleId $sampleProjectName';

    final theme = Theme.of(context);
    return Material(
      elevation: 1,
      child: Column(
        children: [
          Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    SelectableText(sample.element, style: theme.textTheme.subtitle2?.copyWith(fontWeight: FontWeight.bold)),
                    Chip(
                      labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      backgroundColor: Colors.transparent,
                      shape: const StadiumBorder(side: BorderSide(color: Colors.white)),
                      avatar: Text("Type",
                          style: theme.textTheme.caption?.copyWith(
                            fontSize: 11,
                          )),
                      label: Text(sample.sampleLibrary, style: theme.textTheme.caption?.copyWith(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    Chip(
                      labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      backgroundColor: Colors.transparent,
                      shape: const StadiumBorder(side: BorderSide(color: Colors.white)),
                      avatar: Text("ID",
                          style: theme.textTheme.caption?.copyWith(
                            fontSize: 11,
                          )),
                      label: SelectableText(
                        sample.id,
                        toolbarOptions: const ToolbarOptions(copy: true, selectAll: true, cut: false, paste: false),
                        style: theme.textTheme.caption?.copyWith(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      deleteIcon: const Icon(
                        Icons.copy,
                        size: 12,
                      ),
                      deleteButtonTooltipMessage: 'Copy ID to clipboard',
                      onDeleted: () {
                        Clipboard.setData(ClipboardData(text: sample.id)).then((_) {
                          rootScaffoldMessengerKey.currentState!.removeCurrentSnackBar();
                          rootScaffoldMessengerKey.currentState!.showSnackBar(SnackBar(content: Text("Sample ID copied to clipboard: $sampleId")));
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: SelectableText(sample.description, style: theme.textTheme.caption)),
                    Container(
                      width: 190.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: Image.asset('assets/screenshots/${sample.id}.png').image,
                        ),
                      ),
                    ),
                  ],
                ),
                
              ])),

                Container(
                  color: Colors.grey.shade100,
                  padding: const EdgeInsets.only(left:20, right:20, bottom:10, top:10),
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: createFlutterSampleCmd)).then((_) {
                            rootScaffoldMessengerKey.currentState!.removeCurrentSnackBar();
                            rootScaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(content: Text("Flutter create sample command copied.")));
                          });
                    },
                    child: Row(
                      children: [
                          const Icon(Icons.copy, size: 12,),
                          const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            createFlutterSampleCmd,
                            style: GoogleFonts.courierPrime(
                              textStyle: const TextStyle(letterSpacing: .5, fontSize: 11),
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
