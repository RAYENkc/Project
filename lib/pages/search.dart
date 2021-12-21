import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_profil/Custom_Botton_Nav_Bar.dart';
import 'package:project_profil/enums.dart';
import 'package:project_profil/main.dart';
import 'package:project_profil/model/users.dart';
import 'package:project_profil/pages/activity_feed.dart';
import 'package:project_profil/pages/profile.dart';
import 'package:project_profil/welcome/Login/components/body.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search>
    with AutomaticKeepAliveClientMixin<Search> {
  TextEditingController serchController = TextEditingController();
  List<dynamic> searchResultsFuture = [];
  bool empty = true;
  handleSubmit(String query) async {
    print("serchControllerserchControllerserchControllerserchController");
    print(serchController.text);
    QuerySnapshot users = await usersRef
        .where('nom', isGreaterThanOrEqualTo: serchController.text)
        .get();
    print('je suis la  ya wildiiiiiiiii');
    print(users.docs.length);
    users.docs.map((doc) => print(doc.data()));
    if (users.docs.length > 0) {
      empty = false;
    }
    setState(() {
      searchResultsFuture = users.docs;
    });
  }

  clearSearch() {
    serchController.clear();
  }

  buildSerchField() {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        title: TextFormField(
          controller: serchController,
          decoration: InputDecoration(
            hintText: "Search for a user ....",
            contentPadding:
                new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            filled: true,
            prefixIcon: Icon(
              Icons.account_box,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: clearSearch,
            ),
          ),
          onFieldSubmitted: handleSubmit,
        ));
  }

  Container builNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
        child: Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/search.svg',
            height: orientation == Orientation.portrait ? 300.0 : 200.0,
          ),
          Text(
            "find Users",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0),
          )
        ],
      ),
    ));
  }

  buildSearchResults() {
    return FutureBuilder<QuerySnapshot>(
      future: usersRef.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<UserResult> searchResults = [];

        searchResultsFuture.forEach((doc) {
          print("111111111");
          print(doc.data());

          print("222222222222222222222222");

          print(User.fromJson(doc));

          User user = User.fromJson(doc);

          UserResult searchResult = UserResult(user);
          searchResults.add(searchResult);

          print(searchResult);
          print(searchResults.length);
          print(user.age);
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        // backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        appBar: buildSerchField(),
        body: empty ? builNoContent() : buildSearchResults(),
        bottomNavigationBar: CustomBottonNavBar(
            selectedMenu: MenuState.favourite, currentId: currentId)
        //empty? builNoContent() :
        );
  }
}

class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor.withOpacity(0.7),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profil(
                        profileId: currentId,
                      ),
                    ));
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(user.photo),
                ),
                title: Text(
                  user.nom,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  user.prenom,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Divider(
              height: 2.0,
              color: Colors.white54,
            )
          ],
        ));
  }
}
