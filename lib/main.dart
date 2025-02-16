import 'package:flutter/material.dart';
import 'package:hair_app/component/calendar.dart';
import 'package:hair_app/component/login.dart';
import 'package:hair_app/component/formation.dart';
import 'package:hair_app/model/event.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('ja').then((_) => runApp(
        ProviderScope(
          child: MyApp(),
        ),
      ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const Calendar(),
      ),
      GoRoute(
        path: '/formation',
        builder: (context, state) {
          // state.extra に Event 型のデータが渡される前提
          final event = state.extra as Event;
          return Formation(
            matchDate: event.dateTime.toIso8601String(),
            opponent: event.opponent,
          );
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
