import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(new MaterialApp(
  home: new HomePage(),
));

class HomePage extends StatefulWidget {
  @override 
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  final String url = "http://192.168.1.122:8000/ec1_sessions";
  List data;

  @override
  void initState(){
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async{
    var response = await http.get(
      Uri.encodeFull(url),
      headers: {"Accept":"application/json"}
    );
    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson;
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Liste des sessions Ec1"),
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return new Container(
            child: new Center(
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Card(
                      child: new Container(
                        child: new Text(data[index]['name'].toString(),
                        ),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    ),
                    new Card(
                      child: new Container(
                        child: new Text(data[index]['status'].toString(),
                        ),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    ),
                    new Card(
                      child: new Container(
                        child: new Text(data[index]['field']['name'].toString(),
                        ),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    )
                  ],
              ),
            ),
          );
        },
      ),
    );
  }
}