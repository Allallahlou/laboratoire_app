import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../presentation/widgets/custom_app_bar.dart';

class ResultsEntryScreen extends StatelessWidget {
  const ResultsEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Resultats'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fact_check_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Gestion des Resultats',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
