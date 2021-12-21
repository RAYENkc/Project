import 'package:flutter/material.dart';
import 'package:project_profil/Custom_Botton_Nav_Bar.dart';
import 'package:project_profil/enums.dart';
import 'package:project_profil/pages/timeline.dart';
import 'package:project_profil/theme.dart';

class home extends StatefulWidget {
  final String currentId;

  const home({required this.currentId});

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    print("uidddddddddd");
    print(widget.currentId);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      home: Scaffold(
          appBar: AppBar(
            title: Text("Profile"),
          ),
          //  body: Timeline(),
          bottomNavigationBar: CustomBottonNavBar(
              selectedMenu: MenuState.home, currentId: widget.currentId)),
    );
  }
}
/*
class PofileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        // body: Body(),
        bottomNavigationBar:
            CustomBottonNavBar(selectedMenu: MenuState.profile,currentId: widget.currentId));
  }

}
  */