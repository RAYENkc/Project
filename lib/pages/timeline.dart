import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_profil/Custom_Botton_Nav_Bar.dart';
import 'package:project_profil/constants.dart';
import 'package:project_profil/enums.dart';
import 'package:project_profil/main.dart';
import 'package:project_profil/model/users.dart';
import 'package:project_profil/pages/search.dart';
import 'package:project_profil/welcome/Login/components/body.dart';
import 'package:project_profil/widgets/header.dart';
import 'package:project_profil/widgets/post.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<dynamic> users = [];
  List<Post> posts = [];
  List<String> followingList = [];

  @override
  void initState() {
    // getUserById();
    // getUsers();
    //createUser();
    getTimeline();
    getFollowing();
    super.initState();
  }

  getTimeline() async {
    /*
    QuerySnapshot snapshot = await postsRef
        .doc(currentId)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .get();
    */
    print(currentId.replaceAll(" ", ""));
    QuerySnapshot snapshot = await postsRef
        .doc('NIwYEexI1q4bF6brvQqr')
        .collection('users')
        .orderBy('timestamp', descending: true)
        .get();
    print("11111111111111111111111");
    print(snapshot.docs.length);
    snapshot.docs.map((e) => print(e.data()));

    List<Post> posts =
        snapshot.docs.map((doc) => Post.formDocument(doc)).toList();

    setState(() {
      this.posts = posts;
    });
  }

  getUsers() async {
    //.where("role", isEqualTo: "utilisateur")
    final QuerySnapshot snapshot = await usersRef.get();

    setState(() {
      users = snapshot.docs;
    });

    //  usersRef.get().then((QuerySnapshot snapshot) {
    // snapshot.docs.forEach((doc) {
    //  print("doc.data");
    //  print("ssssssssssssssssssssss");
    //  print(doc.data());
    //});
    //  }
    // );
  }

  getUserById() async {
    final String id = "oH5KmesriWP1MAhwef6P";
    final DocumentSnapshot doc = await usersRef.doc(id).get();
    //   .then((DocumentSnapshot doc) => {
    print(doc.data());
    //  }
    //);
  }

  createUser() async {
    await usersRef.add({
      "nom": "test",
      "prenom": "test",
      "age": 40,
      "profession": "TESTEUR",
      "role": "admin",
      "niveaux": "good",
      "email": "test@gmail.com",
      "tel": "90304043",
      "description": "je suis un test",
      "photo": "",
      "photoCov": ""
    });
  }

  buildTimeline() {
    if (posts == null) {
      return CircularProgressIndicator();
    } else if (posts.isEmpty) {
      // return buidUsersToFollow();
    } else {
      return ListView(
        children: posts,
      );
    }
  }

  getFollowing() async {
    QuerySnapshot snapshot =
        await followingRef.doc(currentId).collection('userFollowing').get();

    setState(() {
      followingList = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  buidUsersToFollow() {
    return StreamBuilder(
        stream: usersRef
            .orderBy('timestamp', descending: true)
            .limit(30)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasError) {
            return CircularProgressIndicator();
          }
          List<UserResult> userResults = [];

          (snapshot.data! as QuerySnapshot).docs.forEach((doc) {
            print("TESTTTT11111111111111");
            print(doc);
            User user = User.fromJson(doc);
            print("TESTTTT2222222222");
            print(user);
            final bool isAuthUser = currentId == user.id;
            final bool isFollowingUser = followingList.contains(user.id);
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
            //remove auth user form recommended list
            if (isAuthUser) {
              return;
            } else if (isFollowingUser) {
              return;
            } else {
              UserResult userResult = UserResult(user);
              userResults.add(userResult);
            }
          });
          return Container(
            // color: Theme.of(context).accentColor.withOpacity(0.2),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add,
                          color: Theme.of(context).primaryColor, size: 30.0),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        "Users to Follow",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: userResults,
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Hand Me',
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 37.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.2),
        ),
      ),
      /* bottomNavigationBar: CustomBottonNavBar(
          selectedMenu: MenuState.home, currentId: currentId),*/
      body: RefreshIndicator(
          child: buildTimeline(), onRefresh: () => getTimeline()),
    );
  }
}


        /* body: Container(
    child: ListView(
        children: users.map((user) => Text(user['nom'])).toList(),
      ),
    )*/

        /*      body: FutureBuilder<QuerySnapshot>(
      future: usersRef.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final List<Text> children =
            users.map((doc) => Text(doc['nom'])).toList();
        return Container(
          child: ListView(
            children: children,
          ),
        );
      },
    )*/

        /* body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final List<Text> children =
              users.map((doc) => Text(doc['nom'])).toList();
          return Container(
            child: ListView(
              children: children,
            ),
          );
        },
      ),*/