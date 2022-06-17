import 'package:flutter/material.dart';
import 'package:mywallet/src/utils/colors.dart';

class CustomTheme {
  static final ThemeData themeDark = ThemeData.dark().copyWith(
      backgroundColor: const Color(colorBGDark),
      scaffoldBackgroundColor: const Color(colorBGDark),
      appBarTheme: const AppBarTheme(backgroundColor: Color(colorFGDark)),
      cardTheme: const CardTheme(color: Color(colorFGDark)),
      drawerTheme: const DrawerThemeData(backgroundColor: Color(colorFGDark)),
      dialogTheme: const DialogTheme(backgroundColor: Color(colorFGDark)),
      dialogBackgroundColor: const Color(colorFGDark),
      colorScheme: ColorScheme.fromSwatch(),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Color(colorFGDark)));
}
