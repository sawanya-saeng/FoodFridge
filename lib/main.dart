import 'package:flutter/material.dart';
import 'Pages/LoginPage.dart';
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
        home: login_page(),
        debugShowCheckedModeBanner: false,
      ),
    )
  );
}
