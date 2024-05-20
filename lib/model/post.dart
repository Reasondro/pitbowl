import 'dart:io';

import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class Post {
  Post(
      {String? id,
      required this.title,
      required this.desc,
      required this.video})
      : id = id ?? uuid.v4();

  final String id;
  final String title;
  final String desc;
  final File video;
}
