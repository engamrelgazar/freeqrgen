import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freeqrgen/core/di/injection_container.dart';
import 'package:freeqrgen/main.dart';

void main() {
  setUpAll(() async {
    // Initialize dependencies before tests
    await initializeDependencies();
  });

  testWidgets('QR Generator app smoke test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify the app bar is present
    expect(find.text('QR Generator'), findsOneWidget);

    // Verify content type selector is present
    expect(find.text('Select Content Type'), findsOneWidget);

    // Verify at least one content type chip is present (Text)
    expect(find.text('Text'), findsOneWidget);

    // Verify QR preview panel is present
    expect(find.text('QR Code Preview'), findsOneWidget);

    // Verify customization panel is present
    expect(find.text('Customization'), findsOneWidget);
  });

  testWidgets('Theme toggle works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Find the theme toggle button
    final themeToggle = find.byIcon(Icons.dark_mode);
    expect(themeToggle, findsOneWidget);

    // Tap the theme toggle
    await tester.tap(themeToggle);
    await tester.pumpAndSettle();

    // Verify icon changed to light mode icon
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });

  testWidgets('Content type selection works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Find and tap the Email chip
    final emailChip = find.text('Email');
    expect(emailChip, findsOneWidget);

    await tester.tap(emailChip);
    await tester.pumpAndSettle();

    // Verify email form is displayed
    expect(find.text('Enter Email'), findsOneWidget);
  });
}
