import 'package:flutter/cupertino.dart';

class Ingredient with ChangeNotifier{
  Map<String, String> ingredients;

  Ingredient(){
    this.ingredients = {};
  }

  setIngredient(ingredients){
    this.ingredients = ingredients;
  }

  Map<String, String> getIngredient(){
    return this.ingredients;
  }
}