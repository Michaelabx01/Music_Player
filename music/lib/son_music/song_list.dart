import 'dart:ui';
import 'package:flutter/material.dart';

class SongListScreen extends StatefulWidget {
  final Function(String, String) playSelectedSong;

  SongListScreen({Key? key, required this.playSelectedSong}) : super(key: key);

  @override
  _SongListScreenState createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  int _selectedSongIndex = -1;

  final List<String> playlist = [
    "zamona-net-bts-black-swan.mp3",
    "zamona-net-bts-yet-to-come.mp3",
    "zamona-net-bts-standing-next-to-you.mp3",
    "With-You-Jimin-X-Ha-Sung-Woon.mp3",
    "╣µ┼║╝Ê│Ô┤▄-01-Intro_ Serendipity.mp3",
    "╣µ┼║╝Ê│Ô┤▄-02-DNA.mp3",
    "╣µ┼║╝Ê│Ô┤▄-03-Best-Of-Me.mp3",
    "╣µ┼║╝Ê│Ô┤▄-04-║©┴Â░│.mp3",
    "╣µ┼║╝Ê│Ô┤▄-05-Pied Piper.mp3",
    "╣µ┼║╝Ê│Ô┤▄-06-Skit  Billboard Music Awards Speech.mp3",
    "╣µ┼║╝Ê│Ô┤▄-07-MIC Drop.mp3",
    "╣µ┼║╝Ê│Ô┤▄-08-░Ý╣╬║©┤┘ Go.mp3",
    "╣µ┼║╝Ê│Ô┤▄-09-Outro_ Her.mp3",
    // Agrega el resto de tus canciones aquí
  ];

  final List<String> songNames = ["Black Swan", "Yet to Come", "Standing Next to You", "With You", "Intro Serendipity", "DNA", "Best Of Me", "Dimple", "Pied Piper", "Skit Billboard Music Awards Speech", "MIC Drop", "Go", "Outro Her"];

  final List<String> songImages = [
    "assets/image1.png",
    "assets/image2.png",
    "assets/image3.png",
    "assets/image4.png",
    "assets/image5.png",
    "assets/image6.png",
    "assets/image7.png",
    "assets/image8.png",
    "assets/image9.png",
    "assets/image10.png",
    "assets/image11.png",
    "assets/image12.png",
    "assets/image13.png",
    // Agrega el resto de tus imágenes aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Music'),
        backgroundColor: Colors.purple,
      ),
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
          ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedSongIndex = index;
                  });
                  widget.playSelectedSong(songNames[index], playlist[index]);
                },
                splashColor: Colors.purple, // Color del efecto al toque
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(songImages[index]),
                  ),
                  title: Text(
                    songNames[index],
                    style: TextStyle(
                      color: _selectedSongIndex == index
                          ? Colors.purple
                          : Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    playlist[index],
                    style: TextStyle(
                      color: _selectedSongIndex == index
                          ? Colors.purple
                          : Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
