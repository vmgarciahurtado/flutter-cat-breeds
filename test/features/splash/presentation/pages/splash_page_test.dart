import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'package:catbreeds/core/constants/strings.dart';
import 'package:catbreeds/features/splash/presentation/pages/splash_page.dart';

class FakeLottieAssetBundle extends Fake implements AssetBundle {
  static final _lottieJson = jsonEncode({
    'v': '5.7.4',
    'fr': 30,
    'ip': 0,
    'op': 60,
    'w': 250,
    'h': 250,
    'layers': [],
  });

  @override
  Future<String> loadString(String key, {bool cache = true}) async =>
      _lottieJson;

  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(utf8.encode(_lottieJson)));
}

GoRouter makeRouter() => GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, _) => const SplashPage()),
    GoRoute(
      path: '/breeds',
      builder: (_, _) => const Scaffold(body: Text('BreedsPage')),
    ),
  ],
);

Future<void> pumpSplashPage(WidgetTester tester) async {
  await tester.pumpWidget(
    DefaultAssetBundle(
      bundle: FakeLottieAssetBundle(),
      child: MaterialApp.router(routerConfig: makeRouter()),
    ),
  );
}

void main() {
  group('SplashPage', () {
    testWidgets('should render app name and Lottie animation', (tester) async {
      await pumpSplashPage(tester);
      await tester.pump();

      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.byType(Lottie), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('should render TweenAnimationBuilder', (tester) async {
      await pumpSplashPage(tester);
      await tester.pump();

      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('should navigate to breeds after 3 seconds', (tester) async {
      await pumpSplashPage(tester);
      await tester.pump();

      expect(find.text(AppStrings.appName), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.text('BreedsPage'), findsOneWidget);
    });
  });
}
