import 'package:flutter/cupertino.dart';

class Ingredient with ChangeNotifier{
  Map<String, String> ingredients;
  List<Map<String, String>> ingredientList;

  Ingredient(){
    this.ingredients = {};
    this.ingredientList = [];
  }

  setIngredient(ingredients){
    this.ingredients = ingredients;
  }

  setIngredients(ingredients){
    this.ingredientList = ingredients;
  }

  Map<String, String> getIngredient(){
    return this.ingredients;
  }

  List<Map<String, String>> getIngredients(){
    return this.ingredientList;
  }
}