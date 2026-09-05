/// A single tab item rendered inside a [MotionTabBar].
library motiontabitem;

// The file name uses a hyphen and the animation constants use SCREAMING_SNAKE
// case for backwards compatibility with the public API.
// ignore_for_file: file_names, constant_identifier_names

import 'package:flutter/material.dart';

/// Vertical alignment offset of the icon when the tab is not selected.
const double ICON_OFF = -3;

/// Vertical alignment offset of the icon when the tab is selected.
const double ICON_ON = 0;

/// Vertical alignment offset of the label when the tab is not selected.
const double TEXT_OFF = 3;

/// Vertical alignment offset of the label when the tab is selected.
const double TEXT_ON = 1;

/// Opacity of the icon when the tab is not selected.
const double ALPHA_OFF = 0;

/// Opacity of the icon when the tab is selected.
const double ALPHA_ON = 1;

/// Duration (in milliseconds) of the tab item animations.
const int ANIM_DURATION = 300;

/// A single tab item inside a [MotionTabBar].
///
/// Handles the icon/label animation that happens when the tab becomes
/// selected or unselected. This widget is used internally by [MotionTabBar]
/// and is not intended to be used directly.
class MotionTabItem extends StatefulWidget {
  /// The label of this tab.
  final String? label;

  /// Whether the label is always visible (default: only when selected).
  final bool labelAlwaysVisible;

  /// Whether this tab is currently selected.
  final bool selected;

  /// [TextStyle] applied to the label.
  final TextStyle textStyle;

  /// Callback invoked when the tab is tapped.
  final Function callbackFunction;

  /// Optional badge widget shown on this tab.
  final Widget? badge;

  /// Optional custom widget used as the tab icon.
  final Widget? tabIconWidget;

  /// Optional [IconData] used as the tab icon.
  final IconData? tabIconData;

  /// Color of the (unselected) tab icon.
  final Color? tabIconColor;

  /// Size of the (unselected) tab icon.
  final double? tabIconSize;

  /// Creates a [MotionTabItem].
  const MotionTabItem({
    Key? key,
    required this.label,
    required this.selected,
    required this.textStyle,
    required this.callbackFunction,
    this.labelAlwaysVisible = false,
    this.badge,
    this.tabIconWidget,
    this.tabIconData,
    this.tabIconColor,
    this.tabIconSize = 24,
  }) : super(key: key);

  @override
  State<MotionTabItem> createState() => _MotionTabItemState();
}

class _MotionTabItemState extends State<MotionTabItem> {
  double iconYAlign = ICON_ON;
  double textYAlign = TEXT_OFF;
  double iconAlpha = ALPHA_ON;

  @override
  void initState() {
    super.initState();
    _setIconTextAlpha();
  }

  @override
  void didUpdateWidget(MotionTabItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setIconTextAlpha();
  }

  void _setIconTextAlpha() {
    setState(() {
      iconAlpha = (widget.selected) ? ALPHA_OFF : ALPHA_ON;
      iconYAlign = (widget.selected) ? ICON_OFF : ICON_ON;
      textYAlign = (widget.selected) ? TEXT_ON : TEXT_OFF;
      if (widget.labelAlwaysVisible) {
        iconYAlign = iconYAlign - 1;
        textYAlign = TEXT_ON + 0.3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: AnimatedAlign(
              duration: Duration(milliseconds: ANIM_DURATION),
              alignment: Alignment(0, textYAlign),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: (widget.labelAlwaysVisible || widget.selected)
                    ? Text(
                        widget.label!,
                        style: widget.textStyle,
                        softWrap: false,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      )
                    : Text(''),
              ),
            ),
          ),
          InkWell(
            onTap: () => widget.callbackFunction(),
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: AnimatedAlign(
                duration: Duration(milliseconds: ANIM_DURATION),
                curve: Curves.easeIn,
                alignment: Alignment(0, iconYAlign),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: ANIM_DURATION),
                  opacity: iconAlpha,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      widget.tabIconWidget != null ? widget.tabIconWidget! : _generateDefaultIconButtonWidget(),
                      widget.badge != null
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: widget.badge!,
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _generateDefaultIconButtonWidget() {
    return IconButton(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      padding: EdgeInsets.all(0),
      alignment: Alignment(0, 0),
      icon: Icon(
        widget.tabIconData,
        color: widget.tabIconColor,
        size: widget.tabIconSize,
      ),
      onPressed: () => widget.callbackFunction(),
    );
  }
}
