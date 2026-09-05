## [3.0.0] - 05-Sep-2026
* [NEW] add documentation comments to all public APIs
* [NEW] add unit & widget tests
* [NEW] add GitHub Actions CI workflow
* [NEW] add `analysis_options.yaml` with `flutter_lints`
* [FIX] fix dartdoc library name conflict between `motion-tab-bar.dart` and `motion-tab-controller.dart`
* [FIX] remove unused `vector_math` dependency
* [FIX] make `example/` a standalone runnable example
* [FIX] update `example_app` to latest SDK & lints
* [DOC] rewrite README with full parameter documentation

## [0.4.0] - 12-Feb-2025
* [NEW] add `iconWidgets` parameter to support custom icon widget
* [NEW] add `labelAlwaysVisible` parameter to allow label always showing
* updated example with new custom icon widget

## [0.3.0] - 13-July-2023
* add new "MotionTabBarController" to programmatically control tab change
* updated example

## [0.2.6] - 8-March-2022
* change "title" - softwarp: false, maxLines: 1

## [0.2.5] - 3-November-2021
* MotionTabBar add "useSafeArea" parameters. Default: true
* Enlarge tab items press-able area

## [0.2.4] - 3-August-2021

* MotionBadgeWidget add 'show'(boolean) parameters

## [0.2.3] - 26-July-2021

* minor animation bug fix

## [0.2.2] - 26-July-2021

* minor animation bug fix
* use default tabController, removed MotionTabController/MotionTabView (outdated)

## [0.2.1] - 26-July-2021


* added badge support:
    * default `MotionBadgeWidget` provided
    * custom widget allowed

## [0.2.0] - 23-July-2021


* Update to support null-safety
* added new parameters:
    * tabBarHeight (double)
    * tabBarColor (Colors)
    * tabSize (double)
    * tabIconSize (double)
    * tabIconSelectedSize (double)
    * tabIconSelectedColor (Colors)

## [0.1.5] - 07-07-2020.

* Remove extra space from top of tab bar.

## [0.1.4] - 01-07-2020.

* Tab Item Dynamic. Now you can use multiple tab.
* Tab Item Animation Delay fix

## [0.1.3] - 23-06-2020.

* Controller Issue fix.
* Tab Item Animation Delay fix

## [0.1.2] - 15-06-2020.

* Fix Initial Index Issue.
* Fix Initial Tab Selected Issue.

## [0.1.0] - 07-06-2020.

* Initial release.
* Tab menu with interaction design.
* An animated Bottom Navigation Bar for Flutter apps, icon animates into place, colors are customizable.
