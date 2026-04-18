import 'dart:math';
import 'package:flutter/material.dart';

/// A calming breathing circle animation with pulsing rings.
class BreathingAnimation extends StatefulWidget {
  final Color color;

  const BreathingAnimation({super.key, required this.color});

  @override
  State<BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _rotateController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Breathing: scale in/out over 6 seconds
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // Slow rotation
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _breathController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: AnimatedBuilder(
        animation: Listenable.merge([_breathController, _rotateController]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // ── Outer ring 3 ──
              Transform.scale(
                scale: _scaleAnimation.value * 1.3,
                child: Transform.rotate(
                  angle: _rotateController.value * 2 * pi,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.color
                            .withOpacity(_opacityAnimation.value * 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              // ── Outer ring 2 ──
              Transform.scale(
                scale: _scaleAnimation.value * 1.15,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color
                          .withOpacity(_opacityAnimation.value * 0.4),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              // ── Outer ring 1 ──
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color
                        .withOpacity(_opacityAnimation.value * 0.15),
                    border: Border.all(
                      color: widget.color
                          .withOpacity(_opacityAnimation.value * 0.5),
                      width: 2,
                    ),
                  ),
                ),
              ),
              // ── Core circle ──
              Transform.scale(
                scale: _scaleAnimation.value * 0.8,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        widget.color.withOpacity(0.6),
                        widget.color.withOpacity(0.2),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            widget.color.withOpacity(_opacityAnimation.value * 0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
