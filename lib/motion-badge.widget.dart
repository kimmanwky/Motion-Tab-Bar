/// A badge / notification indicator widget for use with [MotionTabBar].
///
/// Can display a text badge (e.g. "99+") or a plain indicator dot.
library motionbadgewidget;

import 'package:flutter/material.dart';

/// A small badge or indicator dot shown on a tab.
///
/// By default it renders a red circle with white text. Set [isIndicator] to
/// `true` to render a plain dot without text.
///
/// Example:
/// ```dart
/// const MotionBadgeWidget(
///   text: '99+',
///   color: Colors.blue,
/// )
/// ```
class MotionBadgeWidget extends StatelessWidget {
  /// Creates a [MotionBadgeWidget].
  ///
  /// [text] is the badge text (at most 3 characters). When [isIndicator] is
  /// `true`, a plain dot is rendered instead of a text badge. [color] and
  /// [textColor] control the badge and text colors, [size] controls the
  /// badge size, [disabled] dims the badge, and [show] toggles visibility.
  const MotionBadgeWidget({
    Key? key,
    bool? isIndicator,
    this.text,
    Color? textColor,
    double? size,
    Color? color,
    bool? disabled,
    bool? show,
  })  : _isIndicator = isIndicator ?? false,
        _color = color ?? Colors.red,
        _textColor = textColor ?? Colors.white,
        _size = size ?? (isIndicator == true ? 5 : 18),
        _disabled = disabled ?? false,
        _show = show ?? true,
        assert(text != null ? text.length <= 3 : true),
        super(key: key);

  /// Whether to render a plain indicator dot instead of a text badge.
  final bool? _isIndicator;

  /// The badge text (at most 3 characters).
  final String? text;

  /// Background color of the badge.
  final Color? _color;

  /// Color of the badge text.
  final Color? _textColor;

  /// Size of the badge.
  final double? _size;

  /// Whether the badge is rendered in a dimmed (disabled) style.
  final bool? _disabled;

  /// Whether the badge is visible.
  final bool? _show;

  @override
  Widget build(BuildContext context) {
    return _show == true && _isIndicator == true
        ? Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(3),
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: _disabled == false ? _color : _color!.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(_size! / 2),
            ),
            constraints: BoxConstraints(
              minWidth: _size!,
              minHeight: _size!,
            ),
          )
        : _show == true && text != null && text != ''
            ? Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: _disabled == false ? _color : _color!.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(_size! / 2),
                ),
                constraints: BoxConstraints(
                  minWidth: _size!,
                  minHeight: _size!,
                ),
                child: Text(
                  '$text',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: _size != null ? (_size! / 2) : 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : Container();
  }
}
