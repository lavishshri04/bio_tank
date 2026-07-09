import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:railbio_inspect/main.dart';

void main() {
  testWidgets('App builds the root MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(const RailBioInspectApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('AI Railway Bio-Toilet\nInspection System'), findsOneWidget);
    expect(find.byIcon(Icons.train_rounded), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1800));
  });
}
