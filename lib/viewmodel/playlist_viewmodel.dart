import 'package:flutter/cupertino.dart';
import 'package:music_player_test/model/song_model.dart';

import '../model/playlist_model.dart';

class PlaylistViewModel extends ChangeNotifier{
  List<PlaylistModel> playlist = [];
  List<SongModel> songs = [];

  void initPlaylist(){
    PlaylistModel p = PlaylistModel(id: 1, name: "playlist1");
    //add songs
    p.songs.add(songs[0]);
    p.songs.add(songs[1]);
    playlist.add(p);
    p = PlaylistModel(id: 2, name: "playlist2");
    //add songs
    p.songs.add(songs[2]);
    p.songs.add(songs[3]);
    playlist.add(p);
    p = PlaylistModel(id: 3, name: "playlist3");
    //add songs
    p.songs.add(songs[2]);
    p.songs.add(songs[3]);
    p.songs.add(songs[4]);
    playlist.add(p);
  }

  void init(){
   initSongs();
   initPlaylist();
  }

  void initSongs(){
    //load all song in asset
    songs.add(SongModel(id: 0, title: "Reflection", artist: "Geoplex", path: "songs/492636_Reflection.mp3"));
    songs.add(SongModel(id: 1, title: "Tenacious", artist: "Spaze", path: "songs/497056_SpazeTenacious.mp3"));
    songs.add(SongModel(id: 2, title: "Fractal", artist: "Geoplex", path: "songs/501631_Fractal.mp3"));
    songs.add(SongModel(id: 3, title: "Demons Inside Unmastered", artist: "TBM", path: "songs/504085_Demons-Inside-Unmas.mp3"));
    songs.add(SongModel(id: 4, title: "Jetstream", artist: "Geoplex", path: "songs/507531_Jetstream.mp3"));
  }
}