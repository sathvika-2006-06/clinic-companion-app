import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferralDetailScreen extends ConsumerWidget {
  final String referralId;

  const ReferralDetailScreen({required this.referralId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Details'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Referral Details: $referralId'),
      ),
    );
  }
}
