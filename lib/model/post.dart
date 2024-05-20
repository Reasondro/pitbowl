import 'dart:io';

import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class Post {
  Post(
      {String? id,
      required this.title,
      required this.desc,
      required this.username,
      required this.userProfilePicture,
      required this.videoPost})
      : id = id ?? uuid.v4();

  final String id;
  final String title;
  final String desc;
  final String username;
  final File userProfilePicture;
  final File videoPost;
}
