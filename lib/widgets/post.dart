import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_profil/main.dart';

import 'package:project_profil/pages/comments.dart';
import 'package:project_profil/welcome/Login/components/body.dart';
import 'package:project_profil/widget/custom_image.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  const Post(
      {required this.postId,
      required this.ownerId,
      required this.username,
      required this.location,
      required this.description,
      required this.mediaUrl,
      this.likes});

  factory Post.formDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
    );
  }
  int getLikeCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });

    return count;
  }

  @override
  _PostState createState() => _PostState(
        description: this.description,
        likeCount: this.getLikeCount(this.likes),
        //  likeCount: 0,
        likes: this.likes,
        location: this.location,
        ownerId: this.ownerId,
        mediaUrl: this.mediaUrl,
        username: this.username,
        postId: this.postId,
      );
}

class _PostState extends State<Post> {
  CollectionReference postRef = FirebaseFirestore.instance.collection('posts');
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  bool showHeart = false;
  late bool isLiked;
  int likeCount;
  Map likes;

  _PostState({
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.location,
    required this.description,
    required this.mediaUrl,
    required this.likes,
    required this.likeCount,
  });

  buildPostHeader() {
    print(" footerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
    return FutureBuilder<DocumentSnapshot>(
        //FirebaseFirestore.instance.collection('users').snapshots();
        future: FirebaseFirestore.instance
            .collection('users')
            .doc("oH5KmesriWP1MAhwef6P")
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // lazimni na3ja3 nchoufha circularProgress() in video
            return CircularProgressIndicator();
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          print("je suisssssssssssssss la ");
          print(data);

          // User user = User.fromJson(data);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(data['photo']),
            ),
            title: GestureDetector(
              onTap: () => print('showing profile'),
              child: Text(
                data['nom'] ??= "",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Text(location),
            trailing: IconButton(
              onPressed: () => print('deleting profile'),
              icon: Icon(Icons.more_vert),
            ),
          );
        });
  }

  handleLikePost() {
    // lazimha titbadi beli ya3tihalik il loginnnnnnn
    bool _isLiked = likes[currentId] == true;

    if (_isLiked) {
      postRef
          .doc('NIwYEexI1q4bF6brvQqr')
          .collection('users')
          .doc(postId)
          .update({'likes.$currentId': false});
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentId] = false;
      });
    } else if (!_isLiked) {
      postRef
          .doc('NIwYEexI1q4bF6brvQqr')
          .collection('users')
          .doc(postId)
          .update({'likes.$currentId': true});

      addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  addLikeToActivityFeed() {
    activityFeedRef.doc(ownerId).collection("feedItems").doc(postId).set({
      "type": "like",
      "username": currentUser['nom'],
      "userId": currentId,
      "userProfileImg": currentUser['photo'],
      "postId": postId,
      "mediaUrl": mediaUrl,
      "timestamp": timestamp,
      "commentData": "null"
    });
  }

  removeLikeFromActivityFeed() {
    bool isNotPostOwner = currentId != ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .doc(ownerId)
          .collection("feedItems")
          .doc(postId)
          .get()
          .then((doc) => {
                if (doc.exists) {doc.reference.delete()}
              });
    }
  }

  buildPostImage() {
    print(mediaUrl);
    return GestureDetector(
      onDoubleTap: handleLikePost,
      child: Stack(alignment: Alignment.center, children: <Widget>[
        //verificationnnn
        //Image.network(mediaUrl)

        cachedNetworkImage(mediaUrl),
        showHeart
            ? Icon(
                Icons.favorite,
                size: 80.0,
                color: Colors.red,
              )
            : Text("")
      ]),
    );
  }

  buildPostFooter() {
    print(" footerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
    return Column(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
          GestureDetector(
            onTap: handleLikePost,
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              size: 28.0,
              color: Colors.pink,
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 20.0)),
          GestureDetector(
            onTap: () => showComments(
              context,
              postId: postId,
              ownerId: ownerId,
              mediaUrl: mediaUrl,
            ),
            child: Icon(
              Icons.chat,
              size: 28.0,
              color: Colors.blue[900],
            ),
          ),
        ]),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$likeCount likes",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$username",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Text("  " + description))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentId] == true);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter(),
      ],
    );
  }
}

showComments(BuildContext context,
    {required String postId,
    required String ownerId,
    required String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(
        postId: postId, postOwnerId: ownerId, postMedialUrl: mediaUrl);
  }));
}
