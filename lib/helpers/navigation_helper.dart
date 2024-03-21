import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:nymble_music/utils/extensions.dart';

enum Transitions {
  horizontal,
  vertical,
  scaled,
}

extension on Transitions {
  SharedAxisTransitionType get getTransition {
    if (this == Transitions.scaled) return SharedAxisTransitionType.scaled;
    if (this == Transitions.horizontal) return SharedAxisTransitionType.horizontal;
    return SharedAxisTransitionType.vertical;
  }
}

class NavigationHelper {
  static Future<dynamic> to(
    BuildContext context, {
    required Widget page,
    Transitions? transition,
    Duration? duration,
  }) async {
    final result = await Navigator.push(
      context,
      SharedAxisPageRoute(
        page: page,
        transitionType: transition?.getTransition,
        duration: duration,
      ),
    );
    return result;
  }

  static back(BuildContext context, {dynamic result}) async {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    }
  }

  static clearStackAndReplace(
    BuildContext context, {
    required Widget page,
    Transitions? transition,
    Duration? duration,
  }) {
    Navigator.pushAndRemoveUntil(
      context,
      SharedAxisPageRoute(
        page: page,
        transitionType: transition?.getTransition,
        duration: duration,
      ),
      (route) => false,
    );
  }

  static replace(
    BuildContext context, {
    required Widget page,
    Transitions? transition,
    Duration? duration,
  }) {
    Navigator.pushReplacement(
      context,
      SharedAxisPageRoute(
        page: page,
        transitionType: transition?.getTransition,
        duration: duration,
      ),
    );
  }
}

class SharedAxisPageRoute extends PageRouteBuilder {
  SharedAxisPageRoute({
    required Widget page,
    SharedAxisTransitionType? transitionType,
    Duration? duration,
  }) : super(
          transitionDuration: duration ?? 700.milliseconds,
          reverseTransitionDuration: duration ?? 700.milliseconds,
          pageBuilder: (
            BuildContext context,
            Animation<double> primaryAnimation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> primaryAnimation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: transitionType ?? SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
}
