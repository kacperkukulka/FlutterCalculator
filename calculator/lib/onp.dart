class Onp{
  List<Object> onp = List.empty(growable: true);
  List<String> stack = List.empty(growable: true);
  
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

  void equal(){
    while(stack.isNotEmpty){
      onp.add(stack.removeLast());
    }
  }

  void clearOnp(){
    onp.clear();
    stack.clear();
  }
}