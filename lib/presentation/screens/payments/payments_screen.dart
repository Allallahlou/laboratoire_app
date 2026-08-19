import 'package:flutter/material.dart';
import '../../../presentation/widgets/custom_app_bar.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Paiements'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Gestion des Paiements',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
