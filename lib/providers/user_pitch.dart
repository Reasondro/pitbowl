import 'dart:io';
import 'package:pitbowl/model/pitch.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitbowl/model/pitch.dart';

class UserPitchNotifier extends Notifier<List<Pitch>> {
  @override
  List<Pitch> build() {
    // loadPitches(); //Todo so load pithces here to acess the state
    // List<Pitch> ;
    return [];
  }

  Future<void> loadPitches() async {} //TODO try to load from cloud

  void addPitch(Pitch newPitch)
  //TODO use the upload to the cloud mechansim here. right below the state stuffs
  {
    state = [newPitch, ...state];
  }
}
