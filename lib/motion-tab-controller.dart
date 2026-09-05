// The file name uses a hyphen for backwards compatibility with the public
// import path.
// ignore_for_file: file_names

import 'package:flutter/material.dart';

/// A [TabController] that also notifies a [MotionTabBar] when its [index] is
/// changed programmatically.
///
/// Use this instead of a plain [TabController] when you need to change the
/// selected tab from outside the tab bar (e.g. from a button or another
/// widget), so that the tab bar animates to the new tab.
///
/// Example:
/// ```dart
/// final controller = MotionTabBarController(
///   initialIndex: 1,
///   length: 4,
///   vsync: this,
/// );
///
/// // Change the selected tab programmatically:
/// controller.index = 2;
/// ```
class MotionTabBarController extends TabController {
  /// Creates a [MotionTabBarController].
  ///
  /// [length] is the number of tabs and [vsync] is the ticker provider,
  /// usually the owning [State] (which must mix in [TickerProviderStateMixin]
  /// or [SingleTickerProviderStateMixin]).
  MotionTabBarController({
    int initialIndex = 0,
    Duration? animationDuration,
    required int length,
    required TickerProvider vsync,
  }) : super(initialIndex: initialIndex, animationDuration: animationDuration, length: length, vsync: vsync);

  /// Sets the current tab index and notifies the attached [MotionTabBar]
  /// (via [onTabChange]) so it animates to the new tab.
  @override
  set index(int index) {
    super.index = index;
    _changeIndex?.call(index);
  }

  /// Internal callback used by [MotionTabBar] to react to index changes.
  Function(int)? _changeIndex;

  /// Sets the callback invoked whenever the tab index changes.
  ///
  /// This is used internally by [MotionTabBar]; you normally do not need to
  /// set it yourself.
  set onTabChange(Function(int)? fx) {
    _changeIndex = fx;
  }
}
