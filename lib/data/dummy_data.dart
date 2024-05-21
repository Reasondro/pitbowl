import 'dart:io';

import 'package:pitbowl/model/pitch.dart';

final dummyPitches = List.generate(
  20,
  (i) => Pitch(
      title: 'title $i',
      desc: 'desc $i',
      username: 'username $i',
      date: 'date $i ',
      // videoPitch: videoPitch,
      videoPitchUrl: 'videoPitchUrl $i'),
);
