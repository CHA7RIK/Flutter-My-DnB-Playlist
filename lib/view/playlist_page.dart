import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:music_player_test/viewmodel/player_viewmodel.dart';
import 'package:music_player_test/viewmodel/playlist_viewmodel.dart';
import 'package:music_player_test/widgets/playlist_tile_widget.dart';
import 'package:music_player_test/widgets/song_tile_widget.dart';
import 'package:provider/provider.dart';

import '../model/playlist_model.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {

  late ScrollController scrollController;

  SlidingUpPanelController panelController = SlidingUpPanelController();
  double minBound = 0;
  double upperBound = 1.0;
  late PlaylistViewModel playlistViewModel;
  late SongPlayerViewModel songPlayerViewModel;
  PlaylistModel? selectedPlaylist;

  @override
  void initState() {

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
      } else if (scrollController.offset <=
          scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.anchor();
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    playlistViewModel = context.read<PlaylistViewModel>();
    songPlayerViewModel = context.watch<SongPlayerViewModel>();

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("My Playlist"),
          ),
          body: Center(
            child: ListView.separated(
              itemBuilder: (context, index) => PlaylistTile(
                playlist: playlistViewModel.playlist[index],
                onPlay: () async {
                  setState(() {
                    //select playlist
                    selectedPlaylist = playlistViewModel.playlist[index];
                  });
                  if(playlistViewModel.playlist[index].songs.isNotEmpty){
                    await songPlayerViewModel.setPlaylistAndPlay(selectedPlaylist!, 0);
                  }
                },
                onTap: (){
                  setState(() {
                    //select playlist
                    selectedPlaylist = playlistViewModel.playlist[index];
                    panelController.expand();
                  });
                },
                isPlaying: songPlayerViewModel.currentPlaylist?.id == playlistViewModel.playlist[index].id,
              ),
              itemCount: playlistViewModel.playlist.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
            )
          ),
        ),
        if(selectedPlaylist != null) SlidingUpPanelWidget(
          controlHeight: 120.0,
          anchor: 0.0,
          minimumBound: minBound,
          upperBound: upperBound,
          panelController: panelController,
          onTap: () {
            if (SlidingUpPanelStatus.expanded == panelController.status) {
              panelController.collapse();
            } else {
              panelController.expand();
            }
          },
          enableOnTap: true,
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shadows: [
                BoxShadow(
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    color: const Color(0x11000000))
              ],
              shape: Border(

              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LinearProgressIndicator(
                  backgroundColor: Colors.black12,
                  color: Colors.blueAccent,
                  value: songPlayerViewModel.positionPercentage,
                ),
                if(songPlayerViewModel.currentPlaylist != null) Container(
                  alignment: Alignment.center,
                  height: 120.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/images/album_dummy.png'),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                songPlayerViewModel.getCurrentSong()?.title ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                songPlayerViewModel.getCurrentSong()?.artist ?? "",
                              ),
                            ],
                          )
                        ),
                        IconButton(
                            onPressed: (){
                              songPlayerViewModel.previous();
                            },
                            icon: Icon(Icons.skip_previous)
                        ),
                        IconButton(
                          onPressed: (){
                            switch(songPlayerViewModel.playerState){
                              case PlayerState.playing :
                                songPlayerViewModel.pause();
                                break;
                              case PlayerState.paused :
                              case PlayerState.stopped :
                                songPlayerViewModel.play();
                                break;
                              default:
                                break;
                            }
                          },
                          icon: songPlayerViewModel.playerState == PlayerState.playing ? Icon(Icons.pause_circle_outline, size: 50,) :
                                  Icon(Icons.play_circle_outline, size: 50,)
                        ),
                        IconButton(
                          onPressed: (){
                            songPlayerViewModel.next();
                          },
                          icon: Icon(Icons.skip_next)
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 0.5,
                  color: Colors.grey[300],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(selectedPlaylist != null ? selectedPlaylist!.name : "", style: TextStyle(fontSize: 22),)
                ),
                Flexible(
                  child: Container(
                    color: Colors.white,
                    child: ListView.separated(
                      controller: scrollController,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SongTile(
                          song: selectedPlaylist!.songs[index],
                          onTap: () async {
                            await songPlayerViewModel.setPlaylistAndPlay(selectedPlaylist!, index);
                          },
                          isPlaying: selectedPlaylist?.id == songPlayerViewModel.currentPlaylist?.id && selectedPlaylist?.songs[index].id == songPlayerViewModel.getCurrentSong()?.id ,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 0.5,
                        );
                      },
                      shrinkWrap: true,
                      itemCount: selectedPlaylist == null ? 0 : selectedPlaylist!.songs.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

