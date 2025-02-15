import 'package:flutter/material.dart';
import 'package:hair_app/calendar.dart';
import 'package:hair_app/login.dart';
import 'package:hair_app/formation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart'; // 追加: 日本語ローカライズ対応

void main() {
  initializeDateFormatting('ja').then((_) => runApp(
    ProviderScope( // 修正: `ProviderScope` を正しく適用
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = GoRouter(
    initialLocation: '/formation',
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
        builder: (context, state) => const Formation(),
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
