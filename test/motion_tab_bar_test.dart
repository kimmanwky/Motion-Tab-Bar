import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

void main() {
  const labels = ['Dashboard', 'Home', 'Profile', 'Settings'];
  const icons = [Icons.dashboard, Icons.home, Icons.people_alt, Icons.settings];

  Widget buildTabBar({
    MotionTabBarController? controller,
    bool labelAlwaysVisible = false,
    List<Widget>? iconWidgets,
    List<Widget?>? badges,
    Function(int)? onTabItemSelected,
  }) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: MotionTabBar(
          controller: controller,
          initialSelectedTab: 'Home',
          labelAlwaysVisible: labelAlwaysVisible,
          labels: labels,
          icons: iconWidgets == null ? icons : null,
          iconWidgets: iconWidgets,
          badges: badges,
          onTabItemSelected: onTabItemSelected,
        ),
      ),
    );
  }

  group('MotionTabBar', () {
    testWidgets('renders the selected label by default', (tester) async {
      await tester.pumpWidget(buildTabBar());

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Dashboard'), findsNothing);
    });

    testWidgets('renders all labels when labelAlwaysVisible is true',
        (tester) async {
      await tester.pumpWidget(buildTabBar(labelAlwaysVisible: true));

      for (final label in labels) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('calls onTabItemSelected when a tab is tapped', (tester) async {
      int? selectedIndex;
      await tester.pumpWidget(
          buildTabBar(onTabItemSelected: (index) => selectedIndex = index));

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(selectedIndex, 3);
    });

    testWidgets('renders custom icon widgets', (tester) async {
      await tester.pumpWidget(buildTabBar(iconWidgets: const [
        Icon(Icons.dashboard),
        Icon(Icons.home),
        Icon(Icons.people_alt),
        Icon(Icons.settings),
      ]));

      expect(find.byIcon(Icons.home), findsWidgets);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('renders badges on the matching tab', (tester) async {
      await tester.pumpWidget(buildTabBar(badges: const [
        MotionBadgeWidget(text: '99+'),
        null,
        null,
        null,
      ]));

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('changes the selected tab programmatically via controller',
        (tester) async {
      final controller =
          MotionTabBarController(initialIndex: 1, length: 4, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpWidget(buildTabBar(controller: controller));

      controller.index = 2;
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
    });

    testWidgets('asserts that initialSelectedTab is one of the labels',
        (tester) async {
      expect(
        () => MotionTabBar(
          initialSelectedTab: 'Unknown',
          labels: labels,
          icons: icons,
        ),
        throwsAssertionError,
      );
    });

    testWidgets('asserts that icons or iconWidgets must be provided',
        (tester) async {
      expect(
        () => MotionTabBar(
          initialSelectedTab: 'Home',
          labels: labels,
        ),
        throwsAssertionError,
      );
    });
  });

  group('MotionBadgeWidget', () {
    testWidgets('renders a text badge', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MotionBadgeWidget(text: '99+'))),
      );

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets(
        'renders an indicator dot without text when isIndicator is true',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
            home: Scaffold(body: MotionBadgeWidget(isIndicator: true))),
      );

      expect(find.byType(Text), findsNothing);
    });

    testWidgets('renders nothing when show is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
            home: Scaffold(body: MotionBadgeWidget(text: '99+', show: false))),
      );

      expect(find.text('99+'), findsNothing);
    });
  });
}
