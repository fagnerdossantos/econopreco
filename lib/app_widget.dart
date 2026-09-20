import 'package:flutter/material.dart';

import 'home_view.dart';

class AppWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeView()
    );
  }
}