import 'package:flutter/material.dart';
import 'package:taluewapp/Pages/MainPage.dart';
import 'package:provider/provider.dart';
import 'Services/Ingredient.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Ingredient>.value(value: Ingredient()),
      ],
      child: MaterialApp(
        title: 'FoodFridge',
        theme: ThemeData(
            fontFamily: 'taluewFont'
        ),
        home: main_page(0),
        debugShowCheckedModeBanner: false,
      ),
    )
  );
}
