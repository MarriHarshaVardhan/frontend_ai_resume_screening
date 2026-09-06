import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  final String selectedItem;
  final ValueChanged<String> onItemSelected;
  final String adminName;
  final String adminEmail;

  const AdminSidebar({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
    this.adminName = 'Administrator',
    this.adminEmail = 'admin@example.com',
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 270,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildSectionTitle('MAIN'),

                  _buildMenuItem(
                    icon: Icons.dashboard_outlined,
                    selectedIcon: Icons.dashboard,
                    title: 'Dashboard',
                  ),

                  _buildMenuItem(
                    icon: Icons.people_outline,
                    selectedIcon: Icons.people,
                    title: 'Users',
                  ),

                  _buildMenuItem(
                    icon: Icons.description_outlined,
                    selectedIcon: Icons.description,
                    title: 'Resumes',
                  ),

                  _buildMenuItem(
                    icon: Icons.fact_check_outlined,
                    selectedIcon: Icons.fact_check,
                    title: 'Screenings',
                  ),

                  const SizedBox(height: 20),

                  _buildSectionTitle('SYSTEM'),

                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    title: 'Settings',
                  ),
                ],
              ),
            ),

            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'AI Resume\nScreener',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.10),
          ),

          const SizedBox(height: 16),

          const Text(
            'ADMIN PANEL',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required IconData selectedIcon,
    required String title,
  }) {
    final bool isSelected = selectedItem == title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isSelected
            ? const Color(0xFFEEF2FF)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            onItemSelected(title);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  size: 21,
                  color: isSelected
                      ? const Color(0xFF4F46E5)
                      : Colors.grey.shade600,
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF3730A3)
                          : const Color(0xFF374151),
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),

                if (isSelected)
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFEEF2FF),
                child: Text(
                  adminName.isNotEmpty
                      ? adminName[0].toUpperCase()
                      : 'A',
                  style: const TextStyle(
                    color: Color(0xFF4F46E5),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adminName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      adminEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                onItemSelected('Logout');
              },
              icon: const Icon(
                Icons.logout,
                size: 18,
              ),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                side: BorderSide(
                  color: Colors.grey.shade300,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}