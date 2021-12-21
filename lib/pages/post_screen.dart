import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_profil/main.dart';
import 'package:project_profil/widgets/header.dart';
import 'package:project_profil/widgets/post.dart';

class PostScreen extends StatelessWidget {
  late final String userId;
  late final String postId;

  PostScreen({required this.userId, required this.postId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef.doc(userId).collection('userPosts').doc(postId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        print("snapshot.data !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        print(snapshot.data);
        print(snapshot.data);
        Post post = Post(
            postId: "data['postId']",
            ownerId: "data['ownerId']",
            username: " data['username']",
            location: "data['location']",
            description: "data['description']",
            mediaUrl: "data['mediaUrl']",
            likes: "data[' likes']");
        return Center(
          child: Scaffold(
            appBar: header(context, post.description),
            body: ListView(
              children: <Widget>[
                Container(
                  child: post,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
