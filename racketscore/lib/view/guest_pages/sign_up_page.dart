import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racketscore/view/guest_pages/sign_in_page.dart';
import '../../config/strings.dart';
import '../../data/appwrite_service.dart';
import '../../presentation/utils.dart';
import '../base_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends BasePageState<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * (isDesktop ? 0.4 : 0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: Strings.email,
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: Strings.password,
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _password2Controller,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: Strings.repeatPassword,
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    final AppwriteService appwrite =
                        context.read<AppwriteService>();
                    if (!Utils.validateEmail(_emailController.text)) {
                      showSnackBar(Strings.emailNotValid, context);
                    } else if (_passwordController.text.length < 8) {
                      showSnackBar(Strings.passwordToShort, context);
                    } else if (_passwordController.text !=
                        _password2Controller.text) {
                      showSnackBar(Strings.passwordsNotEqual, context);
                    } else {
                      await appwrite.createUser(
                          email: _emailController.text,
                          password: _passwordController.text);
                      showSnackBar(Strings.userRegistered, context);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => SignInPage()));
                    }
                  },
                  child: Text(Strings.signUp),
                ),
              ],
            ),
          ),
        ));
  }
}
