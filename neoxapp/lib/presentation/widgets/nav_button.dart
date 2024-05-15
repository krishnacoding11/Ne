import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavButton extends StatelessWidget {
  final double position;
  final int length;
  final int index;
  final ValueChanged<int> onTap;
  final Widget child;

  NavButton({
    required this.onTap,
    required this.position,
    required this.length,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final desiredPosition = 1.0 / length * index;
    final difference = (position - desiredPosition).abs();
    final verticalAlignment = 1 - length * difference;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onTap(index);
        },
        child: Container(
            height: 80,
            // child: child,
            child: Transform.translate(
              offset: Offset(0, difference < 1.0 / length ? verticalAlignment * 40 : 0),
              child: Opacity(
                  opacity: 1,
                  // opacity: difference < 1.0 / length * 0.99 ? opacity : 1.0,
                  child: child),
            )),
      ),
    );
  }
}
