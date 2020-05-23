import 'dart:convert';

import 'package:entertainmentworld/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'service.dart';
import 'config.dart';
import 'package:paging/paging.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'genere.dart';
var index = 0;

class BottomNavigationBarClass  extends StatefulWidget {
  final type;
  BottomNavigationBarClass(this.type);
  @override
  bottomNavigationBarState createState() => bottomNavigationBarState(this.type);
}

class bottomNavigationBarState extends State<BottomNavigationBarClass> {
  final type;
  bottomNavigationBarState(this.type);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      onTap: (int val) async {
        setState(() {
          index = val;
        });
        final apiKey = api_key;
        var url = "";
        var title = "";
        print(val);
        switch(val) {
          case 1: url = "https://api.themoviedb.org/3/" + type +"/top_rated?language=en-US&api_key=" + apiKey;
                  title = "Trending";
          break;
          case 3: url = "https://api.themoviedb.org/3/discover/" +type + "?language=hi-IN&region=IN&sort_by=popularity.desc&page=1&with_original_language=hi&api_key=" + apiKey;
                  title = "Hindi";
          break;
          case 2: url = "https://api.themoviedb.org/3/search/" + type + "?api_key=" + apiKey;
                  title = "Search";
          break;
        };
        if(val == 0) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => MyApp(),
          ));
        }
        else if(val != 2) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => BottomClass(url, title, type),
          ));
        }
        else {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchMovieClass(url, title, type),
          ));
        }
      },
      items: [
        BottomNavigationBarItem(
            title: Text("Home"),
            icon: Icon(Icons.home)
        ),
        BottomNavigationBarItem(
            title: Text("Trending"),
            icon: Icon(Icons.trending_up)
        ),
        BottomNavigationBarItem(
          title: Text("Search"),
          icon: Icon(Icons.search),
        ),
        BottomNavigationBarItem(
          title: Text("Hindi"),
          icon: Icon(Icons.movie),
        ),
      ],
    );
  }
}

class BottomClass extends StatefulWidget {
  final url;
  final title;
  final type;
  BottomClass(this.url, this.title, this.type);
  @override
  _bottomClass createState()  =>  _bottomClass(url, title, type);
}

class _bottomClass extends State<BottomClass> {
  final url;
  final tital;
  final type;
  _bottomClass(this.url, this.tital, this.type);
  int page = 1;
  // mocking a network call
  Future<List<dynamic>> pageData(int previousCount) async {
    var urlData = url + '&page=' + page.toString();
    print(urlData);
    print(page);
    var respons = await http.get(urlData);
    //print(json.decode(respons.body));
    var responsData = Movie.fromJson(json.decode(respons.body));
    print(responsData.movie.length);
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
    print('baba babab');
    print(dummyList);
    return dummyList;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: type == 'tv' ? Text((tital + " Series")) : Text((tital + " Movies")),
      ),
      body: Pagination(
          pageBuilder: (currentListSize) => pageData(currentListSize),
          itemBuilder: (item,data) => data.length != 0 ? Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Card(
              color: Colors.blue,
              child: ListTile(
                onTap: () {
                  print("000000000000");
                  print(data.length);
                  //var response = getImage(data['poster_path']);
                  var url = 'http://image.tmdb.org/t/p/w185/' + data['poster_path'];
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MovieBody(data, url, type),
                  ));
                },
                title: type == 'tv' ? Text(data['name'], textAlign: TextAlign.center,) :
                        Text(data['title'], textAlign: TextAlign.center,),
              ),
            ),
          )
              :
              Card(
                color: Colors.blue,
                child: ListTile(title: Text('anwar baba',),),
              )
      ),
      bottomNavigationBar: BottomNavigationBarClass(this.type),
    );
  }
}

class SearchMovieClass extends StatelessWidget {
  var url;
  final title;
  final type;
  SearchMovieClass(this.url, this.title, this.type);
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  clearTextInput() {
    name.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: type == 'tv' ? Text('Search Series') : Text('Search Movie'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: name,
              decoration: InputDecoration(labelText: type == 'tv' ? "Tv Series Name" : "Movie Name"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            RaisedButton(
              color: Color(256),
              onPressed: () async {
                var newUrl = url;
                if (_formKey.currentState.validate()) {
                  newUrl = newUrl + "&query=";
                  var splittedString = name.text.split(" ");
                  for(var i = 0; i< splittedString.length -1; i++) {
                    newUrl = newUrl + splittedString[i] + "%20";
                  }
                  newUrl = newUrl + splittedString[splittedString.length -1];
                  print("baba---------");
                  print(newUrl);
                  clearTextInput();
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => BottomClass(newUrl, title, type),
                  ));
                }
              },
              child: Text("Search"),
            ),
          ],
        ),
      )
    );
  }

}