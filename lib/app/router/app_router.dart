import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import 'package:cosrent_v2/features/auth/presentation/pages/login_page.dart';
import 'package:cosrent_v2/features/chat/presentation/pages/chat_page.dart';
import 'package:cosrent_v2/features/favorite/presentation/pages/favorite_page.dart';
import 'package:cosrent_v2/features/home/presentation/pages/home_page.dart';
import 'package:cosrent_v2/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cosrent_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cosrent_v2/app/di/injection.dart';

// ============================================================
// APP ROUTES
// ============================================================

abstract final class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const favorite = '/likes';
  static const chat = '/chat';
  static const profile = '/profile';
}

// ============================================================
// NAVIGATION CONFIGURATION
// ============================================================

class _NavItem {
  const _NavItem({
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

const List<_NavItem> _navItems = [
  _NavItem(
    route: AppRoutes.home,
    icon: LineIcons.home,
    label: 'Home',
    page: HomePage(),
  ),
  _NavItem(
    route: AppRoutes.favorite,
    icon: LineIcons.heart,
    label: 'Favorite',
    page: FavoritePage(),
  ),
  _NavItem(
    route: AppRoutes.chat,
    icon: LineIcons.comment,
    label: 'Chat',
    page: ChatPage(),
  ),
  _NavItem(
    route: AppRoutes.profile,
    icon: LineIcons.user,
    label: 'Profile',
    page: ProfilePage(),
  ),
];

// ============================================================
// APP COLORS
// ============================================================

abstract final class _NavColors {
  static const primary = Color(0xFFFF1EF8);
  static const inactive = Color(0xFF5C2020);
  static const border = Color(0xFFEEEEEE);
}

// ============================================================
// GO ROUTER
// ============================================================

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.login,

  routes: [
    // Login Route
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => AuthCubit(Injection.loginUseCase),
          child: const LoginPage(),
        );
      },
    ),

    // Main Application Shell
    ShellRoute(
      builder: (context, state, child) {
        return _MainShell(currentPath: state.uri.path, child: child);
      },

      routes: [
        for (final item in _navItems)
          GoRoute(path: item.route, builder: (context, state) => item.page),
      ],
    ),
  ],
);

// ============================================================
// MAIN SHELL
// ============================================================

class _MainShell extends StatelessWidget {
  const _MainShell({required this.currentPath, required this.child});

  final String currentPath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _navItems.indexWhere(
      (item) => item.route == currentPath,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
      bottomNavigationBar: _BottomNavigation(
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        onTabChange: (index) {
          context.go(_navItems[index].route);
        },
      ),
    );
  }
}

// ============================================================
// BOTTOM NAVIGATION
// ============================================================

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.selectedIndex,
    required this.onTabChange,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _NavColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GNav(
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
            tabs: [
              for (final item in _navItems)
                GButton(icon: item.icon, text: item.label),
            ],
            gap: 8,
            iconSize: 22,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            tabBorderRadius: 12,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            color: _NavColors.inactive,
            activeColor: _NavColors.primary,
            tabBackgroundColor: _NavColors.primary.withValues(alpha: 0.06),
            rippleColor: _NavColors.primary.withValues(alpha: 0.1),
            hoverColor: _NavColors.primary.withValues(alpha: 0.05),
          ),
        ),
      ),
    );
  }
}
