import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Utils {
  static bool validateEmail(String email) {
    // Regular expression pattern for email validation
    // This pattern follows the RFC 5322 standard
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
    );
    return emailRegex.hasMatch(email);
  }

  static ScreenOrientation getScreenOrientation(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Orientation deviceOrientation = mediaQuery.orientation;

    return deviceOrientation == Orientation.portrait
        ? ScreenOrientation.portrait
        : ScreenOrientation.landscape;
  }
}

enum ScreenOrientation {
  portrait,
  landscape,
}

/// allows scrolling on Desktop
class DesktopScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
      };
}
