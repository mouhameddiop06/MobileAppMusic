import 'package:flutter/material.dart';
import 'package:music_rema_app/app.dart';
<<<<<<< HEAD
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 17, 116, 26),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const App(),
    );
  }
=======
void main() async {
  
  runApp(MaterialApp(  
    home:App()
  ));
  
  // var response = await http.get(
  //   Uri.parse("https://api.deezer.com/search?q=DIP"));
  // print(response);
  

>>>>>>> 89c04ca4313be9fce68cfcd74a6291ac3fc4a0db
}
