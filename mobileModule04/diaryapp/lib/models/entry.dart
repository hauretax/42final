import 'dart:convert';

import 'package:flutter/widgets.dart';

class Entry {
  final int? id;
  final DateTime date;
  final String icon;
  final String text;
  final String title;
  final String usermail;

  Entry({
    this.id,
    required this.usermail,
    required this.icon,
    required this.text,
    required this.title,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usermail': usermail,
      'icon': icon,
      'text': text,
      'title': title,
      'date': date,
    };
  }

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      id: map['id']?.toInt() ?? 0,
      usermail: map['usermail'] ?? '',
      icon: map['icon'] ?? '',
      text: map['text'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Entry.fromJson(String source) => Entry.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Dog(id: $id, usermail: $usermail, icon: $icon, text: $text, title: $title, date: $date)';
  }
}
