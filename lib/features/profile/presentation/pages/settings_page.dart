import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/di/injection_container.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          String userEmail = 'Chargement...';
          if (state is DashboardLoaded) {
            userEmail = state.user.email;
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF2563EB),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Connecté en tant que', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          Text(userEmail, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSection('Compte'),
              _buildSettingItem(Icons.person_outline, 'Profil', 'Modifier vos informations'),
              _buildSettingItem(Icons.notifications_none, 'Notifications', 'Gérer les alertes'),
              _buildSettingItem(Icons.repeat, 'Transactions Récurrentes', 'Gérer vos charges fixes', onTap: () {
                context.push('/fixed-expenses');
              }),
              const SizedBox(height: 32),
              _buildSection('Sécurité'),
              _buildSettingItem(Icons.lock_outline, 'Mot de passe', 'Changer votre mot de passe'),
              _buildSettingItem(Icons.fingerprint, 'Biométrie', 'Activer FaceID / Empreinte'),
              _buildSettingItem(Icons.lock_outline, 'Verrouiller', 'Nécessitera le code PIN', onTap: () async {
                await sl<AuthRepository>().logout();
                if (context.mounted) context.go('/pin-login');
              }),
              _buildSettingItem(Icons.delete_forever_outlined, 'Réinitialiser', 'Effacer TOUTES les données', onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Tout effacer ?'),
                    content: const Text('Cette action supprimera tous vos portefeuilles et transactions définitivement.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Effacer', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirm == true) {
                  await sl<AuthRepository>().resetApp();
                  if (context.mounted) context.go('/setup-pin');
                }
              }),
              const SizedBox(height: 48),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Monely v1.0.0',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: const Color(0xFF475569), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1)),
      onTap: onTap ?? () {},
    );
  }
}
