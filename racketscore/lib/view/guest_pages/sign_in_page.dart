import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racketscore/view/guest_pages/sign_up_page.dart';
import '../../config/strings.dart';
import '../../data/appwrite_service.dart';
import '../base_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends BasePageState<SignInPage> {
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Container(
          width:  MediaQuery.of(context).size.width * (isDesktop ? 0.4: 0.7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: Strings.email,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: Strings.password,
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text;
                  String password = _passwordController.text;

                  try {
                    final AppwriteService appwrite =
                        context.read<AppwriteService>();
                    await appwrite.createEmailSession(
                      email: email,
                      password: password,
                    );
                    Navigator.pop(context);
                  } on AppwriteException catch (e) {
                    Navigator.pop(context);
                    showSnackBar(e.message.toString(), context);
                  }
                },
                child: const Text(Strings.signIn),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SignUpPage()));
                },
                child: const Text(
                  Strings.dontHaveAccount,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
