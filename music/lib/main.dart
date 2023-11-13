import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
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
  ];

  List<String> songNames = ["Black Swan", "Yet to Come"];

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
      print("Error: Unable to retrieve duration.");
    }

    // Configure the onPlayerStateChanged event
    player.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        // When the current song is completed, play the next song with crossfade
        playNextSong();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> playNextSong() async {
    if (currentSongIndex < playlist.length - 1) {
      currentSongIndex++;
    } else {
      currentSongIndex = 0; // Loop back to the first song
    }

    print("Playing next song with crossfade: ${playlist[currentSongIndex]}");

    // Start playing the next song with a fade-in effect
    await player.setSource(AssetSource(playlist[currentSongIndex]));
    await player.setVolume(0.0); // Start with volume 0
    await player.resume();
    
    // Gradually increase the volume over a duration of 12 seconds
    for (double i = 0.0; i <= 1.0; i += 0.01) {
      await player.setVolume(i);
      await Future.delayed(const Duration(milliseconds: 120));
    }

    setState(() {
      isPlaying = true;
    });
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
                image: AssetImage("assets/army_fond.jpg"),
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
                  "assets/bts_logo.png",
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
                    "${(value / 60).floor()}: ${(value % 60).floor()}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Container(
                    width: 260.0,
                    child: Slider.adaptive(
                      onChangeEnd: (new_value) async {
                        setState(() {
                          value = new_value;
                          print(new_value);
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
                    "${duration != null ? duration!.inMinutes : 0} : ${duration != null ? duration!.inSeconds % 60 : 0}",
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
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        player.setPlaybackRate(0.5);
                      },
                      onTapUp: (details) {
                        player.setPlaybackRate(1);
                      },
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
                    child: InkWell(
                      onTap: () async {
                        if (isPlaying) {
                          await player.pause();
                        } else {
                          await player.resume();
                          player.onPositionChanged.listen(
                            (Duration d) {
                              setState(() {
                                value = d.inSeconds.toDouble();
                                print(value);
                              });
                            },
                          );
                        }
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
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
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTap: () {
                        playNextSong();
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_forward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
