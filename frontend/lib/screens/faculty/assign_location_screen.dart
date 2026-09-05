import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignLocationScreen extends ConsumerWidget {
  final String referralId;

  const AssignLocationScreen({required this.referralId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Location'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Assign Location for: $referralId'),
      ),
    );
  }
}
