import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TextTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  const TextTile({
    required this.message,
    required this.isSendByMe,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.04,
        vertical: deviceHeight * 0.004,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.04,
          vertical: deviceHeight * 0.015,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe
                ? [Color(0xFF007EF4), Color(0xFF2A75BC)]
                : [Color(0x1AFFFFFF), Color(0x1AFFFFFF)],
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomLeft: isSendByMe ? Radius.circular(20) : Radius.circular(0),
            bottomRight: isSendByMe ? Radius.circular(0) : Radius.circular(20),
          ),
        ),
        constraints: BoxConstraints(
          minWidth: 0,
          maxWidth: deviceWidth * 0.75,
        ),
        child: Text(
          message,
          maxLines: 200,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class ImageTile extends StatelessWidget {
  final String imageUrl;
  final bool isSendByMe;
  ImageTile({
    required this.imageUrl,
    required this.isSendByMe,
  });

  @override
  Widget build(BuildContext context) {
    return TileLayout(
      isSendByMe: isSendByMe,
      child: Image.network(
        imageUrl,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

class VideoTile extends StatefulWidget {
  final bool isSendByMe;
  final String videoUrl;
  const VideoTile({
    required this.isSendByMe,
    required this.videoUrl,
  });

  @override
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return TileLayout(
      isSendByMe: widget.isSendByMe,
      child: Stack(
        children: [
          _controller!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              : Container(
                  // color: Theme.of(context).scaffoldBackgroundColor,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          Positioned(
            bottom: deviceWidth * 0.01,
            right: deviceWidth * 0.01,
            child: IconButton(
              color: Colors.white60,
              onPressed: () {
                setState(() {
                  _controller!.value.isPlaying
                      ? _controller!.pause()
                      : _controller!.play();
                });
              },
              icon: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: deviceWidth * 0.1,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AudioTile extends StatefulWidget {
  final bool isSendByMe;
  final String audioUrl;

  const AudioTile({
    required this.isSendByMe,
    required this.audioUrl,
  });

  @override
  _AudioTileState createState() => _AudioTileState();
}

class _AudioTileState extends State<AudioTile> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration();
  Duration position = Duration();
  bool playing = false;

  Widget slider() {
    return Slider.adaptive(
      min: 0.0,
      max: duration.inSeconds.toDouble(),
      value: position.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          audioPlayer.seek(Duration(seconds: value.toInt()));
        });
      },
    );
  }

  void getAudio() async {
    //  playing is pause by default
    if (playing) {
      //  pause song
      var res = await audioPlayer.pause();
      if (res == 1) {
        setState(() {
          playing = false;
        });
      }
    } else {
      //  play song
      var res = await audioPlayer.play(widget.audioUrl, isLocal: true);
      if (res == 1) {
        setState(() {
          playing = true;
        });
      }
      audioPlayer.onDurationChanged.listen((Duration dd) {
        setState(() {
          duration = dd;
        });
      });
      audioPlayer.onAudioPositionChanged.listen((Duration dd) {
        setState(() {
          duration = dd;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHeight * 0.06,
      child: FittedBox(
        child: TileLayout(
          isSendByMe: widget.isSendByMe,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  getAudio();
                },
                child: Icon(
                  playing == false ? Icons.play_arrow : Icons.pause,
                  color: Colors.white60,
                ),
              ),
              slider(),
            ],
          ),
        ),
      ),
    );
  }
}

/// tile layout for images, videos and audio only
class TileLayout extends StatelessWidget {
  final child;
  final isSendByMe;
  const TileLayout({
    this.child,
    this.isSendByMe,
  });
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.04,
        vertical: deviceHeight * 0.004,
      ),
      child: Container(
        width: deviceWidth * 0.75,
        padding: EdgeInsets.all(deviceWidth * 0.015),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe
                ? [Color(0xFF007EF4), Color(0xFF2A75BC)]
                : [Color(0x1AFFFFFF), Color(0x1AFFFFFF)],
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomLeft: isSendByMe ? Radius.circular(10) : Radius.circular(0),
            bottomRight: isSendByMe ? Radius.circular(0) : Radius.circular(10),
          ),
        ),
        child: child,
      ),
    );
  }
}
