import 'package:material_ui/material_ui.dart';

import 'app/theme/app_spacing.dart';

class HomeView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppSpacing spacing = theme.extension() ?? .standard();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: .all(spacing.lg),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Example of a home view headline',
              style: theme.textTheme.headlineSmall,
            ),
            SizedBox(height: spacing.md),
            Text(
              'Example of a home view body text.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
