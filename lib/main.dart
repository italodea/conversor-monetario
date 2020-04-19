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
	void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
		bitcController.text = "";
  }
  void _realToAll(String text) {
		if(text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dolarController.text = ((real / dolar).toStringAsFixed(2));
    bitcController.text = (real / bitcoin).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);

  }
  void _dolarToAll(String text) {
		if(text.isEmpty) {
      _clearAll();
      return;
    }

    double dollar = double.parse(text);
    realController.text = (dollar * this.dolar).toStringAsFixed(2);
    euroController.text = (dollar * this.dolar/euro).toStringAsFixed(2);
    bitcController.text = (dollar * this.dolar/bitcoin).toStringAsFixed(3);

  }

  void _euroToAll(String text) {
		if(text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro/dolar).toStringAsFixed(2);
    bitcController.text = (euro * this.euro/bitcoin).toStringAsFixed(3);

  }

  void _bitcToAll(String text) {
		if(text.isEmpty) {
      _clearAll();
      return;
    }

    double bitcoin = double.parse(text);
    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
    euroController.text = (bitcoin * this.bitcoin/euro).toStringAsFixed(2);
    dolarController.text = (bitcoin * this.bitcoin/dolar).toStringAsFixed(2);
		
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
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    bitcoin =
                        snapshot.data["results"]["currencies"]["BTC"]["buy"];
                    peso = snapshot.data["results"]["currencies"]["ARS"]["buy"];
                    libra =
                        snapshot.data["results"]["currencies"]["GBP"]["buy"];

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
													buildCardResult(Colors.green[800],"Real Brasileiro",'BR',"R\$ ",realController, _realToAll),
													buildCardResult(Colors.red[800],"Dolár Americano",'EUA',"US\$",dolarController, _dolarToAll),
													buildCardResult(Colors.blue[900],"Euro",'UE'," € ",euroController, _euroToAll),
													buildCardResult(Colors.orange,"Bitcoin",'BTC',"BTC",bitcController, _bitcToAll),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildCardResult(Color color, String titulo, String img, String prefix, TextEditingController controller, Function functionConverter) {
  return Container(
    height: 140.0,
		margin: EdgeInsets.only(top:30),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
				BoxShadow(
					color: Colors.grey,
					blurRadius: 2.0
				)
			]
		),
    child: Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
							width: 150.0,
              child: Text(
                titulo,
								textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18.0,
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
                  image: AssetImage('assets/images/$img.png'),
                )
							),
            ),
          ],
        ),

        //divisor feito com container
        Container(
          height: 100.0,
          width: 1.0,
          color: Colors.grey,
          margin: const EdgeInsets.only(left: 6.0, right: 14.0),
        ),

				Expanded(
					child: Container(
						child: TextField(
							controller: controller,
							onChanged: functionConverter,
							keyboardType: TextInputType.number,
							style: TextStyle(
								
								color: Colors.white,
								fontSize: 38.0
							),
							cursorColor: Colors.white,
							
							decoration: InputDecoration(
						
								prefix: Text(prefix),
								prefixStyle: TextStyle(
									color: Colors.white,
									fontSize: 38.0
								),
								border: InputBorder.none,
                hintText: "0,00",
                hintStyle: TextStyle(
									color: Colors.grey[400],
									fontSize: 38.0
								)
							),
						),
					),
				)
      ],
    ),
  );
}
