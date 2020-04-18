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

  final defaultController = TextEditingController();
  final realController = TextEditingController();
  final euroController = TextEditingController();
  final dolarController = TextEditingController();
  final bitcController = TextEditingController();

  double dolar;
  double euro;
  double bitcoin;
  double peso;
  double libra;

  String dropdownValue = 'BRL';

  void _realToAll(String text){
    double real = double.parse(text);
    dolarController.text = "US\$"+((real/dolar).toStringAsFixed(2));
    bitcController.text = "BTC\$"+(real/bitcoin).toStringAsFixed(2);
    euroController.text = "€\$"+(real/euro).toStringAsFixed(2);
    realController.text = "\$"+(real/1).toStringAsFixed(2);
  }

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
                height: 70,
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
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];
                    peso = snapshot.data["results"]["currencies"]["ARS"]["buy"];
                    libra = snapshot.data["results"]["currencies"]["GBP"]["buy"];

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
                                        fontSize: 28.0,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey, blurRadius: 2.0)
                                ]),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    child: DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.brown),
                                  underline: Container(
                                    height: 0,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                      if (newValue == "BRL"){
                                      }
                                    });
                                  },
                                  items: <String>["BRL", 'USD', 'EUR', 'BTC']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )),
                                Expanded(
                                  child: Container(
                                    child: TextField(
                                      controller: defaultController,
                                      keyboardType: TextInputType.number,
                                      onChanged: _realToAll,
                                      style: TextStyle(
                                        
                                          fontSize: 20.0, 
                                          color: Colors.brown
                                          ),
                                      decoration: InputDecoration(
                                        
                                          border: InputBorder.none,
                                          hintText: '0,00',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                          ),
                          buildCardResult(
                              "Real Brasileiro",
                              "R\$",
                              Colors.green[900],
                              'BR.png',
                              "Libras",
                              "£",
                              Colors.amber,
                              'UK.png',
                              realController,
                              bitcController,),Padding(
                            padding: EdgeInsets.only(top: 30),
                          ),
                          buildCardResult(
                              "Dólar Americano",
                              "US\$",
                              Colors.red[700],
                              'EUA.png',
                              "Bitcoin",
                              "BTC",
                              Colors.amber,
                              'BTC.png',
                              dolarController,
                              bitcController),
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                          ),
                          buildCardResult(
                              "Euro",
                              "€",
                              Colors.blue[900],
                              'UE.png',
                              "Real Brasileiro",
                              "\$",
                              Colors.lightBlue[600],
                              'BR.png',
                              euroController,
                              realController),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildCardResult(
  String title1,
  String prefix1,
  Color color1,
  String logo1,
  String title2,
  String prefix2,
  Color color2,
  String logo2,
  TextEditingController c1,
  TextEditingController c2
) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: color1,
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: EdgeInsets.all(5.0),
          height: 220.0,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 7.0),
                child: Text(
                  "$title1",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/$logo1'),
                    )),
              ),
              Container(
                margin: EdgeInsets.only(top: 23.0),
                child: TextFormField(
                  
                  controller: c1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    prefixStyle: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: color2,
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: EdgeInsets.all(5.0),
          height: 220.0,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 7.0),
                child: Text(
                  "$title2",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/$logo2'),
                    )),
              ),
              Container(
                margin: EdgeInsets.only(top: 23.0),
                child: TextFormField(
                  controller: c2,
                  
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
