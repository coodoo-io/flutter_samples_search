import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:samples/src/core/layouts/app.layout.dart';
import 'package:samples/src/features/samples/presentation/samples.page.dart';

part 'router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Future
@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    debugLogDiagnostics: false,
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: SamplePage(
                theme: Theme.of(context),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
