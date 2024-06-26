import 'dart:convert';

import 'package:flutter/widgets.dart';

class Dog {
  final int? id;
  final String name;

  Dog({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Dog.fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Dog.fromJson(String source) => Dog.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Dog(id: $id, name: $name)';
  }
}