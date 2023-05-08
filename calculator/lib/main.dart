import 'dart:math';
import 'package:calculator/onp.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String val = "0";
  String equal = "= 0";
  String aktualna = "0";
  bool isEqualOp = false;
  String equalTemp = "";

  Onp onp = Onp();

  List<double> liczby = List.empty(growable: true);
  List<String> operacje = List.empty(growable: true);

  void dodajCyfre(String x){
    if(equalTemp!=""){
      equal = equalTemp;
      equalTemp = "";
    }
    if(isEqualOp){
      aktualna = "0";
      equal = "= 0";
      val = "0";
      isEqualOp = false;
    }
    if(x=="0" && aktualna=="0"){ return; }
    if(x=="." && aktualna.contains(".")){ return; }
    setState(() {
      if(aktualna == "0"){
        aktualna = x;
        if(val[val.length-1] == "0"){
          val = val.substring(0,val.length-1) + x;
        }
      }
      else{
        aktualna += x;
        val += x;
      }
    });
  }

  void dodajWyraz(String x){
    if(equalTemp!=""){
      equal = equalTemp;
      equalTemp = "";
    }
    if(isEqualOp){
      aktualna = equal.substring(2);
      val = equal.substring(2);
      equal = "= 0";
      isEqualOp = false;
    }

    onp.addNumber(double.parse(aktualna));
    onp.addWyraz(x);

    liczby.add(double.parse(aktualna));
    operacje.add(x);
    aktualna = "0";
    setState(() {
      val += " $x 0";
      double first = double.parse(equal.substring(2));
      double second = liczby.last;
      late double wynik;
      if(operacje.length>1){
        switch (operacje[operacje.length-2]) {
          case "+": wynik = first+second; break;
          case "-": wynik = first-second; break;
          case "*": wynik = first*second; break;
          case "/": wynik = first/second; break;
          case "^": wynik = pow(first, second) as double; break;
        }
      }
      else{
        wynik = liczby.last;
      }
      equal = "= ${wynik.toString()}";
    });
  }

  void wylicz(){
    if(equalTemp!=""){
      equal = equalTemp;
      equalTemp = "";
    }
    isEqualOp = true;

    onp.addNumber(double.parse(aktualna));
    onp.equal();

    liczby.add(double.parse(aktualna));
    late double wynik;
    setState(() {
      double first = double.parse(equal.substring(2));
      double second = liczby.last;
      if(operacje.isNotEmpty){
        switch (operacje.last) {
          case "+": wynik = first+second; break;
          case "-": wynik = first-second; break;
          case "*": wynik = first*second; break;
          case "/": wynik = first/second; break;
          case "^": wynik = pow(first, second) as double; break;
        }
      }
      else{
        wynik = liczby.last;
      }
      equal = "= ${wynik.toString()}";
    });
  }

  void konwert(int typ){
    setState((){
      String decimalEqual = equalTemp;
      if(equalTemp==""){
        equalTemp = equal;
        decimalEqual = equal;
      }
      equal = double.parse(decimalEqual.substring(2)).round().toRadixString(typ);
    });
  }

  Flexible fullSizeButton({
    required String text, 
    required void Function()? onPressed}
    ){
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/wood.png'),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: Colors.white38,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: OutlinedButton ( 
          style: OutlinedButton.styleFrom(
            minimumSize: Size.infinite,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            foregroundColor: Colors.white
          ),
          onPressed: onPressed,
          child: Text(text, 
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white
            ),
          ),
        ), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          title: const Text("Calculator"),
          backgroundColor: Colors.black54,
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                margin: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white38,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: const Color.fromARGB(255, 21, 21, 21)
                ),
                child: Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(val, style: const TextStyle(fontSize: 25, color: Colors.white60)),
                      const SizedBox(height: 20,),
                      Text(equal, style: const TextStyle(fontSize: 35, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    fullSizeButton(
                      text: 'Bin',
                      onPressed: (){ konwert(2); }
                    ),
                    const SizedBox(width: 10,),
                    fullSizeButton(
                      text: 'Oct',
                      onPressed: (){ konwert(8); }
                    ),
                    const SizedBox(width: 10,),
                    fullSizeButton(
                      text: 'Hex',
                      onPressed: (){ konwert(16); }
                    ),
                    const SizedBox(width: 10,),
                    fullSizeButton(
                      text: 'His',
                      onPressed: (){}
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Flexible (
                flex: 1,
                child: Row(
                  children: [
                    fullSizeButton(
                      text: 'Num',
                      onPressed: (){ dodajWyraz("^"); }
                    ),
                    const SizedBox(width: 10,),
                    fullSizeButton(
                      text: '*',
                      onPressed: (){ dodajWyraz("*"); }
                    ),
                    const SizedBox(width: 10,),
                    fullSizeButton(
                      text: '/',
                      onPressed: (){ dodajWyraz("/"); }
                    ),
                    const SizedBox(width: 10,),
                    fullSizeButton(
                      text: '-',
                      onPressed: (){ dodajWyraz("-"); }
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Flexible (
                flex: 2,
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                fullSizeButton(text: '7', onPressed: (){ dodajCyfre("7");}),
                                const SizedBox(width: 10,),
                                fullSizeButton(text: '8', onPressed: (){ dodajCyfre("8");}),
                              ]
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Flexible(
                            child: Row(
                              children: [
                                fullSizeButton(text: '4', onPressed: (){ dodajCyfre("4");}),
                                const SizedBox(width: 10,),
                                fullSizeButton(text: '5', onPressed: (){ dodajCyfre("5");}),
                              ]
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                fullSizeButton(text: '9', onPressed: (){ dodajCyfre("9");}),
                                const SizedBox(height: 10,),
                                fullSizeButton(text: '6', onPressed: (){ dodajCyfre("6");}),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          fullSizeButton(
                            text: '+', 
                            onPressed: (){ dodajWyraz("+"); }
                          ),
                        ],
                      )
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Flexible (
                flex: 2,
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                fullSizeButton(text: '1', onPressed: (){ dodajCyfre("1");}),
                                const SizedBox(width: 10,),
                                fullSizeButton(text: '2', onPressed: (){ dodajCyfre("2");}),
                              ]
                            ),
                          ),
                          const SizedBox(height: 10,),
                          fullSizeButton(text: '0', onPressed: (){ dodajCyfre("0");}),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                fullSizeButton(text: '3', onPressed: (){ dodajCyfre("3");}),
                                const SizedBox(height: 10,),
                                fullSizeButton(text: '.', onPressed: (){ dodajCyfre(".");}),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          fullSizeButton(text: '=', onPressed: (){ wylicz();}),
                        ],
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}