import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_profil/main.dart';
import 'package:project_profil/widget/chat_input_field.dart';
import 'package:project_profil/widget/text_message.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageScreen extends StatefulWidget {
  final String admin;
  final String avatar;
  final Timestamp date;
  final String name;
  final String name_client;
  final String client;

  const MessageScreen(
      {required this.admin,
      required this.avatar,
      required this.date,
      required this.name,
      required this.name_client,
      required this.client});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<MessageScreenItem> messageItems = [];

  getmessage() async {
    print(widget.admin.replaceAll(" ", ""));
    QuerySnapshot snapshot = await chatsRef
        .doc(widget.admin.replaceAll(" ", ""))
        .collection('messages')
        .orderBy("createdAt", descending: false)
        .get();

    print(snapshot.docs.length);
    snapshot.docs.forEach((doc) {
      print("Activity Feed Item: doc");
      print(doc.data());
      print("chatScreenItem.formDocument(doc)");
      print(MessageScreenItem.formDocument(doc));
      print("chatScreenItem.formDocument(doc)");
      messageItems.add(MessageScreenItem.formDocument(doc));
    });
    print(
        "chatItems.lengthchatItems.lengthchatItems.lengthchatItems.lengthchatItems.length");
    print(messageItems);
    //  return snapshot.docs;
    return messageItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FutureBuilder(
                  future: getmessage(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return ListView(
                      children: messageItems,
                    );
                  }),
            ),
          ),
          ChatInputField(
            admin: widget.admin,
            avatar: widget.avatar,
            date: widget.date,
            name: "rayen",
            name_client: widget.name_client,
            client: widget.client,
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(widget.avatar),
          ),
          SizedBox(width: 20.0 * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(color: Colors.grey[800], fontSize: 16),
              ),
              Text(
                timeago.format(widget.date.toDate()),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[800], fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: () {},
        ),
        SizedBox(width: 20.0 / 2),
      ],
    );
  }
}

class MessageScreenItem extends StatelessWidget {
  final String message;
  final String idUser;
  final Timestamp createdAt;
  final String urlAvatar;
  final String username;
  final bool isSender;
  const MessageScreenItem({
    required this.createdAt,
    required this.idUser,
    required this.message,
    required this.urlAvatar,
    required this.username,
    required this.isSender,
  });

  factory MessageScreenItem.formDocument(DocumentSnapshot doc) {
    print("docdocdocdoc");
    print(doc['createdAt']);
    print(doc['idUser']);
    print(doc['message']);
    print(doc['urlAvatar']);
    print(doc['username']);
    return MessageScreenItem(
        createdAt: doc['createdAt'],
        idUser: doc['idUser'],
        message: doc['message'],
        urlAvatar: doc['urlAvatar'],
        username: doc['username'],
        isSender: doc['isSender']);
  }

  /*Widget messageContaint(ChatMessage message) {
      switch (message.messageType) {
        case message:
          return TextMessage(message: message);
        case ChatMessageType.audio:
          return AudioMessage(message: message);
        case ChatMessageType.video:
          return VideoMessage();
        default:
          return SizedBox();
      }*/
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) ...[
            CircleAvatar(
              radius: 18,
              backgroundImage: urlAvatar.isNotEmpty
                  ? NetworkImage(urlAvatar, scale: 1.0)
                  : null,
            ),
            SizedBox(width: 20.0 / 2),
          ],
          TextMessage(message: message, isSender: isSender),
          //   if (idUser == currentId) MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }
}
