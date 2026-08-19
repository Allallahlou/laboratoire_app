import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../presentation/providers/stock_provider.dart';
import '../../../presentation/widgets/custom_app_bar.dart';

class StockScreen extends ConsumerWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockAsync = ref.watch(stockProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Stock'),
      body: stockAsync.when(
        data: (items) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 4,
          itemBuilder: (context, index) {
            final isLow = index == 1 || index == 3;
            return Card(
              color: isLow ? Colors.red.shade50 : null,
              child: ListTile(
                leading: Icon(
                  isLow ? Icons.warning : Icons.inventory_2,
                  color: isLow ? Colors.red : AppColors.stock,
                ),
                title: Text(['Tubes EDTA', 'Reactif Glucose', 'Lames Microscope', 'Pipettes'][index]),
                subtitle: Text(['150 unites', '8 flacons', '200 boites', '45 boites'][index]),
                trailing: isLow
                    ? Chip(
                        label: const Text('Alerte', style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red,
                      )
                    : const Icon(Icons.check_circle, color: Colors.green),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
