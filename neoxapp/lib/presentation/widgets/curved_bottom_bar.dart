import 'package:flutter/material.dart';
// //import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta/meta.dart';
import 'package:neoxapp/core/constants.dart';
import 'package:neoxapp/core/widget.dart';
import 'package:neoxapp/main.dart';

import '../../core/theme_color.dart';
import 'custom_image_view.dart';
import 'nav_button.dart';
import 'nav_custom_painter.dart';

typedef _LetIndexPage = bool Function(int value);

class CurvedNavigationBar extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final int index;
  final int selectedIndex;
  final Color color;
  final Color? buttonBackgroundColor;
  final Color backgroundColor;
  final ValueChanged<int>? onTap;
  final _LetIndexPage letIndexChange;
  final Curve animationCurve;
  final Duration animationDuration;
  final double height;

  CurvedNavigationBar({
    Key? key,
    required this.items,
    required this.selectedItems,
    this.index = 0,
    this.color = Colors.white,
    required this.selectedIndex,
    this.buttonBackgroundColor,
    this.backgroundColor = Colors.white,
    this.onTap,
    _LetIndexPage? letIndexChange,
    this.animationCurve = Curves.easeOut,
    this.animationDuration = const Duration(milliseconds: 600),
    this.height = 80,
  })  : letIndexChange = letIndexChange ?? ((_) => true),
        assert(items != null),
        assert(items.length >= 1),
        assert(0 <= index && index < items.length),
        assert(0 <= height && height <= 85),
        super(key: key);

  @override
  CurvedNavigationBarState createState() => CurvedNavigationBarState();
}

class CurvedNavigationBarState extends State<CurvedNavigationBar> with SingleTickerProviderStateMixin {
  late double _startingPos;
  int _endingIndex = 0;
  late double _pos;
  late int selectedPos;
  double _buttonHide = 0;
  late Widget _icon;
  late AnimationController _animationController;
  late int _length;

  @override
  void initState() {
    super.initState();
    _icon = CustomImageView(
      svgPath: widget.items[widget.index],
      color: AppColors.primaryColor,
    );
    // _icon = widget.items[widget.index];
    _length = widget.items.length;
    _pos = widget.index / _length;
    selectedPos = widget.selectedIndex;
    _startingPos = widget.index / _length;
    _animationController = AnimationController(vsync: this, value: _pos);
    _animationController.addListener(() {
      setState(() {
        _pos = _animationController.value;
        final endingPos = _endingIndex / widget.items.length;
        final middle = (endingPos + _startingPos) / 2;
        if ((endingPos - _pos).abs() < (_startingPos - _pos).abs()) {
          _icon = CustomImageView(
            svgPath: widget.items[_endingIndex],
            color: AppColors.primaryColor,
          );
        }
        _buttonHide = (1 - ((middle - _pos) / (_startingPos - middle)).abs()).abs();
      });
    });
  }

  @override
  void didUpdateWidget(CurvedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      final newPosition = widget.index / _length;
      _startingPos = _pos;
      _endingIndex = widget.index;
      _animationController.animateTo(newPosition, duration: widget.animationDuration, curve: widget.animationCurve);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double customHeight = widget.height;

    print("widget==${widget.selectedIndex}");
    return Material(
      elevation: 0,
      // color: widget.selectedIndex==2?AppColors.primaryColor:Colors.transparent,
      color: Colors.transparent,

      child: Container(
        height: widget.height,

        // decoration: BoxDecoration(
        //    color: Colors.blue
        // ),

        color: Colors.transparent,
        // color: widget.selectedIndex==2?AppColors.primaryColor:Colors.transparent,

        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Positioned(
              bottom: -40 - (customHeight - widget.height),
              left: Directionality.of(context) == TextDirection.rtl ? null : _pos * size.width,
              right: Directionality.of(context) == TextDirection.rtl ? _pos * size.width : null,
              width: size.width / _length,
              child: Center(
                child: Transform.translate(
                  offset: Offset(
                    0,
                    -(1 - _buttonHide) * 80,
                  ),
                  // child: Material(
                  //   color: Colors.white,
                  //   // color: widget.buttonBackgroundColor ?? widget.color,
                  //   type: MaterialType.circle,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: _icon,
                  //   ),
                  // ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0 - (customHeight - widget.height),
              child: CustomPaint(
                painter: NavCustomPainter(_pos, _length, AppColors.getCardColor(context), Directionality.of(context)),
                child: Container(
                  height: customHeight,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0 - (customHeight - widget.height),
              child: SizedBox(
                  height: customHeight,
                  child: Row(
                      children: List.generate(
                          widget.items.length,
                          (index) => NavButton(
                              onTap: (value) {
                                selectedPos = value;
                                widget.onTap!(value);
                              },
                              position: _pos,
                              length: _length,
                              index: index,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomImageView(
                                    svgPath: widget.items[index],
                                    color: widget.selectedIndex == index
                                        ? themeController.isDarkMode
                                            ? Colors.white
                                            : AppColors.primaryColor
                                        : Color(
                                            0xff91ADFF,
                                          ),
                                    height: 28,
                                    width: 28,
                                  ),
                                  getCustomFont(
                                    widget.selectedItems[index],
                                    10,
                                    widget.selectedIndex == index ? AppColors.getFontColor(context) : Colors.transparent,
                                    1,
                                  )
                                ],
                              ))))),
            ),
          ],
        ),
      ),
    );
  }

  void setPage(int index) {
    _buttonTap(index);
  }

  void _buttonTap(int index) {
    if (!widget.letIndexChange(index)) {
      return;
    }
    if (widget.onTap != null) {
      widget.onTap!(index);
    }
    final newPosition = index / _length;
    setState(() {
      _startingPos = _pos;
      _endingIndex = index;
      _animationController.animateTo(newPosition, duration: widget.animationDuration, curve: widget.animationCurve);
    });
  }
}
