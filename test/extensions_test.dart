import 'package:flutter_test/flutter_test.dart';
import 'package:nymble_music/utils/extensions.dart';

void main() {
  group("Duration Extensions", () {
    test('Durations.milliseconds returns correct Duration', () {
      const milliseconds = 500;
      expect(milliseconds.milliseconds, equals(const Duration(milliseconds: milliseconds)));
    });

    test('Durations.seconds returns correct Duration', () {
      const seconds = 10;
      expect(seconds.seconds, equals(const Duration(seconds: seconds)));
    });

    test('Durations.minutes returns correct Duration', () {
      const minutes = 2;
      expect(minutes.minutes, equals(const Duration(minutes: minutes)));
    });

    test('Durations.toChildAvatarUrl returns correct URL', () {
      const index = 3;
      expect(index.toChildAvatarUrl, equals("assets/images/bots/3.png"));
    });
  });

  group("String Extensions", () {
    test('StringUtils.isValidEmail returns true for valid emails', () {
      expect('johndoe@example.com'.isValidEmail, isTrue);
      expect('jane.smith@gmail.co.uk'.isValidEmail, isTrue);
    });

    test('StringUtils.isValidEmail returns false for invalid emails', () {
      expect('invalid-email'.isValidEmail, isFalse);
      expect('user@example'.isValidEmail, isFalse);
      expect('john+doe@test.com'.isValidEmail, isTrue);
    });
  });
}
