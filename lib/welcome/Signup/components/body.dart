import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, UserCredential;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_profil/welcome/Signup/components/background.dart';
import 'package:project_profil/welcome/already_have_an_account_acheck.dart';
import 'package:project_profil/welcome/rounded_button.dart';
import 'package:project_profil/welcome/rounded_input_field.dart';
import 'package:project_profil/welcome/rounded_password_field.dart';
import 'package:project_profil/welcome/welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _email, _password;

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
            RoundedPasswordField(onChanged: (value) {
              setState(() {
                _password = value.trim();
              });
            }),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              RoundedButton(
                text: "Signup",
                press: () async {
                  UserCredential reslt =
                      await auth.createUserWithEmailAndPassword(
                          email: _email, password: _password);
                  print("reslt.userreslt.userreslt.userreslt.userreslt.user");
                  print(reslt);
                  print("11111111111111111111111111111111111111111111");
                  //  print(reslt.user);

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
              )
            ]),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
