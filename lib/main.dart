import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_profil/Custom_Botton_Nav_Bar.dart';
import 'package:project_profil/constants.dart';

import 'package:project_profil/theme.dart';
import 'package:project_profil/welcome/Login/components/body.dart';
import 'package:project_profil/welcome/welcome_screen.dart';

import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
final firebase_storage.FirebaseStorage ref =
    firebase_storage.FirebaseStorage.instance;
final commentsRef = FirebaseFirestore.instance.collection('comments');
final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');
final followerRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final chatsRef = FirebaseFirestore.instance.collection('chats');
//String currentId = 'oH5KmesriWP1MAhwef6P';
final DateTime timestamp = DateTime.now();
var currentUser;
void main() async {
  /* await FirebaseFirestore.instance.settings(timestampsInSnapshotsEnabled: true).then(
      (_) {
    print("timestamps enabled in snaphots \n");
  }, onError: (_) {
    print("Error ");
  });*/
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /* FirebaseFirestore.instance
      .collection('testing')
      .add({'timestamp ': Timestamp.fromDate(DateTime.now())});
  print(FirebaseFirestore.instance.collection('testing').snapshots());
*/
  //getUser();
  runApp(MyApp());
}

getUser() async {
  final DocumentSnapshot doc = await usersRef.doc(currentId).get();
  //   .then((DocumentSnapshot doc) => {
  print("doc.data()doc.data()doc.data()doc.data()doc.data()doc.data()");
  print(doc.data());
  currentUser = doc.data();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      home: PofileScreen(),
    );
  }
}

class PofileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init( BoxConstraints(context, height: 896, width: 414, allowFontScaling: true);
    /*return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        // body: Body(),
        bottomNavigationBar:
            CustomBottonNavBar(selectedMenu: MenuState.profile));*/

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hand Me',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}
