import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_profil/Custom_Botton_Nav_Bar.dart';
import 'package:project_profil/ProfilPic.dart';
import 'package:project_profil/enums.dart';
import 'package:project_profil/pages/activity_feed.dart';
import 'package:project_profil/pages/edit_profile_page.dart';
import 'package:project_profil/pages/profile.dart';
import 'package:project_profil/pages/timeline.dart';
import 'package:project_profil/profile_menu.dart';
import 'package:project_profil/welcome/welcome_screen.dart';
import 'package:project_profil/widgets/post.dart';

class Body extends StatefulWidget {
  final String currentId;
  const Body({Key? key, required this.currentId}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    print('ddddddddddddddddddddddddddddddd');
    print(widget.currentId);
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        bottomNavigationBar: CustomBottonNavBar(
            selectedMenu: MenuState.profile, currentId: widget.currentId),
        body: Column(
          children: [
            ProfilePic(currentId: widget.currentId),
            SizedBox(
              height: 20,
            ),
            profile_menu(
              icon: "assets/icons/User Icon.svg",
              text: "MyAccount",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profil(
                        profileId: widget.currentId,
                      ),
                    ));
              },
            ),
            profile_menu(
              icon: "assets/icons/Bell.svg",
              text: "Notifications",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityFeed(),
                      /*  builder: (context) => Post(
                        description: '',
                        location: '',
                        mediaUrl: '',
                        ownerId: '',
                        postId: '',
                        username: '',
                      ),*/
                    ));
              },
            ),
            profile_menu(
              icon: "assets/icons/Settings.svg",
              text: "Settings",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditProfilePage(currentId: widget.currentId)));
              },
            ),
            profile_menu(
              icon: "assets/icons/Question mark.svg",
              text: "Amie",
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Timeline()));
              },
            ),
            profile_menu(
              icon: "assets/icons/Log out.svg",
              text: "Log Out",
              press: () async {
                try {
                  final reslt = await _auth.signOut();
                  print("ggggggggggggggggggggggggggg");

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                } catch (exception) {
                  print("fffffffffffffffffggggggg");
                  print(exception.toString());
                  return null;
                }
              },
            ),
          ],
        ));
  }
}
