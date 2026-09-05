# Motion Tab Bar v2

[![pub package](https://img.shields.io/pub/v/motion_tab_bar_v2)](https://pub.dev/packages/motion_tab_bar_v2)
[![likes](https://img.shields.io/pub/likes/motion_tab_bar_v2)](https://pub.dev/packages/motion_tab_bar_v2/score)
[![popularity](https://img.shields.io/pub/popularity/motion_tab_bar_v2)](https://pub.dev/packages/motion_tab_bar_v2/score)
[![pub points](https://img.shields.io/pub/points/motion_tab_bar_v2)](https://pub.dev/packages/motion_tab_bar_v2/score)

A highly customizable, animated bottom navigation bar for Flutter apps. The active tab icon animates into place with a smooth motion effect, and colors, sizes, icons, labels and badges are fully customizable.

Built with **Flutter 3** and **null-safety** support.

## Features

- 🎬 Animated tab bar with a smooth "motion" indicator that slides to the selected tab
- 🎨 Fully customizable colors, sizes and text styles
- 🖼️ Custom icons via `IconData` or custom widgets (`iconWidgets`)
- 🔔 Badges / notification indicators (built-in `MotionBadgeWidget` or any custom widget)
- 🎯 Programmatic tab navigation via `MotionTabBarController`
- 📱 Safe area support
- 🏷️ Option to always show tab labels (`labelAlwaysVisible`)

## Preview

### v0.3.0+ — programmatic tab changes

![0.3.x screenshot, example with programmatically change tabs](https://github.com/kimmanwky/Motion-Tab-Bar/blob/master/screenshots/screenshot3.png?raw=true)

### v0.2.x

![0.2.x screenshot](https://github.com/kimmanwky/Motion-Tab-Bar/blob/master/screenshots/screenshot2.png?raw=true)

### v0.1.x animation preview

![MotionTabBar Gif](https://github.com/kimmanwky/Motion-Tab-Bar/blob/master/screenshots/motiontabbar.gif?raw=true)

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  motion_tab_bar_v2: ^3.0.0
```

## Basic Usage

### 1. Import the package

```dart
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

// optional, only if using the provided badge style
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';

// optional, only if using "MotionTabBarController" to programmatically change the tab
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
```

### 2. Create a controller

Use a `MotionTabBarController` (instead of a plain `TabController`) if you need to change the selected tab programmatically:

```dart
class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();

    //// Use normal tab controller
    // _tabController = TabController(
    //   initialIndex: 1,
    //   length: 4,
    //   vsync: this,
    // );

    //// use "MotionTabBarController" to replace with "TabController", if you need to programmatically change the tab
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();

    // _tabController.dispose();
    _motionTabBarController!.dispose();
  }
}
```

### 3. Add MotionTabBar to the Scaffold

```dart
bottomNavigationBar: MotionTabBar(
  controller: _motionTabBarController, // ADD THIS if you need to change your tab programmatically
  initialSelectedTab: "Home",
  useSafeArea: true, // default: true, apply safe area wrapper
  labelAlwaysVisible: true, // default: false, set to "true" if you need to always show labels
  labels: const ["Dashboard", "Home", "Profile", "Settings"],

  //// use default icon (with IconData)
  // icons: const [
  //   Icons.dashboard,
  //   Icons.home,
  //   Icons.people_alt,
  //   Icons.settings,
  // ],

  // use custom widget as display Icon
  iconWidgets: [
    _generateCustomIcon('<svgString>'),
    _generateCustomIcon('<svgString>'),
    _generateCustomIcon('<svgString>'),
    _generateCustomIcon('<svgString>'),
  ],

  // optional badges, length must be same with labels
  badges: [
    // Default Motion Badge Widget
    const MotionBadgeWidget(
      text: '99+',
      textColor: Colors.white, // optional, default to Colors.white
      color: Colors.blue, // optional, default to Colors.red
      size: 18, // optional, default to 18
    ),

    // custom badge Widget
    Container(
      color: Colors.black,
      padding: const EdgeInsets.all(2),
      child: const Text(
        '48',
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    ),

    // allow null
    null,

    // Default Motion Badge Widget with indicator only
    const MotionBadgeWidget(
      isIndicator: true,
      color: Colors.blue, // optional, default to Colors.red
      size: 5, // optional, default to 5,
      show: true, // true / false
    ),
  ],
  tabSize: 50,
  tabBarHeight: 55,
  textStyle: const TextStyle(
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  ),
  // tabIconColor: Colors.blue[600],
  tabIconSize: 28.0,
  tabIconSelectedSize: 32.0,
  tabSelectedColor: Colors.white,
  tabIconSelectedColor: Colors.black,
  tabBarColor: Colors.orange,
  onTabItemSelected: (int value) {
    setState(() {
      _motionTabBarController!.index = value;
    });
  },
),
```

### 4. Add a TabBarView to the Scaffold body

```dart
body: TabBarView(
  physics: const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
  // controller: _tabController,
  controller: _motionTabBarController,
  children: <Widget>[
    const Center(
      child: Text("Dashboard"),
    ),
    const Center(
      child: Text("Home"),
    ),
    const Center(
      child: Text("Profile"),
    ),
    const Center(
      child: Text("Settings"),
    ),
  ],
),
```

### 5. Change tabs programmatically

```dart
ElevatedButton(
  // set MotionTabBarController index to new tab index
  onPressed: () => _motionTabBarController.index = 0,
  child: const Text('Dashboard Page'),
),
ElevatedButton(
  // set MotionTabBarController index to new tab index
  onPressed: () => _motionTabBarController.index = 1,
  child: const Text('Home Page'),
),
```

## Parameters

### MotionTabBar

| Parameter | Type | Default | Description |
|---|---|---|---|
| `initialSelectedTab` | `String` | — (required) | Label of the tab selected when the widget is first built. Must be one of `labels`. |
| `labels` | `List<String?>` | — (required) | Labels of the tabs. Length must match `icons` / `iconWidgets`. |
| `icons` | `List<IconData>?` | `null` | Icons for each tab. Mutually exclusive with `iconWidgets`; either one must be provided. |
| `iconWidgets` | `List<Widget>?` | `null` | Custom widgets used as tab icons. Mutually exclusive with `icons`; either one must be provided. |
| `badges` | `List<Widget?>?` | `null` | Badges shown on each tab. Length must match `labels`; entries may be `null` to hide a badge. |
| `controller` | `MotionTabBarController?` | `null` | Controller used to change the selected tab programmatically. |
| `onTabItemSelected` | `Function?` | `null` | Callback invoked when a tab is selected, receiving the index of the selected tab. |
| `tabIconColor` | `Color?` | `Colors.black` | Color of the unselected tab icons. |
| `tabIconSelectedColor` | `Color?` | `Colors.white` | Color of the selected tab icon (inside the floating indicator). |
| `tabIconSize` | `double?` | `24` | Size of the unselected tab icons. |
| `tabIconSelectedSize` | `double?` | `24` | Size of the selected tab icon. |
| `tabSelectedColor` | `Color?` | `Colors.black` | Background color of the floating indicator circle. |
| `tabBarColor` | `Color?` | `Colors.white` | Background color of the tab bar. |
| `tabBarHeight` | `double?` | `65` | Height of the tab bar. |
| `tabSize` | `double?` | `60` | Size of the floating indicator circle. |
| `textStyle` | `TextStyle?` | `TextStyle(color: Colors.black)` | Text style applied to the tab labels. |
| `useSafeArea` | `bool` | `true` | Whether to wrap the tab bar in a `SafeArea`. |
| `labelAlwaysVisible` | `bool` | `false` | Whether tab labels are always visible. When `false`, only the selected tab's label is shown. |

### MotionBadgeWidget

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `String?` | `null` | Badge text (at most 3 characters). |
| `isIndicator` | `bool?` | `false` | When `true`, renders a plain indicator dot instead of a text badge. |
| `color` | `Color?` | `Colors.red` | Background color of the badge. |
| `textColor` | `Color?` | `Colors.white` | Color of the badge text. |
| `size` | `double?` | `18` (or `5` for indicator) | Size of the badge. |
| `disabled` | `bool?` | `false` | When `true`, renders the badge in a dimmed style. |
| `show` | `bool?` | `true` | When `false`, hides the badge. |

### MotionTabBarController

`MotionTabBarController` extends Flutter's `TabController` and adds a callback so the `MotionTabBar` animates to the new tab when its `index` is changed programmatically.

| Member | Type | Description |
|---|---|---|
| `index` (setter) | `int` | Sets the current tab index and notifies the `MotionTabBar` to animate to the new tab. |
| `onTabChange` (setter) | `Function(int)?` | Callback invoked when the tab index changes. Used internally by `MotionTabBar`. |

## Example

A complete, runnable example app is available in the [`example/`](example/) folder (and a full multi-platform app in [`example_app/`](example_app/)). It demonstrates:

- Custom icon widgets via `iconWidgets` (SVG icons)
- Badges with `MotionBadgeWidget` and custom widgets
- Programmatic tab changes via `MotionTabBarController`

Run it with:

```bash
cd example
flutter run
```

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an [issue](https://github.com/kimmanwky/Motion-Tab-Bar/issues) or submit a [pull request](https://github.com/kimmanwky/Motion-Tab-Bar/pulls).

## License

[MIT](LICENSE)
