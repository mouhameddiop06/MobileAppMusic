import 'package:flutter/material.dart';
import 'package:music_rema_app/Models/musics.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicDetailsScreen extends StatefulWidget {
  final Music music;

  const MusicDetailsScreen({Key? key, required this.music}) : super(key: key);

  @override
  State<MusicDetailsScreen> createState() => _MusicDetailsScreenState();
}

class _MusicDetailsScreenState extends State<MusicDetailsScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Configurer les écouteurs pour l'AudioPlayer
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // Formatage de la durée pour l'affichage
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de la musique"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // Image de la musique
            Hero(
              tag: widget.music.preview,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(widget.music.imageMusic),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Informations sur la musique
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    widget.music.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.music.artistName,
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Album: ${widget.music.albumTitle}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),

                  // Contrôle de lecture
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                    },
                    activeColor: const Color.fromARGB(255, 17, 116, 26),
                    inactiveColor: Colors.grey[300],
                  ),

                  // Affichage du temps de lecture
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(position)),
                        Text(formatTime(duration)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Boutons de contrôle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await audioPlayer.seek(
                            Duration(seconds: position.inSeconds - 10),
                          );
                        },
                        icon: const Icon(Icons.replay_10),
                        iconSize: 40,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.play(
                              UrlSource(widget.music.preview),
                            );
                          }
                        },
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: const Color.fromARGB(255, 17, 116, 26),
                        ),
                        iconSize: 80,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () async {
                          await audioPlayer.seek(
                            Duration(seconds: position.inSeconds + 10),
                          );
                        },
                        icon: const Icon(Icons.forward_10),
                        iconSize: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
