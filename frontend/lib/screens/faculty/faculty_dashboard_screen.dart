import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FacultyDashboardScreen extends ConsumerWidget {
  const FacultyDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Dashboard'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Faculty Dashboard'),
      ),
    );
  }
}
