/// A highly customizable, animated bottom navigation bar for Flutter apps.
///
/// The active tab icon animates into place with a smooth motion effect.
/// Colors, sizes, labels, icons, badges and text styles are fully
/// customizable.
library motiontabbar;

// The file names use hyphens (e.g. `motion-tab-bar.dart`) for backwards
// compatibility with the public import paths.
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'motion-tab-item.dart';

/// Signature for a callback that builds a widget.
typedef MotionTabBuilder = Widget Function();

/// An animated bottom navigation bar.
///
/// [MotionTabBar] renders a row of tab items with a floating, animated
/// indicator that slides to the currently selected tab. It is designed to be
/// used as the `bottomNavigationBar` of a [Scaffold], paired with a
/// [TabBarView] in the body.
///
/// Example:
/// ```dart
/// MotionTabBar(
///   initialSelectedTab: 'Home',
///   labels: const ['Home', 'Profile'],
///   icons: const [Icons.home, Icons.person],
///   onTabItemSelected: (index) => setState(() {}),
/// )
/// ```
class MotionTabBar extends StatefulWidget {
  /// Color of the unselected tab icons.
  final Color? tabIconColor;

  /// Color of the selected tab icon (shown inside the floating indicator).
  final Color? tabIconSelectedColor;

  /// Background color of the floating indicator circle.
  final Color? tabSelectedColor;

  /// Background color of the tab bar.
  final Color? tabBarColor;

  /// Size of the unselected tab icons.
  final double? tabIconSize;

  /// Size of the selected tab icon (shown inside the floating indicator).
  final double? tabIconSelectedSize;

  /// Height of the tab bar.
  final double? tabBarHeight;

  /// Size of the floating indicator circle.
  final double? tabSize;

  /// [TextStyle] applied to the tab labels.
  final TextStyle? textStyle;

  /// Callback invoked when a tab is selected, receiving the index of the
  /// newly selected tab.
  final Function? onTabItemSelected;

  /// The label of the tab that is selected when the widget is first built.
  /// Must be one of [labels].
  final String initialSelectedTab;

  /// Labels of the tabs. The length must match [icons] / [iconWidgets].
  final List<String?> labels;

  /// Optional [IconData] icons for each tab. Mutually exclusive with
  /// [iconWidgets]; either one must be provided.
  final List<IconData>? icons;

  /// Optional custom widgets used as tab icons. Mutually exclusive with
  /// [icons]; either one must be provided.
  final List<Widget>? iconWidgets;

  /// Whether to wrap the tab bar in a [SafeArea] (default: `true`).
  final bool useSafeArea;

  /// Optional [MotionTabBarController] to change the selected tab
  /// programmatically.
  final MotionTabBarController? controller;

  /// Whether tab labels are always visible. When `false` (default), only the
  /// label of the selected tab is shown.
  final bool labelAlwaysVisible;

  /// Optional badges shown on each tab. The length must match [labels];
  /// entries may be `null` to hide the badge for a specific tab.
  final List<Widget?>? badges;

  /// Creates a [MotionTabBar].
  ///
  /// [initialSelectedTab] must be one of [labels]. Either [icons] or
  /// [iconWidgets] must be provided, with the same length as [labels].
  /// If [badges] is provided, its length must match [labels].
  MotionTabBar({
    Key? key,
    this.textStyle,
    this.tabIconColor = Colors.black,
    this.tabIconSize = 24,
    this.tabIconSelectedColor = Colors.white,
    this.tabIconSelectedSize = 24,
    this.tabSelectedColor = Colors.black,
    this.tabBarColor = Colors.white,
    this.tabBarHeight = 65,
    this.tabSize = 60,
    this.onTabItemSelected,
    required this.initialSelectedTab,
    required this.labels,
    this.icons,
    this.iconWidgets,
    this.useSafeArea = true,
    this.badges,
    this.controller,
    this.labelAlwaysVisible = false,
  })  : assert(labels.contains(initialSelectedTab)),
        assert((icons != null && icons.length == labels.length) ||
            (iconWidgets != null && iconWidgets.length == labels.length)),
        assert((badges != null && badges.isNotEmpty) ? badges.length == labels.length : true),
        super(key: key);

  @override
  State<MotionTabBar> createState() => _MotionTabBarState();
}

class _MotionTabBarState extends State<MotionTabBar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Tween<double> _positionTween;
  late Animation<double> _positionAnimation;

  late AnimationController _fadeOutController;
  late Animation<double> _fadeFabOutAnimation;
  late Animation<double> _fadeFabInAnimation;

  late List<String?> labels;
  Map<String?, IconData>? icons;
  Map<String?, Widget>? iconWidgets;

  /// Number of tabs, derived from [iconWidgets] or [icons].
  int get tabAmount =>
      iconWidgets != null && iconWidgets!.keys.isNotEmpty ? iconWidgets!.keys.length : icons?.keys.length ?? 0;

  /// Index of the currently selected tab.
  int get index => labels.indexOf(selectedTab);

  /// Normalized position of the floating indicator in the range `-1..1`.
  double get position {
    double pace = 2 / (labels.length - 1);
    return (pace * index) - 1;
  }

  double fabIconAlpha = 1;
  IconData? activeIcon;
  Widget? activeIconWidget;
  String? selectedTab;

  List<Widget>? badges;
  Widget? activeBadge;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!.onTabChange = (index) {
        setState(() {
          activeIcon = widget.icons?[index];
          activeIconWidget = widget.iconWidgets?[index];
          selectedTab = widget.labels[index];
        });
        _initAnimationAndStart(_positionAnimation.value, position);
      };
    }

    labels = widget.labels;
    selectedTab = widget.initialSelectedTab;

    if (widget.icons != null && widget.icons!.isNotEmpty) {
      icons = {
        for (final label in labels) label: widget.icons![labels.indexOf(label)],
      };
      activeIcon = icons![selectedTab];
    }

    if (widget.iconWidgets != null && widget.iconWidgets!.isNotEmpty) {
      iconWidgets = {
        for (final label in labels) label: widget.iconWidgets![labels.indexOf(label)],
      };
      activeIconWidget = iconWidgets![selectedTab];
    }

    // init badge text
    int selectedIndex = labels.indexWhere((element) => element == widget.initialSelectedTab);
    activeBadge = (widget.badges != null && widget.badges!.isNotEmpty) ? widget.badges![selectedIndex] : null;

    _animationController = AnimationController(
      duration: Duration(milliseconds: ANIM_DURATION),
      vsync: this,
    );

    _fadeOutController = AnimationController(
      duration: Duration(milliseconds: (ANIM_DURATION ~/ 5)),
      vsync: this,
    );

    _positionTween = Tween<double>(begin: position, end: 1);

    _positionAnimation = _positionTween.animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });

    _fadeFabOutAnimation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _fadeOutController, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          fabIconAlpha = _fadeFabOutAnimation.value;
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            if (icons != null && icons!.isNotEmpty) {
              activeIcon = icons![selectedTab];
            }
            if (iconWidgets != null && iconWidgets!.isNotEmpty) {
              activeIconWidget = iconWidgets![selectedTab];
            }

            int selectedIndex = labels.indexWhere((element) => element == selectedTab);
            activeBadge = (widget.badges != null && widget.badges!.isNotEmpty) ? widget.badges![selectedIndex] : null;
          });
        }
      });

    _fadeFabInAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _animationController, curve: Interval(0.8, 1, curve: Curves.easeOut)))
      ..addListener(() {
        setState(() {
          fabIconAlpha = _fadeFabInAnimation.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.tabBarColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        bottom: widget.useSafeArea,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              height: widget.tabBarHeight,
              decoration: BoxDecoration(
                color: widget.tabBarColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: generateTabItems(),
              ),
            ),
            IgnorePointer(
              child: Align(
                heightFactor: 0,
                alignment: Alignment(_positionAnimation.value, 0),
                child: FractionallySizedBox(
                  widthFactor: 1 / tabAmount,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: widget.tabSize! + 30,
                        width: widget.tabSize! + 30,
                        child: ClipRect(
                          clipper: HalfClipper(),
                          child: Center(
                            child: Container(
                              width: widget.tabSize! + 10,
                              height: widget.tabSize! + 10,
                              decoration: BoxDecoration(
                                color: widget.tabBarColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: widget.tabSize! + 15,
                        width: widget.tabSize! + 35,
                        child: CustomPaint(painter: HalfPainter(color: widget.tabBarColor)),
                      ),
                      SizedBox(
                        height: widget.tabSize,
                        width: widget.tabSize,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.tabSelectedColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Opacity(
                              opacity: fabIconAlpha,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  activeIconWidget != null
                                      ? activeIconWidget!
                                      : Icon(
                                          activeIcon,
                                          color: widget.tabIconSelectedColor,
                                          size: widget.tabIconSelectedSize,
                                        ),
                                  activeBadge != null
                                      ? Positioned(
                                          top: 0,
                                          right: 0,
                                          child: activeBadge!,
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> generateTabItems() {
    return labels.map((tabLabel) {
      // IconData? tabIconData = icons[tabLabel];
      // Widget? tabIconWidget = iconWidgets?[tabLabel];

      int selectedIndex = labels.indexWhere((element) => element == tabLabel);
      Widget? badge = (widget.badges != null && widget.badges!.isNotEmpty) ? widget.badges![selectedIndex] : null;

      return MotionTabItem(
        selected: selectedTab == tabLabel,
        label: tabLabel,
        labelAlwaysVisible: widget.labelAlwaysVisible,
        textStyle: widget.textStyle ?? TextStyle(color: Colors.black),
        tabIconWidget: iconWidgets?[tabLabel],
        tabIconData: icons?[tabLabel],
        tabIconColor: widget.tabIconColor ?? Colors.black,
        tabIconSize: widget.tabIconSize,
        badge: badge,
        callbackFunction: () {
          setState(() {
            activeIcon = icons?[tabLabel];
            activeIconWidget = iconWidgets?[tabLabel];
            selectedTab = tabLabel;
            widget.onTabItemSelected!(index);
          });
          _initAnimationAndStart(_positionAnimation.value, position);
        },
      );
    }).toList();
  }

  void _initAnimationAndStart(double from, double to) {
    _positionTween.begin = from;
    _positionTween.end = to;

    _animationController.reset();
    _fadeOutController.reset();
    _animationController.forward();
    _fadeOutController.forward();
  }
}

/// Clips the top half of a [Rect], used to hide the lower part of the
/// floating indicator circle behind the tab bar.
class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width, size.height / 2);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}

/// Paints the curved "notch" shape that connects the floating indicator
/// circle to the tab bar.
class HalfPainter extends CustomPainter {
  /// Color used to fill the notch shape.
  final Color? color;

  /// Creates a [HalfPainter] with the given [color].
  HalfPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // final Rect beforeRect = Rect.fromLTWH(0, (size.height / 2) - 10, 10, 10);
    // final Rect largeRect = Rect.fromLTWH(10, 0, size.width - 20, 70);
    // final Rect afterRect = Rect.fromLTWH(size.width - 10, (size.height / 2) - 10, 10, 10);

    // final path = Path();

    // path.arcTo(beforeRect, vector.radians(0), vector.radians(90), false);
    // path.lineTo(20, size.height / 2);
    // path.arcTo(largeRect, vector.radians(0), -vector.radians(180), false);
    // path.moveTo(size.width - 10, size.height / 2);
    // path.lineTo(size.width - 10, (size.height / 2) - 10);
    // path.arcTo(afterRect, vector.radians(180), vector.radians(-90), false);

    final double curveSize = 10;
    final double xStartingPos = 0;
    final double yStartingPos = (size.height / 2);
    final double yMaxPos = yStartingPos - curveSize;

    final path = Path();

    path.moveTo(xStartingPos, yStartingPos);
    path.lineTo(size.width - xStartingPos, yStartingPos);
    path.quadraticBezierTo(size.width - (curveSize), yStartingPos, size.width - (curveSize + 5), yMaxPos);
    path.lineTo(xStartingPos + (curveSize + 5), yMaxPos);
    path.quadraticBezierTo(xStartingPos + (curveSize), yStartingPos, xStartingPos, yStartingPos);

    path.close();

    canvas.drawPath(path, Paint()..color = color ?? Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
