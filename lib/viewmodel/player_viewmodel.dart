import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player_test/model/playlist_model.dart';

import '../model/song_model.dart';

class SongPlayerViewModel extends ChangeNotifier {

  final AudioPlayer _soundPlayer = AudioPlayer();
  int currentSongIndex = -1;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double positionPercentage = 0;
  PlaylistModel? currentPlaylist;
  PlayerState playerState = PlayerState.stopped;

  void setCurrentPlaylist(PlaylistModel playlist){
    currentPlaylist = playlist;
  }

  Future<void> setPlaylistAndPlay(PlaylistModel playlist, int index) async {
    setCurrentPlaylist(playlist);
    currentSongIndex = index;
    await setCurrentSong(index);
    await play();

    notifyListeners();
  }

  Future<void> setCurrentSong(int index) async {
    if(currentPlaylist != null) {
      if (_soundPlayer.state == PlayerState.playing) {
        stop();
      }
      await _soundPlayer.setSource(AssetSource(currentPlaylist!.songs[index].path));
      _duration = await _soundPlayer.getDuration() ?? Duration.zero;
      notifyListeners();
    }
  }

  void init(){
    _soundPlayer.onPlayerStateChanged.listen(_playerStateChange);
    _soundPlayer.onPositionChanged.listen(_playerPositionUpdate);
    _soundPlayer.onPlayerComplete.listen(_playerSongEnd);
  }

  SongModel? getCurrentSong(){
    if(currentPlaylist == null || currentSongIndex == -1) {
      return null;
    }
    return currentPlaylist!.songs[currentSongIndex];
  }

  Future<void> play() async {
    if(currentSongIndex != -1) {
      if(_soundPlayer.source != null) {
        await setCurrentSong(currentSongIndex);
      }
      await _soundPlayer.resume();
    }

    notifyListeners();
  }

  Future<void> stop() async{
    if(_soundPlayer.state == PlayerState.playing || _soundPlayer.state == PlayerState.paused){
      await _soundPlayer.stop();
      _position = Duration.zero;
    }

    notifyListeners();
  }

  Future<void> pause() async{
    if(_soundPlayer.state == PlayerState.playing){
      await _soundPlayer.pause();
    }

    notifyListeners();
  }

  void previous() {
    if(currentPlaylist == null) return;
    if(positionPercentage > 0.2 || currentSongIndex == 0){
      _soundPlayer.seek(Duration.zero);
    } else {
      currentSongIndex--;
      setCurrentSong(currentSongIndex);
      play();
    }

    notifyListeners();
  }

  Future<void> next({bool startPlaying = true}) async {
    if(currentPlaylist == null) return;
    if (currentSongIndex >= currentPlaylist!.songs.length - 1) {
      currentSongIndex = 0;
    } else {
      currentSongIndex++;
    }
    await setCurrentSong(currentSongIndex);
    if(startPlaying) await play();

    notifyListeners();
  }

  void _playerStateChange(PlayerState state){
    playerState = state;
    notifyListeners();
  }
  void _playerPositionUpdate(Duration position){
    _position = position;
    if(_duration != Duration.zero) {
      positionPercentage = (_position.inSeconds / _duration.inSeconds);
    } else {
      positionPercentage = 0;
    }
    notifyListeners();
  }

  void _playerSongEnd(void _){
    next(startPlaying: currentSongIndex < currentPlaylist!.songs.length - 1);
  }
}