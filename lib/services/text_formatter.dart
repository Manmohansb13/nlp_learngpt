import 'package:flutter/material.dart';

List<TextSpan> parseAndBoldText(String text) {
  List<TextSpan> spans = [];
  final regex = RegExp(r'\*([^*]+)\*');
  int lastIndex = 0;

  for (final match in regex.allMatches(text)) {

    if (match.start > lastIndex) {
      spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
    }


    spans.add(TextSpan(
      text: match.group(1), // Text inside '* *'
      style: TextStyle(fontWeight: FontWeight.bold),
    ));

    lastIndex = match.end;
  }


  if (lastIndex < text.length) {
    spans.add(TextSpan(text: text.substring(lastIndex)));
  }

  return spans;
}

Widget buildFormattedText(String text) {
  return RichText(
    text: TextSpan(
      children: parseAndBoldText(text),
      style: TextStyle(color: Colors.black, fontSize: 16.0),
    ),
  );
}
