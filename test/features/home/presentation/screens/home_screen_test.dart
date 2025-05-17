import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_riverpod/features/home/presentation/screens/home_screen.dart';
import 'package:my_riverpod/features/home/presentation/providers/home_notifier.dart';
import 'package:my_riverpod/features/home/data/models/home_model.dart';

class MockHomeNotifier extends Notifier<AsyncValue<List<HomeModel>>>
    with Mock
    implements HomeNotifier {}

void main() {
  late MockHomeNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockHomeNotifier();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        homeNotifierProvider.overrideWith(() => mockNotifier),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  testWidgets('shows loading indicator', (tester) async {
    when(() => mockNotifier.build()).thenReturn(const AsyncLoading());
    when(() => mockNotifier.getHomeData()).thenAnswer((_) async {});

    await tester.pumpWidget(createTestWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message', (tester) async {
    when(() => mockNotifier.build()).thenReturn(
      const AsyncError('Oops', StackTrace.empty),
    );
    when(() => mockNotifier.getHomeData()).thenAnswer((_) async {});

    await tester.pumpWidget(createTestWidget());
    expect(find.textContaining('Oops'), findsOneWidget);
  });

  testWidgets('shows list of items', (tester) async {
    final items = [
      HomeModel(title: 'Item 1', description: 'Description 1'),
      HomeModel(title: 'Item 2', description: 'Description 2'),
    ];

    when(() => mockNotifier.build()).thenReturn(AsyncData(items));
    when(() => mockNotifier.getHomeData()).thenAnswer((_) async {});

    await tester.pumpWidget(createTestWidget());

    for (final item in items) {
      expect(find.text(item.title), findsOneWidget);
      expect(find.text(item.description), findsOneWidget);
    }
  });
}
