import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:nymble_music/presentation/components/input_field.dart";

// Widget Tests

void main() {
  testWidgets('InputField builds with hintText', (WidgetTester tester) async {
    const hintText = "Enter your username";

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InputField(
            hint: hintText,
            controller: TextEditingController(),
          ),
        ),
      ),
    );

    expect(find.widgetWithText(TextField, hintText), findsOneWidget);
  });
  testWidgets('InputField allows text input', (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InputField(
            controller: controller,
            hint: "Enter your name",
          ),
        ),
      ),
    );

    await tester.enterText(find.widgetWithText(TextField, ""), "John Doe");

    expect(controller.text, equals("John Doe"));
  });

  testWidgets('InputField enforces maxLength', (WidgetTester tester) async {
    const maxLength = 10;
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InputField(
            maxLength: maxLength,
            hint: "Enter a short message",
            controller: controller,
          ),
        ),
      ),
    );

    const testText = "This is a long message with >$maxLength characters.";

    await tester.enterText(find.widgetWithText(TextField, ""), testText);

    expect(controller.text, hasLength(maxLength));
    expect(controller.text, equals(testText.substring(0, maxLength)));
  });
}
