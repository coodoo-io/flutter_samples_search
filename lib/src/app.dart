import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samples/src/core/config/app_lifecycle.event_handler.dart';
import 'package:samples/src/router.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late WidgetsBindingObserver lifecycleEventHandler;

  @override
  void initState() {
    super.initState();

    ///To listen onResume method
    lifecycleEventHandler = AppLifecycleEventHandler();
    WidgetsBinding.instance.addObserver(lifecycleEventHandler);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
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
      routerConfig: router,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(lifecycleEventHandler);
    super.dispose();
  }
}
