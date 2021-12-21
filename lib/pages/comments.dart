import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_profil/main.dart';
import 'package:project_profil/welcome/Login/components/body.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMedialUrl;

  Comments(
      {required this.postId,
      required this.postOwnerId,
      required this.postMedialUrl});

  @override
  CommentsState createState() => CommentsState(
      postId: this.postId,
      postOwnerId: this.postOwnerId,
      postMedialUrl: this.postMedialUrl);
}

class CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String postMedialUrl;

  CommentsState(
      {required this.postId,
      required this.postOwnerId,
      required this.postMedialUrl});

  buildComments() {
    return StreamBuilder(
        stream: commentsRef
            .doc(postId)
            .collection('comments')
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          print("snapshot.data");
          print((snapshot.data! as QuerySnapshot).docs[0]);
          print((snapshot.data! as QuerySnapshot).docs.length);
          List<Comment> comments = [];
          (snapshot.data! as QuerySnapshot).docs.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
          });
          return ListView(
            children: comments,
          );
        });
  }

  addComment() {
    commentsRef.doc(postId).collection("comments").add({
      "username": currentUser['nom'],
      "comment": commentController.text,
      "timestamp": timestamp,
      "avatarUrl": currentUser['photo'],
      "userId": currentId
    });
    //bool isNotPostOwner = currentId != ownerId;
    // if (isNotPostOwner) {
    activityFeedRef.doc(postOwnerId).collection("feedItems").add({
      "type": "comment",
      "commentData": commentController.text,
      "username": currentUser['nom'],
      "userId": currentId,
      "userProfileImg": currentUser['photo'],
      "postId": postId,
      "mediaUrl": postMedialUrl,
      "timestamp": timestamp
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        /*  leading: Icon(
          Icons.menu,
        ),*/
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildComments(),
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: " Write a comment....",
              ),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              child: Text("Post"),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
    required this.username,
    required this.userId,
    required this.avatarUrl,
    required this.comment,
    required this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      avatarUrl: doc['avatarUrl'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(avatarUrl)),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider(),
      ],
    );
  }
}
