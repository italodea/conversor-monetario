import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/painting.dart';

const request = "https://api.hgbrasil.com/finance?format=json&key=00bb4207";

void main() async {
  runApp(MaterialApp(
    home: Home(),
		theme: ThemeData(fontFamily: 'Baloo Paaji 2'),
  ));
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
  double dolar;
  double euro;
  String dropdownValue = 'BRL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Image.asset(
                 'assets/images/logo.png',
                  fit: BoxFit.contain,
                  height: 44,
              ),
            ],

          ),
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Carregando dados...",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Erro ao carregar dados",
                            style:
                                TextStyle(color: Colors.black, fontSize: 25.0),
                            textAlign: TextAlign.center));
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: 80.0,
                                  margin: EdgeInsets.all(25.0),
                                  color: Colors.white,
                                  child: Text("Conversor de moedas",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
																				fontSize: 22.0,
																			)
																		),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
														decoration: BoxDecoration(
															color: Colors.white,
															borderRadius: BorderRadius.circular(10),
															boxShadow:[
																BoxShadow(
																	color: Colors.grey,
																	blurRadius: 2.0
																)
															]
														),
                            child:Row(
                            children: <Widget>[
                              Container(
                                child: DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
																		fontSize: 20.0,
                                    color: Colors.brown
                                  ),
                                  underline: Container(
                                    height: 0,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                  items: <String>["BRL", 'USD', 'EUR', 'BTC']
                                    .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    })
                                    .toList(),
                                )
                              ),
                              Expanded(
                                child: Container(
                                  child: TextField(
																		style: TextStyle(
																			fontSize: 20.0,
																			color: Colors.brown
																		),
                                    decoration: InputDecoration(
																			
                                      border: InputBorder.none,
                                      hintText: '0,00',
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                    ),
                                  ),
                                ),)
                            ],
                          ),
                          ),
                          Padding(padding: EdgeInsets.only(top:30),),
													Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[700],
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: EdgeInsets.all(5.0),
                                  height: 220.0,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 7.0),
                                        child: Text(
                                          "Dólar americano",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image:DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage('assets/images/EUA.png'),
                                          
                                          )
                                        ),

                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 40.0),
                                        child: Text(
                                          "U\$ 20,00",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 40.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: EdgeInsets.all(5.0),
                                  height: 220.0,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 7.0),
                                        child: Text(
                                          "Bitcoin",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image:DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage('assets/images/BTC.png'),
                                          
                                          )
                                        ),

                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 40.0),
                                        child: Text(
                                          "BTC 21,50",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 40.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
													Padding(padding: EdgeInsets.only(top:30),),
													Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[900],
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: EdgeInsets.all(5.0),
                                  height: 220.0,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 7.0),
                                        child: Text(
                                          "Euro",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image:DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage('assets/images/UE.png'),
                                          
                                          )
                                        ),

                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 40.0),
                                        child: Text(
                                          "€ 10,00",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 40.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green[700],
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: EdgeInsets.all(5.0),
                                  height: 220.0,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 7.0),
                                        child: Text(
                                          "Real Brasileiro",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image:DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage('assets/images/BR.png'),
                                          
                                          )
                                        ),

                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 40.0),
                                        child: Text(
                                          "R\$ 21,50",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 40.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}
