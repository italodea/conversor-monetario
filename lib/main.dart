import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=00bb4207";

void main() async {
  runApp(MaterialApp(home: Home()));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          title: Text("\$ Conversor de moedas \$"),
          backgroundColor: Colors.grey[900],
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapShot) {
              switch (snapShot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Carregando dados...",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapShot.hasError) {
                    return Center(
                        child: Text("Erro ao carregar dados",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                            textAlign: TextAlign.center));
                  } else {
                    return Container(color: Colors.grey[800]);
                  }
              }
            }));
  }
}
