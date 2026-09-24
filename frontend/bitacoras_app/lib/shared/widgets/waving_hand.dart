import 'dart:math' as math;

import '../exports.dart';


class WavingHand extends StatefulWidget {
  final Color color;
  final double size;
  final Duration duration;

  const WavingHand({
    super.key,
    this.color = Colors.white,
    this.size = 28,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  State<WavingHand> createState() => _WavingHandState();
}

class _WavingHandState extends State<WavingHand>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: math.sin(_controller.value * math.pi) * 0.22,
        alignment: Alignment.bottomCenter,
        child: child,
      ),
      child: Icon(
        Icons.waving_hand_rounded,
        color: widget.color,
        size: widget.size,
      ),
    );
  }
}
