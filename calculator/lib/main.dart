import 'dart:math';
import 'package:calculator/onp.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Calculator',
      home: Calculator(),
    );
  }
}

class HistoryScreen extends StatelessWidget{
  const HistoryScreen({Key? key, required this.history}) : super(key: key);

  final List<String> history;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.black54,
      ),
      body: ListView(
        children: history.map((e) => Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 5),
            child: Text(e, style: const TextStyle(color: Colors.white, fontSize: 20),)
          )).toList()
      )
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String val = "0";
  String equal = "= 0";
  String aktualna = "0";
  bool isEqualOp = false;
  String equalTemp = "";
  String wyrazPrev = "";

  Onp onp = Onp();

  List<String> history = List.empty(growable: true);

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
    if(x=="0" && (aktualna=="0" || aktualna=="-0")){ return; }
    if(x=="." && aktualna.contains(".")){ return; }
    setState(() {
      if(aktualna == "0" || aktualna=="-0"){
        if(aktualna[0] == "-"){
          aktualna = "-$x";
        }
        else{
          aktualna = x;
        }
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
    
    if(wyrazPrev!=""){
      onp.addWyraz(wyrazPrev);
    }
    onp.addNumber(double.parse(aktualna));
    wyrazPrev = x;

    aktualna = "0";
    setState(() {
      val += " $x 0";
      double wynik = onp.wylicz();
      equal = "= ${wynik.toString()}";
    });
  }

  void wylicz(){
    if(equalTemp!=""){
      equal = equalTemp;
      equalTemp = "";
    }
    isEqualOp = true;

    if(wyrazPrev != ""){
      onp.addWyraz(wyrazPrev);
    }
    onp.addNumber(double.parse(aktualna));

    setState(() {
      double wynik = onp.wylicz();
      equal = "= ${wynik.toString()}";
    });

    onp.reset();
    wyrazPrev = "";
    history.add("$val $equal");
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

  void historyBtn(){
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
          history: history,
        )
      )
    );
  }

  void changeSign(){
    if(aktualna[0] == "-"){
      aktualna = aktualna.substring(1);
    }
    else{
      aktualna = "-$aktualna";
    }
    int nextNumPos = val.lastIndexOf(' ');
    setState((){
      val = val.substring(0,nextNumPos+1) + aktualna;
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
    return Scaffold(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(val, style: const TextStyle(fontSize: 25, color: Colors.white60)),
                  const SizedBox(height: 20,),
                  Text(equal, style: const TextStyle(fontSize: 35, color: Colors.white)),
                ],
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
                    onPressed: (){ historyBtn(); }
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
                        Flexible(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40,
                                child: Column(
                                  children: [
                                    fullSizeButton(
                                      text: '+/-',
                                      onPressed: (){ changeSign(); }
                                    ),
                                  ]
                                ),
                              ),
                              const SizedBox(height: 10,),
                              fullSizeButton(
                                text: '+', 
                                onPressed: (){ dodajWyraz("+"); }
                              ),
                            ],
                          ),
                        )
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
    );
  }
}