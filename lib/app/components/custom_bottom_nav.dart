import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final String role; // Pilihan: 'user', 'moderator', 'gatekeeper', 'speaker'

  const CustomBottomNavBar({
    super.key, 
    required this.currentIndex, 
    required this.role,
  });

  // Konfigurasi dinamis menu berdasarkan Role
  List<Map<String, dynamic>> _getNavItems() {
    switch (role.toLowerCase()) {
      case 'moderator':
        return [
          {'icon': Icons.home_filled, 'label': 'Home', 'route': Routes.DASHBOARD_MOD},
          {'icon': Icons.question_answer_outlined, 'label': 'Q&A', 'route': Routes.QA},
          {'icon': Icons.person_outline, 'label': 'Profile', 'route': Routes.PROFIL},
        ];
      case 'gatekeeper':
        return [
          {'icon': Icons.home_filled, 'label': 'Home', 'route': Routes.DASHBOARD_GATEKEEPER},
          {'icon': Icons.people_outline, 'label': 'Peserta', 'route': Routes.USER_VALIDATION},
          {'icon': Icons.person_outline, 'label': 'Profile', 'route': Routes.PROFIL},
        ];
      case 'speaker':
        return [
          {'icon': Icons.home_filled, 'label': 'Home', 'route': Routes.DASHBOARD_SPEAK},
          {'icon': Icons.question_answer_outlined, 'label': 'Q&A', 'route': Routes.Q_A_SPEAK},
          {'icon': Icons.person_outline, 'label': 'Profile', 'route': Routes.PROFIL},
        ];
      case 'user':
      default:
        return [
          {'icon': Icons.home_filled, 'label': 'Home', 'route': Routes.DASHBOARD},
          {'icon': Icons.confirmation_num_outlined, 'label': 'Tickets', 'route': Routes.TICKET},
          {'icon': Icons.person_outline, 'label': 'Profile', 'route': Routes.PROFIL},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _getNavItems();

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            return _buildNavTab(
              icon: item['icon'],
              label: item['label'],
              isActive: currentIndex == index,
              onTap: () {
                // Mencegah navigasi ke halaman yang sama
                if (currentIndex != index) {
                  if (index == 0) {
                    // Jika klik Home, bersihkan sisa stack agar HP tidak berat
                    Get.offAllNamed(item['route']);
                  } else {
                    Get.toNamed(item['route'], arguments: {'role': role});
                  }
                }
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNavTab({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? Colors.blue.shade700 : Colors.grey.shade400,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.blue.shade700 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}