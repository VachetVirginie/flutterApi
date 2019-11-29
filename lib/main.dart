import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {  

  MyApp({Key key, quote}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quotes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quote of the Day'),
        ),
        body: Center(
          child: FutureBuilder<Quote>(
            future: getQuote(), //sets the getQuote method as the expected Future
            builder: (context, snapshot) {
              if (snapshot.hasData) { //checks if the response returns valid data              
                return Center(
                  child: Column(
                    children: <Widget>[
                      Text(snapshot.data.name), //displays the name
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(" - ${snapshot.data.terrain}"), //displays the terrain
                      Text(" - ${snapshot.data.quote}"), //displays the status
                      Text(" - ${snapshot.data.duration}"), //displays the duration
                      Text(" - ${snapshot.data.scoreLeft}"), //displays the scoreLeft
                      Text(" - ${snapshot.data.scoreRight}"), //displays the scoreRight
                    ],
                  ),
                );
              } else if (snapshot.hasError) { //checks if the response throws an error
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }


  Future<Quote> getQuote() async {
    String url = 'http://192.168.1.122:8000/ec1_sessions/1';
    final response =
        await http.get(url, headers: {"Accept": "application/json"});


    if (response.statusCode == 200) {
      return Quote.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}

class Quote {
  final int duration;
  final String name;
  final String quote;
  final String scoreLeft;
  final int scoreRight;
  final String terrain;

  

  Quote({this.name, this.terrain, this.quote, this.duration, this.scoreLeft, this.scoreRight});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        name: json['name'],
        terrain: json['field']['name'],
        duration: json['duration'],
        quote: json['status']);
  }
}