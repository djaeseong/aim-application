import 'package:aim_application/core/app.dart';
import 'package:aim_application/core/injection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await registerServices();
  } catch (e) {
    print('Error initializing services: $e');
  }
  
  runApp(const ProviderScope(child: App()));
}
