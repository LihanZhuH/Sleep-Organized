import 'package:flutter/material.dart';

/*
  Getter for uniform BoxDecoration used across the app.
 */
BoxDecoration getUniformBoxDecoration(Color color) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [BoxShadow(
      color: Colors.black26,
      offset: Offset(0, 2),
      blurRadius: 2,
    )]
);