import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_profil/main.dart';
import 'package:project_profil/pages/message_screen.dart';
import 'package:project_profil/welcome/Login/components/body.dart';

import '../../../constants.dart';

class ChatInputField extends StatefulWidget {
  final String admin;
  final String avatar;
  final Timestamp date;
  final String name;
  final String name_client;
  final String client;
  const ChatInputField(
      {required this.admin,
      required this.avatar,
      required this.date,
      required this.name,
      required this.name_client,
      required this.client});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

TextEditingController serchController = TextEditingController();
List<MessageScreenItem> messageItems = [];

class _ChatInputFieldState extends State<ChatInputField> {
  bool _isLoading = false;
  getmessage() async {
    setState(() {
      _isLoading = true;
    });
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
    setState(() {
      _isLoading = false;
    });
    print(
        "chatItems.lengthchatItems.lengthchatItems.lengthchatItems.lengthchatItems.length");
    print(messageItems);
    //  return snapshot.docs;
    return messageItems;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0 / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Icon(Icons.mic, color: kPrimaryColor),
            SizedBox(width: 20.0),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0 * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: 10.0 / 4),
                    Expanded(
                      child: TextField(
                        controller: serchController,
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.attach_file,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    IconButton(
                        icon: Icon(Icons.send),
                        iconSize: 25.0,
                        color: Colors.blue[600],
                        onPressed: () async {
                          print(
                              "serchController.textserchController.textserchController.text");
                          print(serchController.text);
                          chatsRef
                              .doc(widget.admin.replaceAll(" ", ""))
                              .collection('messages')
                              .doc()
                              .set({
                            "createdAt": timestamp,
                            "idUser": currentId,
                            "isSender": true,
                            "message": serchController.text,
                            "urlAvatar": currentUser['photo'],
                            "username": currentUser['nom'],
                          });
                          MessageScreen(
                            admin: widget.admin,
                            avatar: widget.avatar,
                            date: widget.date,
                            name: "rayen",
                            name_client: widget.name_client,
                            client: widget.client,
                          );
                          serchController.clear();
                        }),
                    /*  Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),*/
                    SizedBox(width: 20.0 / 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
