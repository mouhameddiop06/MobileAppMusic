import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:music_rema_app/Models/musics.dart';
import 'package:music_rema_app/Screens/Music_details.dart';

class App extends StatelessWidget {
  const App();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music App"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: getMusic(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(
                color: const Color.fromARGB(255, 17, 116, 26),
                size: 100.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, position) {
                return oneRowMusic(context, snapshot.data![position]);
              },
            );
          } else {
            return const Center(child: Text('Aucune donnée disponible'));
          }
        },
      ),
    );
  }

  Widget oneRowMusic(BuildContext context, Music music) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicDetailsScreen(music: music),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        elevation: 3,
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: Hero(
            tag: music.preview,
            child: CircleAvatar(
              backgroundImage: NetworkImage(music.imageMusic),
              radius: 30,
            ),
          ),
          title: Text(
            music.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(music.artistName),
              Text(
                music.albumTitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          trailing: const Icon(
            Icons.play_arrow,
            color: Color.fromARGB(255, 17, 116, 26),
            size: 30,
          ),
        ),
      ),
    );
  }

  Future<List<Music>> getMusic() async {
    var response = await http.get(
      Uri.parse("https://api.deezer.com/search?q=OmzoDollar"),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur de chargement : ${response.statusCode}');
    }
    List<Music> allMusic = [];

    var responseJSON = jsonDecode(response.body);
    var data = responseJSON["data"];

    for (var onemusic in data) {
      var artistName = onemusic["artist"]["name"];
      var title = onemusic["title"];
      var albumTitle = onemusic["album"]["title"];
      var previewUrl = onemusic["preview"];
      var imageMusic = onemusic["artist"]["picture_medium"];
      Music music = Music(
        artistName,
        title,
        albumTitle,
        previewUrl,
        imageMusic,
      );
      allMusic.add(music);
    }
    return allMusic;
  }
}
