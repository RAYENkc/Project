import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_profil/Custom_Botton_Nav_Bar.dart';
import 'package:project_profil/enums.dart';
import 'package:project_profil/main.dart';
import 'package:project_profil/pages/post_screen.dart';
import 'package:project_profil/pages/profile.dart';
import 'package:project_profil/welcome/Login/components/body.dart';
import 'package:project_profil/widgets/header.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

List<ActivityFeedItem> feedItems = [];

class _ActivityFeedState extends State<ActivityFeed> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .doc(currentId)
        .collection('feedItems')
        .orderBy("timestamp", descending: true)
        .limit(50)
        .get();

    snapshot.docs.forEach((doc) {
      print(ActivityFeedItem.formDocument(doc));
      feedItems.add(ActivityFeedItem.formDocument(doc));
    });
    //  return snapshot.docs;
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, "Notification"),
        bottomNavigationBar: CustomBottonNavBar(
            selectedMenu: MenuState.profile, currentId: currentId),
        body: Container(
          child: FutureBuilder(
              future: getActivityFeed(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return ListView(
                  children: feedItems,
                );
              }),
        ));
  }
}

late Widget mediaPreview;
late String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final String mediaUrl;
  final Timestamp timestamp;

  const ActivityFeedItem(
      {required this.username,
      required this.mediaUrl,
      required this.userId,
      required this.type, //'like', 'follow', 'comment'
      required this.postId,
      required this.userProfileImg,
      required this.commentData,
      required this.timestamp});

  factory ActivityFeedItem.formDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc['username'],
      userId: doc['userId'],
      mediaUrl: doc['mediaUrl'],
      type: doc['type'],
      postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
    );
  }

  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(
          postId: postId,
          userId: userId,
        ),
      ),
    );
  }

  configureMediaPreview(context) {
    if (type == "like" || type == "comment") {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(mediaUrl))),
              )),
        ),
      );
    } else {
      mediaPreview = Text('');
    }
    if (type == 'like') {
      activityItemText = "   liked your post";
    } else if (type == 'follow') {
      activityItemText = "  is folloing you";
    } else if (type == 'comment') {
      activityItemText = "  replied: $commentData";
    } else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => showProfile(context, profileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '$activityItemText',
                    )
                  ]),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}

showProfile(BuildContext context, {required String profileId}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Profil(
        profileId: profileId,
      ),
    ),
  );
}
