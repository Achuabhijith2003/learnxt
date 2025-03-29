import 'package:flutter/material.dart';
import "app_color.dart";

ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColor.bodyColorDark, // Set Scaffold background
    hintColor: AppColor.textColor,
    colorScheme: ColorScheme.dark(
        primary: AppColor.buttonBackgroundColorDark,
        surface: AppColor.bodyColorDark,
    ),
    textTheme:const TextTheme(
        displayLarge: TextStyle(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: Colors.white,
        ),
    ),
    inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: AppColor.textColor),
    )
);