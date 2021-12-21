import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_profil/Custom_Botton_Nav_Bar.dart';
import 'package:project_profil/constants.dart';
import 'package:project_profil/enums.dart';
import 'package:project_profil/main.dart';
import 'package:project_profil/pages/message_screen.dart';
import 'package:project_profil/welcome/Login/components/body.dart';
import 'package:project_profil/widgets/header.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:project_profil/theme.dart';

class chatScreen extends StatefulWidget {
  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  List<chatScreenItem> chatItems = [];
  getChat() async {
    QuerySnapshot snapshot =
        await chatsRef.orderBy("date", descending: true).get();

    print(snapshot.docs.length);
    snapshot.docs.forEach((doc) {
      print("Activity Feed Item: doc");
      print(doc.data());
      print("chatScreenItem.formDocument(doc)");
      print(chatScreenItem.formDocument(doc));
      print("chatScreenItem.formDocument(doc)");
      chatItems.add(chatScreenItem.formDocument(doc));
    });
    print(
        "chatItems.lengthchatItems.lengthchatItems.lengthchatItems.lengthchatItems.length");
    print(chatItems);
    //  return snapshot.docs;
    return chatItems;
  }

  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      bottomNavigationBar: CustomBottonNavBar(
          selectedMenu: MenuState.message, currentId: currentId),
      body: Container(
        child: FutureBuilder(
            future: getChat(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return ListView(
                children: chatItems,
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF00BF6D),
        child: Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
      //bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text("Chats",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: kPrimaryColor,
              fontFamily: "Roboto",
              fontSize: 36,
              fontWeight: FontWeight.w700)),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: kPrimaryColor,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class chatScreenItem extends StatelessWidget {
  final String admin;
  final String avatar;
  final Timestamp date;
  final String name;
  final String name_client;
  final String client;

  const chatScreenItem(
      {required this.admin,
      required this.avatar,
      required this.date,
      required this.name,
      required this.name_client,
      required this.client});

  factory chatScreenItem.formDocument(DocumentSnapshot doc) {
    print("docdocdocdoc");
    print(doc['admin']);
    print(doc['avatar']);
    print(doc['date']);
    print(doc['name_client']);
    print(doc['client']);
    return chatScreenItem(
      admin: doc['admin'],
      avatar: doc['avatar'],
      date: doc['date'],
      name: "rayen",
      name_client: doc['name_client'],
      client: doc['client'],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("testttttttttttttttttttttttttttttttt");
    print(name);
    return InkWell(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageScreen(
                admin: admin,
                avatar: avatar,
                date: date,
                name: "rayen",
                name_client: name_client,
                client: client,
              ),
            ))
      },
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0 * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: CachedNetworkImageProvider(avatar),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: Color(0xFF00BF6D),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 3),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        "lastMessage ......;",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(
                timeago.format(date.toDate()),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
