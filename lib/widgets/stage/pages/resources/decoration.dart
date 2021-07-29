import 'package:flutter/material.dart';
import 'package:sid_ui/sid_ui.dart';

DecorationImage Function(String) decorationBuilder(ThemeData theme){
  final brightness = theme.brightness;
  final bkg = brightness.isDark 
    ? theme.canvasColor.withOpacity(0.5)
    : Colors.white.withOpacity(0.75);
  final filter = ColorFilter.mode(bkg, BlendMode.srcOver);

  return (String asset) => DecorationImage(
    colorFilter: filter,
    image: AssetImage(asset),
    alignment: const Alignment(-0.5,0),
    fit: BoxFit.cover,
  );
}
