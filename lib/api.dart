import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'dart:convert';

var imageapi = 'https://image.tmdb.org/t/p/original';
var apilink = 'https://api.themoviedb.org/3/movie/';
var apikey =
    'api_key=107ed75bf9e25ec06bfe9fd33d042579&fbclid=IwAR1DjafRA247rE2vjo_en2mE0ILwuxMM2-BRWDFhXWY0cIWI2CI45LAbxAU';

class Api {
  int vote_count, id;
  bool video, adult, fav = false;
  num vote_average, popularity, runtime;
  String title,
      poster_path,
      original_language,
      original_title,
      backdrop_path,
      overview,
      key,
      release_date,
      status;
  List<String> genre_ids;
  String category;

  Api(
      {this.vote_count,
      this.id,
      this.video,
      this.vote_average,
      this.title,
      this.popularity,
      this.poster_path,
      this.original_language,
      this.original_title,
      this.genre_ids,
      this.backdrop_path,
      this.adult,
      this.overview,
      this.release_date,
      this.runtime,
      this.status,
      this.key});

  factory Api.fromJson(Map<String, dynamic> json) {
    return Api(
        vote_count: json['vote_count'],
        id: json['id'],
        video: json['video'],
        vote_average: json['vote_average'],
        title: json['title'],
        popularity: json['popularity'],
        poster_path: json['poster_path'],
        original_language: json['original_language'],
        original_title: json['original_title'],
        backdrop_path: json['backdrop_path'],
        adult: json['adult'],
        overview: json['overview'],
        release_date: json['release_date']);
  }

  factory Api.fromJson2(Map<String, dynamic> json) {
    return Api(runtime: json['runtime'], status: json['status'],release_date: json['release_date']);
  }

  factory Api.fromJson3(Map<String, dynamic> json) {
    return Api(genre_ids: json['name']);
  }

  factory Api.fromJson4(Map<String, dynamic> json) {
    return Api(
      key: json['key'],
    );
  }
}

Future<List<Api>> convert(String s) async {
  if (s == "Now Playing")
    s = 'now_playing?';
  else if (s == "Upcoming")
    s = 'upcoming?';
  else if (s == 'Top Rated')
    s = 'top_rated?';
  else if (s == 'Popular') s = 'popular?';
  final response = await http.get(apilink + s + apikey);
  List<Api> request = List<Api>();
  if (response.statusCode == 200) {
    var dat = json.decode(response.body)['results'];
    for (var leaf in dat) {
      request.add(Api.fromJson(leaf));
    }
  } else
    throw Exception('Failed to load');
  return request;
}

Future<Api> convert2(int id) async {
  final response =
      await http.get(apilink + id.toString() + '/videos?' + apikey);
  Api request;
  if (response.statusCode == 200) {
    var dat = json.decode(response.body)['results'];
    for (var leaf in dat) {
      if (leaf['type'] == "Trailer") request = Api.fromJson4(leaf);
    }
  } else
    throw Exception('Failed to load');
  return request;
}

Future<Api> convert3(int id) async {
  final response = await http.get(apilink + id.toString()+'?' + apikey);
  Api request = Api();
  if (response.statusCode == 200) {
    var dat = json.decode(response.body)['genres'];
    for (var leaf in dat) {
      request = Api.fromJson3(leaf);
    }
  } else
    throw Exception('Failed to load');
  return request;
}

Future<Api> convert4(int id) async {
  final response = await http.get(apilink + id.toString()+'?' + apikey);
  Api request = Api();
  if (response.statusCode == 200) {
    var dat = json.decode(response.body);
    request = Api.fromJson2(dat);
  } else
    throw Exception('Failed to load');
  return request;
}
