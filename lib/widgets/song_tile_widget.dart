import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/song_model.dart';

class SongTile extends StatelessWidget {
  const SongTile({Key? key, required this.song, required this.onTap, this.isPlaying = false}) : super(key: key);
  final SongModel song;
  final Function? onTap;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 5),
      leading: Image.asset('assets/images/album_dummy.png'),
      title: Text(song.title),
      subtitle: Text(song.artist),
      onTap: (){
        if(onTap != null) onTap!();
      },
      trailing: !isPlaying ? Icon(Icons.play_arrow) : null,
    );
  }
}
