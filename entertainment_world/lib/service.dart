import 'dart:convert';

import 'package:entertainmentworld/genere.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<List> service(url) async {
  print(url);
  var respons = await http.get(url);
  var genres = Genere.fromJson(json.decode(respons.body));
  print(json.decode(respons.body));
  return (genres.genereItems);
}

Future<List> getVideoKey(url) async {
  print(url);
  var respons = await http.get(url);
  var genres = Movie.fromJson(json.decode(respons.body));
//  print(json.decode(respons.body));
  return genres.movie;
}
Future<dynamic> LaunchUrl(url) async{
  print(url);
  if(await canLaunch(url)) {
    launch(url);
  }
  else {
    print('can`t load $url');
  }
}