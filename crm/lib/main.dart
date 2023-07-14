import 'package:crm/auth/welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/data_model.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => DataModel()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: Welcome());
  }
}
