import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'dart:math' as math;

class FlareRateController extends FlareController {
  // FlutterActorArtboard _artboard;
  ActorAnimation _rateAnimation;

  double _slidePercent = 0.0;
  double _currentSlide = 0.0;
  double _smoothTime = 5;

  void updatePercent(double val) {
    _slidePercent = val;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    if (artboard.name.compareTo('Artboard') == 0) {
      // _artboard = artboard;
      _rateAnimation = artboard.getAnimation('slide');
    }
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if (artboard.name.compareTo('Artboard') == 0) {
      _currentSlide += (_slidePercent - _currentSlide) *
          math.min(
            1,
            elapsed * _smoothTime,
          );
      _rateAnimation.apply(
          _currentSlide * _rateAnimation.duration, artboard, 1);
    }
    return true;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
  }
}
