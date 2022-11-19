import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lazy_music/model/action.dart';
import 'package:lazy_music/model/music.dart';
import 'package:lazy_music/services/music_service.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const LazyMusic());
}

class LazyMusic extends StatelessWidget {
  const LazyMusic({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lazy Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Lazy Music'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final musicService = MusicService();
  int index = 0;
  final player = AudioPlayer();
  late Music currentMusic;
  var position = const Duration(seconds: 0);
  var duration = const Duration(seconds: 0);
  var isPlaying = false;
  var status = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    init();
    config();
  }

  @override
  Widget build(BuildContext context) {
    // Cover
    Widget cover = Card(
      elevation: 9.0,
      child: SizedBox(
        width: MediaQuery.of(context).size.height / 2.5,
        child: Image.asset(
          currentMusic.path,
        ),
      ),
    );

    // Text Info
    Widget textInfo(String data, double scale) {
      return Text(
        data,
        textScaleFactor: scale,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    // Music Info : UID - Title
    Widget title = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textInfo(currentMusic.uid, 1.2),
        const SizedBox(width: 5.0),
        textInfo('-', 1),
        const SizedBox(width: 5.0),
        textInfo(currentMusic.title, 1.2),
      ],
    );

    // Music Info : Artist
    Widget artist = textInfo(currentMusic.album, 0.8);

    // Icon Button : Play, forward, backward
    Widget iconButton(IconData icon, double size, ActionMusic action) {
      return IconButton(
        icon: Icon(icon),
        onPressed: () {
          switch (action) {
            case ActionMusic.play:
              play();
              break;
            case ActionMusic.pause:
              pause();
              break;
            case ActionMusic.forward:
              forward();
              break;
            case ActionMusic.backward:
              backward();
              break;
          }
        },
        iconSize: size,
        color: Colors.white,
      );
    }

    // Row : Play, forward, backward
    Widget rowIconButtons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconButton(Icons.fast_rewind, 30.0, ActionMusic.backward),
        iconButton(isPlaying ? Icons.pause : Icons.play_arrow, 45.0,
            isPlaying ? ActionMusic.pause : ActionMusic.play),
        iconButton(Icons.fast_forward, 30.0, ActionMusic.forward),
      ],
    );

    // Music Info : Duration
    Widget durations = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20.0),
          child: textInfo(getDuration(position), 1.0),
        ),
        Container(
          margin: const EdgeInsets.only(right: 20.0),
          child: textInfo(getDuration(duration), 1.0),
        ),
      ],
    );

    // Slider : Duration
    Widget slider = Slider(
      value: double.parse(position.inSeconds.toString()),
      onChanged: (value) {
        setState(() {
          player.seek(Duration(seconds: value.toInt()));
        });
      },
      min: 0.0,
      max: double.parse(duration.inSeconds.toString()),
      activeColor: Colors.yellow[800],
      inactiveColor: Colors.white,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: const Color(0xff0d111e),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            cover,
            title,
            artist,
            rowIconButtons,
            durations,
            slider,
          ],
        ),
      ),
      backgroundColor: Colors.grey[800],
    );
  }

  // config methods
  void init() {
    currentMusic = musicService.getMusicList()[index];
  }

  void config() {
    player.onDurationChanged.listen((Duration d) {
      setState(() => duration = d);
    });
    //Listen to the player state
    player.onPositionChanged
        .listen((Duration p) => {setState(() => position = p)});
    //State of the player
    player.onPlayerStateChanged.listen(
        (PlayerState s) => {
              if (s == PlayerState.playing)
                {
                  setState(() {
                    status = s;
                    isPlaying = true;
                  })
                }
              else if (s == PlayerState.stopped)
                {
                  setState(() {
                    status = s;
                    isPlaying = false;
                  })
                }
            }, onError: (msg) {
      setState(() {
        status = PlayerState.stopped;
        position = const Duration(seconds: 0);
        duration = const Duration(seconds: 0);
      });
    });

    player.onPlayerComplete.listen((event) {
      onComplete();
      setState(() {
        position = duration;
      });
    });
  }

  // Fetch Api to play music
  Future play() async {
    await player.play(UrlSource(currentMusic.url));
    setState(() {
      status = PlayerState.playing;
      isPlaying = true;
    });
  }

  void onComplete() {
    if (index == musicService.getMusicList().length - 1) {
      index = 0;
    } else {
      index++;
    }
    currentMusic = musicService.getMusicList()[index];
    play();
  }

  // Fetch Api to pause music
  Future pause() async {
    await player.pause();
    setState(() {
      status = PlayerState.paused;
      isPlaying = false;
    });
  }

  void forward() {
    if (index == musicService.getMusicList().length - 1) {
      index = 0;
    } else {
      index++;
    }
    currentMusic = musicService.getMusicList()[index];
    player.stop();
    play();
  }

  void backward() {
    if (position > const Duration(seconds: 3)) {
      player.seek(const Duration(seconds: 0));
    } else {
      if (index == 0) {
        index = musicService.getMusicList().length - 1;
      } else {
        index--;
      }
      currentMusic = musicService.getMusicList()[index];
      player.stop();
      play();
    }
  }

  // Label : Duration
  String getDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
