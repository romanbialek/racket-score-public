import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:racketscore/presentation/utils.dart';
import 'package:racketscore/view/admin_pages/events_list_page.dart';
import 'package:provider/provider.dart';
import 'package:racketscore/view/guest_pages/result_page.dart';
import 'package:racketscore/view/guest_pages/welcome_page.dart';
import 'config/strings.dart';
import 'data/appwrite_service.dart';

String? eventParameter;

void main() async {
  eventParameter = Uri.base.queryParameters["event"];
  WidgetsFlutterBinding.ensureInitialized();

  //uncomment to test result_page.dart
  //if (!kReleaseMode) {
  //  eventParameter = "SOME_MATCH_ID";
  //}

  runApp(ChangeNotifierProvider(
      create: ((context) => AppwriteService()), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: DesktopScrollBehavior(),
      title: Strings.appTitle,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        secondaryHeaderColor: Colors.teal,
      ),
      initialRoute: eventParameter != null ? '/?event=$eventParameter' : "/",
      onGenerateRoute: (settings) {
        if (eventParameter != null) {
          return MaterialPageRoute(
              builder: (_) => ResultPage(matchId: eventParameter!),
              settings: settings);
        }
        return MaterialPageRoute(
            builder: (_) => const AuthenticationWrapper(),
            settings: settings); // you can do this in `onUnknownRoute` too
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<AppwriteService>().status;
    Widget widget = value == AuthStatus.uninitialized
        ? const Center(child: CircularProgressIndicator())
        : (value == AuthStatus.authenticated
            ? const EventsListPage()
            : const WelcomePage());
    return widget;
  }
}
