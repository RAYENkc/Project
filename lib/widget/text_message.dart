import 'package:flutter/material.dart';
import 'package:project_profil/main.dart';

import '../../../constants.dart';

class TextMessage extends StatefulWidget {
  final String message;
  final bool isSender;
  const TextMessage({
    required this.message,
    required this.isSender,
  });

  @override
  State<TextMessage> createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0 * 0.9,
        vertical: 20.0 / 2,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(widget.isSender ? 1 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        widget.message,
        style: TextStyle(
          color: widget.isSender
              ? Colors.white
              : Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );
  }
}
