import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:music_rema_app/Models/musics.dart';

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
                return oneRowMusic(snapshot.data![position]);
              },
            );
          } else {
            return const Center(child: Text('Aucune donnée disponible'));
          }
        },
      ),
    );
  }

  Widget oneRowMusic(Music music) {
    return GestureDetector(
      onTap: () {
        //print("Hello");
        debugPrint("Hello");
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(music.imageMusic),
          radius: 80,
        ),
        title: Text(music.title),
        subtitle: Text(music.albumTitle),
        trailing: Icon(Icons.play_arrow),
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

  













// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:http/http.dart' as http;

// class App extends StatelessWidget {
//   const App() ;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: getMusic(),
//         builder:(context,snapshot){// snapshot juste nom d'une variable 
//           if (snapshot.connectionState == ConnectionState.waiting)
//           {
//             return Center(
//               child: SpinKitCircle(
//                       color: const Color.fromARGB(255, 17, 116, 26),
//                       size: 100.0,
//                     ),
//             );
//           }
//           else if(snapshot.hasError){
//             return Center(
//               child: Text("${snapshot.error}"),
//             );
//           }
//           else {
//             return Text("${snapshot.data}");
//           }

//           // else {
//           //   List<String> titres = snapshot.data as List<String>;
//           //   return ListView.builder(
//           //     itemCount: titres.length,
//           //     itemBuilder: (context, index) {
//           //       return ListTile(
//           //         title: Text(titres[index]),
//           //       );
//           //     },
//           //   );
//           // }

//         }
//       ),
//     );
//   }

//    Future<String> getMusic() async {
//      var response = await http.get(
//     Uri.parse(
//       "https://api.deezer.com/search?q=dipdoundeguiss"
//     ));

//     var responseJSON = jsonDecode(response.body);
//     var nomArtiste = responseJSON["data"][12]["artist"]["name"];
//     var nomSon = responseJSON ["data"][12]["title"];
//     var nomAlbum = responseJSON ["data"][12]["album"]["title"];

//   return "Artiste: $nomArtiste\nSon: $nomSon\nAlbum: $nomAlbum";
//   }

//   // Future<List<String>> getMusic() async {
//   //   var response = await http.get(
//   //     Uri.parse("https://api.deezer.com/search?q=dipdoundeguiss"),
//   //   );

//   //   if (response.statusCode != 200) {
//   //     throw Exception('Erreur de chargement : ${response.statusCode}');
//   //   }

//   //   var responseJSON = jsonDecode(response.body);
//   //   List<dynamic> tracks = responseJSON["data"];

//   //   List<String> titres = [];
//   //   for (int i = 0; i < tracks.length; i++) {
//   //     String titre = tracks[i]["title"];
//   //     titres.add("[$i] $titre");
//   //   }

//   //   return titres;
//   // }

// }