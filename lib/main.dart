import 'package:material_ui/material_ui.dart';
import 'package:cosrent_v2/app/router/app_router.dart';
import 'package:cosrent_v2/app/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // App Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // Router
      routerConfig: router,
    );
  }
}
