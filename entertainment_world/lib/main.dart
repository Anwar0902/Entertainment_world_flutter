import 'package:flutter/material.dart';
import 'genere.dart';
import 'service.dart';
import 'config.dart';
import 'bottomNavigationBar.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Entertainment World',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Entertainment World'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
//        backgroundColor: Colors.transparent,
        title: Text(widget.title),
      ),
      body: Center(
        child: HomePageBody()
      ),
      );
  }
}

class HomePageBody extends StatelessWidget {
  static String apiKey = api_key;
  static String movieUrl = "https://api.themoviedb.org/3/genre/movie/list?api_key=" + apiKey +"&language=en-US&page=1";
  static String TVUrl = "https://api.themoviedb.org/3/genre/tv/list?api_key=" + apiKey +"&language=en-US&page=1";
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top:60,left: 20, right: 20),
          child: Column(
            children: <Widget>[
              Card(
                color: Colors.lightBlueAccent,
                child: ListTile(
                  title: Text('Movies', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                  onTap: () async {
                    var genreRecords = await service(movieUrl);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => GenereClass(genreRecords, "movie")
                    ),
                    );
                  },
                ),
              ),
              Card(
                color: Colors.lightBlueAccent,
                child: ListTile(
                  title: Text('TV Series', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                  onTap: () async {
                    var genreRecords = await service(TVUrl);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => GenereClass(genreRecords, "tv")
                    ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
