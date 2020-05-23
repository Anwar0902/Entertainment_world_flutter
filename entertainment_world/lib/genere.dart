
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'service.dart';
import 'config.dart';
import 'package:paging/paging.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'bottomNavigationBar.dart';
import 'package:youtube_player/youtube_player.dart';

class GenereClass extends StatelessWidget {
  final List genreRecords;
  final type;
  GenereClass(this.genreRecords, this.type);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: type == 'tv' ? Text('TV Series Type') : Text('Movies Type'),
      ),
      body: GenereClassBody(this.genreRecords, this.type),
      bottomNavigationBar: BottomNavigationBarClass(this.type),
    );
  }
}

class GenereClassBody extends StatelessWidget {
  final List genreRecords;
  final type;
  GenereClassBody(this.genreRecords, this.type);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              for(var record in this.genreRecords)
                Card(
                  color: Colors.lightBlueAccent,
                  child: ListTile(
                    onTap: () async {
//                      var url = "https://api.themoviedb.org/3/movie/top_rated?api_key=b3b610a516648016aed5518355a08604&language=en-US&page=1";
//                      var recordData = await service(url);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MovieClass(record, type)
                      ));
                    },
                    title: Text(record['name'], textAlign: TextAlign.center,)
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}

class Genere {
  final List<dynamic> genereItems;
  Genere(this.genereItems);
  factory Genere.fromJson(Map<String, dynamic> json) {
    return Genere(
        json['genres']
    );
  }
}

class MovieClass extends StatefulWidget {
  final record;
  final type;
  MovieClass(this.record, this.type);
  @override
  MoviesBodyClass createState() => MoviesBodyClass(this.record, this.type);
}

class MoviesBodyClass extends State<MovieClass> {
  final record;
  final type;
  MoviesBodyClass(this.record, this.type);
  static const int _COUNT = 10;
  int page = 1;
  // mocking a network call
  Future<List<dynamic>> pageData(int previousCount) async {
    final url = 'https://api.themoviedb.org/3/discover/' + type +'?api_key=b3b610a516648016aed5518355a08604&with_genres=' + this.record['id'].toString() + '&page=' + page.toString();
    print(url);
    var respons = await http.get(url);
    print("---------------------------------");
    var responsData = Movie.fromJson(json.decode(respons.body));
    print(responsData.movie.length);
    print("---------------------------------");
    print(previousCount);
    List dummyList = List();
    if (page < 5) {
      for (int i = previousCount; i < previousCount + responsData.movie.length; i++) {
        dummyList.add(responsData.movie[i-previousCount]);
      }
    }
    setState(() {
      ++page;
    });
    print("@@@@@@@@@@@@@@@");
    print(dummyList);
    return dummyList;
  }
  @override
  Widget build(BuildContext context) {
    print(this.record);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text((this.record['name'])),
      ),
      body: Pagination(
        pageBuilder: (currentListSize) => pageData(currentListSize),
        itemBuilder: (item,data) => Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Card(
            color: Colors.lightBlueAccent,
            child: ListTile(
              onTap: () {
                //var response = getImage(data['poster_path']);
                var url = 'http://image.tmdb.org/t/p/w185/' + data['poster_path'];
                print(url);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MovieBody(data, url, type),
                ));
              },
              title: type == 'tv' ? Text(data['name'], textAlign: TextAlign.center,) :
              Text(data['title'], textAlign: TextAlign.center,)
            ),
          ),
        )
      ),
      bottomNavigationBar: BottomNavigationBarClass(this.type),
    );
  }
}

class Movie {
  final List<dynamic> movie;
  Movie(this.movie);
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        json['results']
    );
  }
}

class MovieBody extends StatelessWidget {
  final movie;
  final url;
  final type;
  MovieBody(this.movie, this.url, this.type);
  @override
  Widget build(BuildContext context) {
    var videoKeyUrl = "https://api.themoviedb.org/3/" + type + "/" + this.movie['id'].toString() + "/videos?api_key=" + api_key;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: type == 'tv' ? Text(this.movie['name']) :
                Text(this.movie['title'])
      ),
      body: MovieBodyBody(this.movie, this.url, this.type, videoKeyUrl),
    );
  }
}

class MovieBodyBody extends StatelessWidget {
  final movie;
  final url;
  final type;
  final videoKeyUrl;
  var videoKey = "";
  MovieBodyBody(this.movie, this.url, this.type, this.videoKeyUrl) {
    asyncFunctionCall();
  }
  asyncFunctionCall() async {
    print('------------@@@@@@@@@@@@');
    var response = await getVideoKey(videoKeyUrl);
    for(var data in  response) {
      if(data['type'] == 'Trailer') {
        videoKey = data['key'];
        break;
      }
    }
    //print(respons);
  }
  @override
  Widget build(BuildContext context) {
    print(this.movie);
    var imdb = this.movie['vote_average'];
    var releaseDate =  this.type == 'tv' ?  this.movie['first_air_date'] : this.movie['release_date'];
    var description = this.movie['overview'];
    var language = this.movie['original_language'];
    var title = this.type == 'tv' ? this.movie['name'] : this.movie['title'];

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          FadeInImage.memoryNetwork(placeholder: kTransparentImage,
              height: 412,
              width: 412,
              image: url,
              fit: BoxFit.cover,
            ),
          Divider(),
          Card(
            color: Colors.blue,
            child: ListTile(
              onTap: () {
                var videoUrl = "https://www.youtube.com/watch?v=" + videoKey;
                print(videoUrl);
                LaunchUrl(videoUrl);
              },
                title: Text("Trailer", textAlign: TextAlign.center,),
                subtitle: Text("Click to watch Trailer", textAlign: TextAlign.center,),
            ),
          ),
          Divider(),
          Card(
            child: ListTile(
              title: Text("IMDB : $imdb", textAlign: TextAlign.center,),
            ),
          ),
          Divider(),
          Card(
            child: ListTile(
              title: this.type == 'tv' ? Text("first_air_date : $releaseDate", textAlign: TextAlign.center,) :
                      Text("Release Date : $releaseDate", textAlign: TextAlign.center,),
            ),
          ),
          Divider(),
          Card(
            child: ListTile(
              title: Text("Language : $language", textAlign: TextAlign.center,),
            ),
          ),
          Divider(),
          Card(
            child: ListTile(
              title: Text("Overview", textAlign: TextAlign.center,),
              subtitle: (description != "" && description != null) ? Text("$description", textAlign: TextAlign.center,) :
              Text("$title", textAlign: TextAlign.center,),
            ),
          ),
        ],
      ),
    );
  }
}
// Image.network('http://image.tmdb.org/t/p/w185//2bXbqYdUdNVa8VIWXVfclP2ICtT.jpg'),

Future<dynamic> getImage(poster_path) async {
  final url = 'http://image.tmdb.org/t/p/w185/' + poster_path;
  print(url);
  var response = await http.get(url);
  print(json.decode(response.body));
}

class YoutubePlayer extends StatefulWidget {
  @override
  _youtubePlayer createState() => _youtubePlayer();
}

class _youtubePlayer extends State<YoutubePlayer> {
  VideoPlayerController _videoController;
  String _source = "7QUtEmBT_-w";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Player'),
        centerTitle: true,
      ),
      body: YoutubePlayer(

      )
    );
  }
}