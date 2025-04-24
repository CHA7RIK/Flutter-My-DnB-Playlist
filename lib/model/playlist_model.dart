import 'package:music_player_test/model/song_model.dart';

class PlaylistModel {
  PlaylistModel({required this.id, required this.name});

  int id;
  String name;
  List<SongModel> songs = [];
}