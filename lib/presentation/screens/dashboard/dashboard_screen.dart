import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/dashboard_provider.dart';
import '../../../presentation/providers/patient_provider.dart';
import '../../../presentation/widgets/dashboard_card.dart';
import '../../../presentation/widgets/custom_app_bar.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardStats = ref.watch(dashboardProvider);
    final patientCount = ref.watch(patientCountProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.dashboard,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      drawer: _buildDrawer(context, ref),
      body: dashboardStats.when(
        data: (stats) => RefreshIndicator(
          onRefresh: () => ref.read(dashboardProvider.notifier).loadStats(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome
                Text(
                  'Bonjour, Admin',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Voici un apercu de votre laboratoire',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                // Stats Cards
                Row(
                  children: [
                    DashboardCard(
                      title: 'Patients',
                      value: patientCount.when(
                        data: (count) => count.toString(),
                        loading: () => '...',
                        error: (_, __) => '0',
                      ),
                      icon: Icons.people_outline,
                      color: AppColors.patient,
                      onTap: () => context.push('/patients'),
                    ),
                    const SizedBox(width: 12),
                    DashboardCard(
                      title: 'Analyses',
                      value: stats.totalDemandes.toString(),
                      icon: Icons.science_outlined,
                      color: AppColors.analyse,
                      onTap: () => context.push('/analyses'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    DashboardCard(
                      title: 'En Cours',
                      value: stats.demandesEnCours.toString(),
                      icon: Icons.pending_actions_outlined,
                      color: AppColors.warning,
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    DashboardCard(
                      title: 'Revenus',
                      value: '${stats.totalRevenus.toStringAsFixed(0)} DH',
                      icon: Icons.attach_money_outlined,
                      color: AppColors.success,
                      onTap: () => context.push('/payments'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Chart
                _buildSectionHeader('Activite Hebdomadaire'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 20,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
                                  return Text(days[value.toInt()], style: const TextStyle(fontSize: 10));
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            _makeBarGroup(0, 8, AppColors.primary),
                            _makeBarGroup(1, 12, AppColors.primary),
                            _makeBarGroup(2, 6, AppColors.primary),
                            _makeBarGroup(3, 15, AppColors.primary),
                            _makeBarGroup(4, 10, AppColors.primary),
                            _makeBarGroup(5, 18, AppColors.primary),
                            _makeBarGroup(6, 4, AppColors.primary),
                          ],
                          gridData: const FlGridData(show: false),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Actions
                _buildSectionHeader('Actions Rapides'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildQuickAction(
                      icon: Icons.person_add,
                      label: 'Nouveau Patient',
                      color: AppColors.patient,
                      onTap: () => context.push('/patients/new'),
                    ),
                    const SizedBox(width: 12),
                    _buildQuickAction(
                      icon: Icons.assignment_add,
                      label: 'Nouvelle Demande',
                      color: AppColors.analyse,
                      onTap: () => context.push('/analyses/demande'),
                    ),
                    const SizedBox(width: 12),
                    _buildQuickAction(
                      icon: Icons.inventory_2,
                      label: 'Stock',
                      color: AppColors.stock,
                      onTap: () => context.push('/stock'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Activity
                _buildSectionHeader('Activite Recent'),
                const SizedBox(height: 12),
                Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: [AppColors.patient, AppColors.analyse, AppColors.result, AppColors.stock, AppColors.payment][index].withOpacity(0.1),
                          child: Icon(
                            [Icons.person, Icons.science, Icons.check_circle, Icons.inventory, Icons.payment][index],
                            color: [AppColors.patient, AppColors.analyse, AppColors.result, AppColors.stock, AppColors.payment][index],
                            size: 20,
                          ),
                        ),
                        title: Text(['Nouveau patient ajoute', 'Demande d analyse', 'Resultat valide', 'Stock mis a jour', 'Paiement recu'][index]),
                        subtitle: Text('Il y a ${index + 1} heure(s)'),
                        trailing: const Icon(Icons.chevron_right, size: 18),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref) {
    final menuItems = [
      ('Tableau de bord', Icons.dashboard_outlined, '/dashboard'),
      ('Patients', Icons.people_outlined, '/patients'),
      ('Analyses', Icons.science_outlined, '/analyses'),
      ('Resultats', Icons.fact_check_outlined, '/results'),
      ('Stock', Icons.inventory_2_outlined, '/stock'),
      ('Paiements', Icons.payment_outlined, '/payments'),
      ('Rapports', Icons.description_outlined, '/reports'),
    ];

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: AppColors.primary, size: 30),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'admin@lab.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final (title, icon, route) = menuItems[index];
                final isSelected = GoRouterState.of(context).matchedLocation == route;
                return ListTile(
                  leading: Icon(
                    icon,
                    color: isSelected ? AppColors.primary : Colors.grey,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : null,
                      fontWeight: isSelected ? FontWeight.w600 : null,
                    ),
                  ),
                  selected: isSelected,
                  onTap: () {
                    Navigator.pop(context);
                    context.go(route);
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Deconnexion', style: TextStyle(color: Colors.red)),
            onTap: () => ref.read(authProvider.notifier).logout(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
