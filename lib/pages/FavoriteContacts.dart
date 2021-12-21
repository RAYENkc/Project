import 'package:flutter/material.dart';

class FavoriteContacts extends StatefulWidget {
  final String user;
  final String uid;
  FavoriteContacts({required this.user, required this.uid});
  @override
  _FavoriteContactsState createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 75.0, vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'favorite Contacts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: 90.0,
              child: FutureBuilder(
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (_isLoading) {
                  return Text('loding.............');
                }

                return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              /*  CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage: NetworkImage(),
                                ),*/
                              SizedBox(height: 5.0),
                              Text(
                                "_apiResponse.data[index].Social_Reason",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }))
        ]));
  }
}
