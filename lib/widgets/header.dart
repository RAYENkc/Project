import 'package:flutter/material.dart';
import 'package:project_profil/theme.dart';

AppBar header(context, String titleText) {
  return AppBar(
    toolbarHeight: 80,
    title: Text(
      titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Signatra",
        fontSize: 40.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
