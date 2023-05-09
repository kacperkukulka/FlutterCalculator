import 'dart:math';

class Onp{
  List<Object> onp = List.empty(growable: true);
  List<String> stack = List.empty(growable: true);
  
  void reset(){
    onp.clear();
    stack.clear();
  }

  void addNumber(double number){
    onp.add(number);
  }

  void addWyraz(String wyraz){
    if(stack.isEmpty){
      stack.add(wyraz);
    }
    else if(priorytet(stack.last) < priorytet(wyraz)){
      stack.add(wyraz);
    }
    else{
      while(stack.isNotEmpty){
        if(priorytet(stack.last) >= priorytet(wyraz)){
          onp.add(stack.removeLast());
        }
        else{
          break;
        }
      }
      stack.add(wyraz);
    }
  }

  //0 to 2 where 2 is highest
  int priorytet(String wyraz){
    if(wyraz == "+" || wyraz == "-"){
      return 0;
    }
    if(wyraz == "*" || wyraz == "/"){
      return 1;
    }
    if(wyraz == "^"){
      return 2;
    }
    return -1;
  }

  double wylicz(){
    List<Object> tempOnp = List.empty(growable: true);

    for(var i in onp){
      tempOnp.add(i);
    }
    for(var i = stack.length-1; i >= 0; i--){
      tempOnp.add(stack[i]);
    }

    List<double> numbersStack = List.empty(growable: true);
    for(var i in tempOnp){
      if(i is double){
        numbersStack.add(i);
      }
      else{
        double number2 = numbersStack.removeLast();
        numbersStack.last = executeWyraz(i as String,numbersStack.last, number2);
      }
    }
    return numbersStack.last;
  }

  double executeWyraz(String wyraz, double number1, double number2){
    switch(wyraz){
      case "+": return number1 + number2;
      case "-": return number1 - number2;
      case "*": return number1 * number2;
      case "/": return number1 / number2;
      case "^": return pow(number1,number2) as double;
      default: return 0;
    }
  }
}