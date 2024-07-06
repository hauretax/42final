import 'dart:convert';

class Entry {
  final String? id;
  final DateTime date;
  final String icon;
  final String text;
  final String title;
  final String userUid;

  Entry({
    this.id,
    required this.userUid,
    required this.icon,
    required this.text,
    required this.title,
    required this.date,
  });

  Map<String, dynamic> toMap(String uid) {
    return {
      'id': uid,
      'userUid': userUid,
      'icon': icon,
      'text': text,
      'title': title,
      'date': date.toString(),
    };
  }

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      id: map['id'] ?? '',
      userUid: map['userUid'] ?? '',
      icon: map['icon'] ?? '',
      text: map['text'] ?? '',
      title: map['title'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }


  factory Entry.fromJson(String source) => Entry.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Entry(id: $id, userUid: $userUid, icon: $icon, text: $text, title: $title, date: $date)';
  }


}
