import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: MusicScreen()),
  );
}

class Music {
  final String artist;
  final String title;
  final String album;
  final String imageUrl;
  final String previewUrl;

  Music({
    required this.artist,
    required this.title,
    required this.album,
    required this.imageUrl,
    required this.previewUrl,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      artist: json["artist"]["name"],
      title: json["title"],
      album: json["album"]["title"],
      imageUrl: json["album"]["cover_xl"],
      previewUrl: json["preview"],
    );
  }
}

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Music? _music;
  Duration _position = Duration.zero;
  final Duration _previewDuration = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    _loadMusic();

    _audioPlayer.onPositionChanged.listen((pos) {
      setState(() {
        _position = pos;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  Future<void> _loadMusic() async {
    try {
      final response = await http.get(
        Uri.parse("https://api.deezer.com/search?q=FreezeCorleone"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"];
        setState(() {
          _music = Music.fromJson(
            data[0],
          ); // 2->soundgasm, 6->charm, 13->favorite, 16->bounce
        });
      }
    } catch (e) {
      print("Erreur : $e");
    }
  }

  void _togglePlayPause() async {
    if (_music == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(_music!.previewUrl));
    }

    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _music == null
              ? const Center(
                child: SpinKitCircle(color: Color.fromARGB(255, 109, 106, 118)),
              )
              : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 223, 220, 227), Color.fromARGB(255, 222, 109, 16)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              _music!.imageUrl,
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            _music!.title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _music!.artist,
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Album: ${_music!.album}",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Slider(
                            activeColor: Colors.white,
                            inactiveColor: Colors.white24,
                            min: 0,
                            max: _previewDuration.inSeconds.toDouble(),
                            value: _position.inSeconds.toDouble().clamp(
                              0,
                              _previewDuration.inSeconds.toDouble(),
                            ),
                            onChanged: (value) async {
                              final newPos = Duration(seconds: value.toInt());
                              await _audioPlayer.seek(newPos);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatDuration(_position),
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const Text(
                                "00:30",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          IconButton(
                            iconSize: 70,
                            icon: Icon(
                              _isPlaying
                                  ? Icons.pause_circle
                                  : Icons.play_circle_fill,
                              color: Colors.white,
                            ),
                            onPressed: _togglePlayPause,
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
