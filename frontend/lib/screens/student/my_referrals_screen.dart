import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyReferralsScreen extends ConsumerWidget {
  const MyReferralsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Referrals'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('My Referrals'),
      ),
    );
  }
}
