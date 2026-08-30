import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DashboardSidebar extends StatelessWidget {
  final String activeRoute;
  final Function(String item)? onItemSelected;
  final VoidCallback? onLogoutTap;

  const DashboardSidebar({
    super.key,
    this.activeRoute = 'Dashboard',
    this.onItemSelected,
    this.onLogoutTap,
  });

  static const List<_SidebarItemData> _items = [
    _SidebarItemData(
      title: 'Dashboard',
      icon: Icons.grid_view_rounded,
    ),
    _SidebarItemData(
      title: 'New Screening',
      icon: Icons.description_outlined,
    ),
    _SidebarItemData(
      title: 'My Screenings',
      icon: Icons.checklist_rounded,
    ),
    _SidebarItemData(
      title: 'Jobs',
      icon: Icons.work_outline_rounded,
    ),
    _SidebarItemData(
      title: 'Profile',
      icon: Icons.person_outline_rounded,
    ),
    _SidebarItemData(
      title: 'Settings',
      icon: Icons.settings_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AppColors.sidebarBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Logo & Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'AI Resume',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Screener',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Menu Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _items.map((item) {
                final isSelected = item.title == activeRoute;
                return _SidebarItemWidget(
                  data: item,
                  isSelected: isSelected,
                  onTap: () => onItemSelected?.call(item.title),
                );
              }).toList(),
            ),
          ),

          // Bottom Logout Button
          _SidebarItemWidget(
            data: const _SidebarItemData(
              title: 'Logout',
              icon: Icons.logout_rounded,
            ),
            isSelected: false,
            onTap: onLogoutTap,
          ),
        ],
      ),
    );
  }
}

class _SidebarItemData {
  final String title;
  final IconData icon;

  const _SidebarItemData({
    required this.title,
    required this.icon,
  });
}

class _SidebarItemWidget extends StatefulWidget {
  final _SidebarItemData data;
  final bool isSelected;
  final VoidCallback? onTap;

  const _SidebarItemWidget({
    required this.data,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<_SidebarItemWidget> createState() => _SidebarItemWidgetState();
}

class _SidebarItemWidgetState extends State<_SidebarItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (_isHovered ? AppColors.sidebarItemHover : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                widget.data.icon,
                size: 20,
                color: isSelected
                    ? Colors.white
                    : (_isHovered ? Colors.white : AppColors.sidebarItemText),
              ),
              const SizedBox(width: 14),
              Text(
                widget.data.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (_isHovered ? Colors.white : AppColors.sidebarItemText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
