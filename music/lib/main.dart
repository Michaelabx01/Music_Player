import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music/son_music/song_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    // After 3 seconds, navigate to the HomePage
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/army_fond.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.purpleAccent,
                    border: Border.all(color: Colors.purple),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image.asset('assets/bts_logo.png', height: 200.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> playlist = [
    "zamona-net-bts-black-swan.mp3",
    "zamona-net-bts-yet-to-come.mp3",
    "zamona-net-bts-standing-next-to-you.mp3",
    "With-You-Jimin-X-Ha-Sung-Woon.mp3"
  ];

  List<String> songNames = ["Black Swan", "Yet to Come", "Standing Next to You", "With You"];

  String imgCoverUrl =
      "https://i.pinimg.com/736x/a7/a9/cb/a7a9cbcefc58f5b677d8c480cf4ddc5d.jpg";

  bool isPlaying = false;
  double value = 0;
  int currentSongIndex = 0;
  final player = AudioPlayer();
  Duration? duration;

  void initPlayer() async {
    await player.setSource(AssetSource(playlist[currentSongIndex]));
    duration = await player.getDuration();
    if (duration == null) {
      log("Error: Unable to retrieve duration.");
    }

    player.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        playNextSong();
      }
    });

    player.onPositionChanged.listen(
      (Duration d) {
        setState(() {
          value = d.inSeconds.toDouble();
        });
      },
    );

    player.onDurationChanged.listen(
      (Duration d) {
        setState(() {
          duration = d;
        });
      },
    );
  }

  Future<void> playNextSong() async {
    if (currentSongIndex < playlist.length - 1) {
      currentSongIndex++;
    } else {
      currentSongIndex = 0; 
    }

    log("Playing next song with crossfade: ${playlist[currentSongIndex]}");

    await player.setSource(AssetSource(playlist[currentSongIndex]));
    await player.setVolume(0.0); 
    await player.resume();

    for (double i = 0.0; i <= 1.0; i += 0.01) {
      await player.setVolume(i);
      // await Future.delayed(const Duration(milliseconds: 120));
    }

    setState(() {
      isPlaying = true;
    });
  }

  Future<void> playPreviousSong() async {
    if (currentSongIndex > 0) {
      currentSongIndex--;
    } else {
      currentSongIndex = playlist.length - 1; 
    }

    log("Playing previous song with crossfade: ${playlist[currentSongIndex]}");

    await player.setSource(AssetSource(playlist[currentSongIndex]));
    await player.setVolume(0.0); 
    await player.resume();

    for (double i = 0.0; i <= 1.0; i += 0.01) {
      await player.setVolume(i);
      // await Future.delayed(const Duration(milliseconds: 120));
    }

    setState(() {
      isPlaying = true;
    });
  }

  void playSelectedSong(String songName, String songPath) async {
  await player.stop();
  await player.setSource(AssetSource(songPath));
  await player.setVolume(0.0);
  await player.resume();

  for (double i = 0.0; i <= 1.0; i += 0.01) {
    await player.setVolume(i);
    // await Future.delayed(const Duration(milliseconds: 120));
  }

  setState(() {
    isPlaying = true;
    value = 0;
    duration = null;
    currentSongIndex = playlist.indexOf(songPath);
  });
}


  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            height: 300.0,
            width: 300.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/army_fond2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.asset(
                "assets/image${currentSongIndex + 1}.png",
                width: 250.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              songNames[currentSongIndex],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
              const SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(value / 60).floor()}:${(value % 60).floor()}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 260.0,
                    child: Slider.adaptive(
                      onChangeEnd: (new_value) async {
                        setState(() {
                          value = new_value;
                        });
                        await player.seek(Duration(seconds: new_value.toInt()));
                      },
                      min: 0.0,
                      value: value,
                      max: duration != null ? duration!.inSeconds.toDouble() : 214.0,
                      onChanged: (double newValue) {
                        setState(() {
                          value = newValue;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                  ),
                  Text(
                    "${duration != null ? duration!.inMinutes : 0}:${duration != null ? duration!.inSeconds % 60 : 0}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 60.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.purple),
                    ),
                    width: 55.0,
                    height: 55.0,
                    child: ElevatedButton(
                      onPressed: () {
                        playPreviousSong();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                        elevation: 0.0, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.fast_rewind_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.purple),
                    ),
                    width: 60.0,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isPlaying) {
                          await player.pause();
                        } else {
                          await player.resume();
                        }
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                        elevation: 0.0, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.purple),
                    ),
                    width: 55.0,
                    height: 55.0,
                    child: ElevatedButton(
                      onPressed: () {
                        playNextSong();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                        elevation: 0.0, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.fast_forward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongListScreen(playSelectedSong: playSelectedSong),
            ),
          );
        },
        focusColor: Colors.purple,
        backgroundColor: const Color.fromARGB(255, 98, 27, 110),
        child: const Icon(Icons.music_note_rounded),
      ),
    );
  }
}