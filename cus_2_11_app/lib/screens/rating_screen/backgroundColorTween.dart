import 'package:flutter/material.dart';

Animatable<Color> backgroundTween = TweenSequence<Color>([
  TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Color(0xFFFCBDE9),
        end: Color(0xFFF8ECBD),
      )),
  TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Color(0xFFF8ECBD),
        end: Color(0xFFF8ECBD),
      )),
  TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Color(0xFFF8ECBD),
        end: Color(0xFFBCFBE4),
      )),
]);
