import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_test/model/playlist_model.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile({Key? key, required this.playlist, required this.onPlay, required this.onTap, this.isPlaying = false}) : super(key: key);
  final PlaylistModel playlist;
  final Function? onPlay;
  final Function? onTap;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 5),
      leading: Image.asset('assets/images/playlist_dummy.png'),
      title: Text(playlist.name),
      trailing: !isPlaying ? IconButton(
        onPressed: (){
          if(onPlay != null) onPlay!();
        },
        icon: Icon(Icons.play_circle_outline, size: 50,)
      ) : null,
      onTap: (){
        if(onTap != null) onTap!();
      },
    );
  }
}
