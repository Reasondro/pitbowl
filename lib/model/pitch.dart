import 'dart:io';

import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class Pitch {
  Pitch(
      {String? id,
      required this.title,
      required this.desc,
      required this.username,
      required this.category,
      // required this.date,
      // required this.userProfilePicture,
      // required this.videoPitch,
      required this.videoPitchUrl})
      : id = id ?? uuid.v4();

  final String id;
  final String title;
  final String desc;
  final String username;
  final String category;
  // final String date;
  // final File userProfilePicture;
  // final File videoPitch;
  final String videoPitchUrl;
}
