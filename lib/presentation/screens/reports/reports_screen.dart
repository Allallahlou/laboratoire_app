import 'package:flutter/material.dart';
import '../../../presentation/widgets/custom_app_bar.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Rapports'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Generation de Rapports PDF',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
