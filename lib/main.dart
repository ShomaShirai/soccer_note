import 'package:flutter/material.dart';
import 'package:hair_app/calendar.dart';
import 'package:hair_app/login.dart';
import 'package:hair_app/memo.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart'; // 追加: 日本語ローカライズ対応

void main() {
  initializeDateFormatting('ja').then((_) => runApp(MyApp())); //上の記述をこちらに変更します
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = GoRouter(
    initialLocation: '/calendar',
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
        path: '/memo',
        builder: (context, state) => const PageC(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
