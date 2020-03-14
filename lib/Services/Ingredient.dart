import 'package:flutter/cupertino.dart';

class Ingredient with ChangeNotifier {
  Map<String, String> ingredients;
  List<Map<String, dynamic>> ingredientList;

  Ingredient() {
    this.ingredients = {};
    this.ingredientList = [];
  }

  setIngredient(ingredients) {
    this.ingredients = ingredients;
  }

  setIngredients(ingredients) {
    this.ingredientList = ingredients;
  }

  addIngredients(Map<String, dynamic> data) {
    this.ingredientList.add(data);
  }

  removeIngredients(index) {
    this.ingredientList.removeAt(index);
  }

  resetIngredients(){
    this.ingredientList.clear();
  }

  Map<String, String> getIngredient() {
    return this.ingredients;
  }

  List<Map<String, dynamic>> getIngredients() {
    return this.ingredientList;
  }
}
