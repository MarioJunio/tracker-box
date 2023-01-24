import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tracker_box/app/shared/utils/hex_color.dart';

class UserEntity {
  final String? id;
  final String? username;
  final String? fullname;
  final Color? color;

  UserEntity({
    this.id,
    this.username,
    this.fullname,
    this.color,
  });

  UserEntity copyWith({
    String? id,
    String? username,
    String? fullname,
    Color? color,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'fullname': fullname,
      'color': color?.value,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'],
      username: map['username'],
      fullname: map['fullname'],
      color: map['color'] != null ? HexColor(map['color']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source) => UserEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserEntity(id: $id, username: $username, fullname: $fullname, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserEntity &&
      other.id == id &&
      other.username == username &&
      other.fullname == fullname &&
      other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      fullname.hashCode ^
      color.hashCode;
  }
}
