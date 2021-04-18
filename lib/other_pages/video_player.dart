import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wantsbucks/custom%20widgets/my_url_launcher.dart';
import 'package:wantsbucks/theming/color_constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  YoutubePlayerController _playerController;
  YoutubeMetaData _youtubeMetaData;

  Duration position = Duration(seconds: 0);
  int _played = 0;
  bool _isPlayerReady = false;
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    _playerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          "https://youtu.be/b_sQ9bMltGU?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG"),
      flags: const YoutubePlayerFlags(
        hideControls: true,
        mute: false,
        autoPlay: true,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    )
      ..addListener(listener)
      ..setVolume(100);
    _youtubeMetaData = YoutubeMetaData();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_playerController.value.isFullScreen) {
      setState(() {
        position = _playerController.value.position;
        _played = _playerController.value.position.inSeconds;
        _youtubeMetaData = _playerController.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _playerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _playerController,
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          setState(() {
            _opacity = 1;
          });
        },
      ),
      builder: (context, player) => Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Opacity(
                      opacity: _opacity,
                      child: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: _opacity != 1
                            ? null
                            : () {
                                Navigator.pop(context, 1);
                              },
                      )),
                ],
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    launchURL("https://google.com");
                  },
                  child: Container(
                    color: mainBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                            child: Text(
                          "${_youtubeMetaData.title}",
                          textAlign: TextAlign.center,
                        )),
                        Center(
                            child: Text(
                          "Duration: ${_youtubeMetaData.duration.toString().substring(0, 7)}",
                          textAlign: TextAlign.center,
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        player,
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child:
                                Text("${position.toString().substring(0, 7)}")),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _played >= 30
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, 1);
                          },
                          child: Text("Claim Point!")),
                    )
                  : Opacity(
                      opacity: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                            onPressed: null, child: Text("Skip Video!")),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
