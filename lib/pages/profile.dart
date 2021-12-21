import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_profil/main.dart';
import 'package:project_profil/welcome/Login/components/body.dart';
import 'package:project_profil/widget/post_tile.dart';
import 'package:project_profil/widgets/post.dart';

class Profil extends StatefulWidget {
  final String profileId;

  Profil({required this.profileId});
  static String routeName = "/profile";

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  bool isFollowing = false;
  String postOrientation = "grid";
  bool _isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    getProfilePosts();
    getFollowers();
    getFollowing();
    chekIfFollowing();
  }

  chekIfFollowing() async {
    DocumentSnapshot doc = await followerRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentId)
        .get();

    setState(() {
      print("doc.existsdoc.existsdoc.existsdoc.existsdoc.exists");
      print(doc.exists);
      isFollowing = doc.exists;
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followerRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .get();

    setState(() {
      followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(widget.profileId)
        .collection('userFollowing')
        .get();

    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

  getProfilePosts() async {
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc('NIwYEexI1q4bF6brvQqr')
        .collection('users')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      _isLoading = false;
      //snapshot.documents.length;

      postCount = snapshot.docs.length;
      print(postCount);
      posts = snapshot.docs.map((doc) => Post.formDocument(doc)).toList();
      print("snapshot.docs");
      print(posts[0].mediaUrl);
    });
  }

  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  buildProfileButton() {
    if (isFollowing) {
      return handleUnfollowUser();
    } else if (!isFollowing) {
      return handleFollowUser();
    }
  }

  handleUnfollowUser() {
    // isFollowing = false;

    //Make autg user
    followerRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //Put that user (update your following collection)
    followingRef
        .doc(currentId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //add activity feed item for that
    activityFeedRef
        .doc(widget.profileId)
        .collection('feedItems')
        .doc(currentId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollowUser() {
    //isFollowing = true;

    //Make autg user
    followerRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentId)
        .set({});
    //Put that user (update your following collection)
    followingRef
        .doc(currentId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({});
    //add activity feed item for that
    activityFeedRef
        .doc(widget.profileId)
        .collection('feedItems')
        .doc(currentId)
        .set({
      "type": "follow",
      "cownerId": widget.profileId,
      "username": currentUser['nom'],
      "userId": currentId,
      "userProfileImg": currentUser['photo'],
      "timestamp": timestamp,
      "postId": "null",
      "mediaUrl": "null",
      "commentData": "null"
    });
    //  chekIfFollowing();
  }

  builderProfilePosts() {
    if (_isLoading) {
      return CircularProgressIndicator();
    } else if (postOrientation == "grid") {
      List<GridTile> gridTiles = [];
      posts.forEach((post) {
        print("post");
        print(post);
        gridTiles.add(GridTile(
          child: PostTile(post),
        ));
      });

      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    } else if (postOrientation == "list") {
      return Column(
        children: posts,
      );
    }
  }

  setPostOrientation(String postOrientation) {
    setState(() {
      this.postOrientation = postOrientation;
    });
  }

  buildTogglePostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
            color: postOrientation == 'grid'
                ? Theme.of(context).primaryColor
                : Colors.grey,
            onPressed: () => setPostOrientation("grid"),
            icon: Icon(Icons.grid_on)),
        IconButton(
            color: postOrientation == 'list'
                ? Theme.of(context).primaryColor
                : Colors.grey,
            onPressed: () => setPostOrientation("list"),
            icon: Icon(Icons.list))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        "widget.profileIdwidget.profileIdwidget.profileIdwidget.profileIdwidget.profileId");
    print(widget.profileId);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.profileId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          // get data from base de donne
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          print("11111111111111111111111111");
          print(data);

          return Scaffold(
              body: Stack(
            children: <Widget>[
              SizedBox.expand(
                child: Image.network(
                  data['photoCov'],
                  fit: BoxFit.cover,
                ),
              ),
              DraggableScrollableSheet(
                builder: (context, scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //for user profile header
                          Container(
                            padding:
                                EdgeInsets.only(left: 32, right: 32, top: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: ClipOval(
                                      child: Image.network(
                                        data['photo'],
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        data['nom'] ??= "",
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontFamily: "Roboto",
                                            fontSize: 36,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        data['profession'] ??= "",
                                        style: TextStyle(
                                            color: Colors.grey[500],
                                            fontFamily: "Roboto",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: buildProfileButton(),
                                  child: Icon(
                                    isFollowing
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => {
                                    /*Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MessageScreen(
                                         admin: "admin",
                                         avatar: "avatar",
                                         date: "date",
                                         name: "rayen",
                                         name_client: "name_client",
                                         client: "client",
                                      );
                                    }))*/
                                  },
                                  child: Icon(
                                    Icons.sms,
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //performace bar

                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: EdgeInsets.all(32),
                            color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.check_box,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          followingCount.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Roboto",
                                              fontSize: 24),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "following",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Roboto",
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          followerCount.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Roboto",
                                              fontSize: 24),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "followers",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Roboto",
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          postCount.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Roboto",
                                              fontSize: 24),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "Posts",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Roboto",
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 16,
                          ),
                          //container for about me

                          Container(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "About Me",
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Roboto",
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  data['description'] ??= "",
                                  style: TextStyle(
                                      fontFamily: "Roboto", fontSize: 15),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 16,
                          ),
                          //Container for clients

                          Container(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Column(
                              children: <Widget>[
                                /*   Text(
                                  "Clients",
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Roboto",
                                      fontSize: 18),
                                ),

                                SizedBox(
                                  height: 8,
                                ),*/
                                //for list of clients
                                /*    Container(
                                  width: MediaQuery.of(context).size.width - 64,
                                  height: 80,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        margin: EdgeInsets.only(right: 8),
                                        child: ClipOval(
                                          child: Image.asset(
                                            "assets/images/avatar.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: 5,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                  ),
                                )
                              ],
                            ),
                          ),*/

                                SizedBox(
                                  height: 16,
                                ),

                                //Container for reviews

                                /*  Container(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Reviews",
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 18,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w700),
                                ),*/
                                /* Container(
                                  width: MediaQuery.of(context).size.width - 64,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                     return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("Client $index",
                                                  style: TextStyle(
                                                      color: Colors.lightBlue,
                                                      fontSize: 18,
                                                      fontFamily: "Roboto",
                                                      fontWeight:
                                                          FontWeight.w700)),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.orangeAccent,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.orangeAccent,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.orangeAccent,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                              "He is very fast and good at his work",
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 14,
                                                  fontFamily: "Roboto",
                                                  fontWeight: FontWeight.w400)),
                                          SizedBox(
                                            height: 16,
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: 8,
                                    shrinkWrap: true,
                                    controller: ScrollController(
                                        keepScrollOffset: false),
                                  ),
                                )*/
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // children: <Widget>[buildProfileButton()],
                          ),
                          Divider(height: 0.0),
                          buildTogglePostOrientation(),
                          Divider(height: 0.0),
                          builderProfilePosts()
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ));
        });
  }
}
