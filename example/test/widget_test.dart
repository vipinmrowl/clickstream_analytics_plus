// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:clickstream_analytics_plus_example/main.dart';

// void main() {
//   testWidgets('App shows initialize button and can initialize SDK', (
//     WidgetTester tester,
//   ) async {
//     await tester.pumpWidget(const ClickstreamDemoApp());

//     // Should see the initialize button before SDK is initialized
//     expect(find.text('Initialize SDK'), findsOneWidget);
//     expect(find.textContaining('SDK not initialized'), findsOneWidget);

//     // Tap the initialize button
//     await tester.tap(find.text('Initialize SDK'));
//     await tester.pumpAndSettle();

//     // After initialization, should see SDK Version and success message
//     expect(find.textContaining('Initialized successfully'), findsOneWidget);
//     expect(find.textContaining('SDK Version:'), findsOneWidget);
//   });

//   testWidgets('Events tab shows event buttons after init', (
//     WidgetTester tester,
//   ) async {
//     await tester.pumpWidget(const ClickstreamDemoApp());

//     // Initialize SDK first
//     await tester.tap(find.text('Initialize SDK'));
//     await tester.pumpAndSettle();

//     // Switch to Events tab
//     await tester.tap(find.byIcon(Icons.bar_chart));
//     await tester.pumpAndSettle();

//     // Should see event buttons
//     expect(find.text('Record button_click'), findsOneWidget);
//     expect(find.text('Record screen_view'), findsOneWidget);
//     expect(find.text('Flush Events'), findsOneWidget);
//   });

//   testWidgets('User tab shows user actions after init', (
//     WidgetTester tester,
//   ) async {
//     await tester.pumpWidget(const ClickstreamDemoApp());

//     // Initialize SDK first
//     await tester.tap(find.text('Initialize SDK'));
//     await tester.pumpAndSettle();

//     // Switch to User tab
//     await tester.tap(find.byIcon(Icons.person));
//     await tester.pumpAndSettle();

//     // Should see user action buttons
//     expect(find.text('Set New User ID'), findsOneWidget);
//     expect(find.text('Update User Attributes'), findsOneWidget);
//     expect(find.text('Update Global Attributes'), findsOneWidget);
//   });
// }
