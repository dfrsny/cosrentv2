import 'package:cosrent_v2/features/auth/presentation/pages/login_page.dart';
import 'package:cosrent_v2/features/chat/presentation/pages/chat_page.dart';
import 'package:cosrent_v2/features/favorite/presentation/pages/favorite_page.dart';
import 'package:cosrent_v2/features/home/presentation/pages/home_page.dart';
import 'package:cosrent_v2/features/profile/presentation/pages/profile_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

// ---------------------------------------------------------------------------
// Routes
// ---------------------------------------------------------------------------

abstract final class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const favorite = '/likes';
  static const chat = '/chat';
  static const profile = '/profile';
}

// ---------------------------------------------------------------------------
// Bottom navigation configuration
// ---------------------------------------------------------------------------

class _NavTab {
  const _NavTab({
    required this.route,
    required this.icon,
    required this.label,
    required this.page,
  });

  final String route;
  final IconData icon;
  final String label;
  final Widget page;
}

const _tabs = <_NavTab>[
  _NavTab(
    route: AppRoutes.home,
    icon: LineIcons.home,
    label: 'Home',
    page: HomePage(),
  ),
  _NavTab(
    route: AppRoutes.favorite,
    icon: LineIcons.heart,
    label: 'Favorite',
    page: FavoritePage(),
  ),
  _NavTab(
    route: AppRoutes.chat,
    icon: LineIcons.comment,
    label: 'Chat',
    page: ChatPage(),
  ),
  _NavTab(
    route: AppRoutes.profile,
    icon: LineIcons.user,
    label: 'Profile',
    page: ProfilePage(),
  ),
];

abstract final class _NavStyle {
  static const ink = Color.fromARGB(255, 255, 30, 248);
  static const muted = Color.fromARGB(255, 92, 32, 32);
  static const border = Color(0xFFEEEEEE);
}

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) =>
          _MainShell(currentPath: state.uri.path, child: child),
      routes: [
        for (final tab in _tabs)
          GoRoute(path: tab.route, builder: (context, state) => tab.page),
      ],
    ),
  ],
);

// ---------------------------------------------------------------------------
// Shell
// ---------------------------------------------------------------------------

class _MainShell extends StatelessWidget {
  const _MainShell({required this.currentPath, required this.child});

  final String currentPath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final index = _tabs.indexWhere((tab) => currentPath.startsWith(tab.route));

    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
      bottomNavigationBar: _BottomNav(
        selectedIndex: index < 0 ? 0 : index,
        onTabChange: (index) => context.go(_tabs[index].route),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.selectedIndex, required this.onTabChange});

  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _NavStyle.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GNav(
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
            tabs: [
              for (final tab in _tabs) GButton(icon: tab.icon, text: tab.label),
            ],
            gap: 8,
            iconSize: 22,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            tabBorderRadius: 12,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            color: _NavStyle.muted,
            activeColor: _NavStyle.ink,
            tabBackgroundColor: _NavStyle.ink.withValues(alpha: 0.06),
            rippleColor: const Color.fromARGB(255, 255, 30, 248),
            hoverColor: const Color.fromARGB(255, 255, 30, 248),
          ),
        ),
      ),
    );
  }
}
