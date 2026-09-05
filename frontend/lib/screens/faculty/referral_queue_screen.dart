import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferralQueueScreen extends ConsumerWidget {
  const ReferralQueueScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Queue'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Referral Queue'),
      ),
    );
  }
}
