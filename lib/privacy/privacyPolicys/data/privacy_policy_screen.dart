import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/privacy_policy_bloc.dart';
import '../bloc/privacy_policy_state.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  final String? titles;
  const PrivacyPolicyScreen({super.key, this.titles});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titles=="Terms"?"Terms & Conditions":"Privacy Policy")),
      body: BlocBuilder<PrivacyPolicyBloc, PrivacyPolicyState>(
        builder: (context, state) {
          if (state is PrivacyPolicyLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PrivacyPolicyLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                state.policy.content,
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
            );
          }

          if (state is PrivacyPolicyError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
