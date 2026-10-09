import 'package:material_ui/material_ui.dart';

import 'app/theme/app_theme.dart';
import 'home_view.dart';

class AppWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light, // switch to ThemeMode.system later
      home: const HomeView(),
    );
  }
}