import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:project_profil/home.dart';
import 'package:project_profil/main.dart';
import 'package:project_profil/welcome/Login/components/background.dart';
import 'package:project_profil/welcome/Signup/signup_screen.dart';
import 'package:project_profil/welcome/already_have_an_account_acheck.dart';
import 'package:project_profil/welcome/rounded_button.dart';
import 'package:project_profil/welcome/rounded_input_field.dart';
import 'package:project_profil/welcome/rounded_password_field.dart';
import 'package:project_profil/welcome/welcome_screen.dart';

String currentId = '';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  final auth = FirebaseAuth.instance;
  var _password, _email;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "LOGIN",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          SvgPicture.asset(
            "assets/icons/login.svg",
            height: size.height * 0.35,
          ),
          SizedBox(height: size.height * 0.03),
          RoundedInputField(
            hintText: "Your Email",
            onChanged: (value) {
              setState(() {
                _email = value.trim();
              });
            },
          ),
          RoundedPasswordField(
            onChanged: (value) {
              setState(() {
                _password = value.trim();
              });
            },
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            RoundedButton(
                text: "LOGIN",
                press: () async {
                  print("_email_email_email_email");
                  print(_email);
                  print(_password);
                  UserCredential reslt = await auth.signInWithEmailAndPassword(
                      email: _email, password: _password);
                  print("reslt.userreslt.userreslt.userreslt.userreslt.user");
                  print(reslt);
                  print(reslt.user);
                  currentId = reslt.user!.uid;
                  print("je suis laaaaaaaaaaaaaaaaaaaaaaaa");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return home(currentId: reslt.user!.uid);
                      },
                    ),
                  );
                }),
          ]),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    ));
  }
}
