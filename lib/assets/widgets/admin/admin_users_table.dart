import 'package:flutter/material.dart';

class AdminUsersTable extends StatelessWidget {
  final List<dynamic> users;
  final List<dynamic> filteredUsers;
  final String searchQuery;
  final String selectedRole;
  final VoidCallback? onClearFilters;

  const AdminUsersTable({
    super.key,
    required this.users,
    required this.filteredUsers,
    this.searchQuery = '',
    this.selectedRole = 'All',
    this.onClearFilters,
  });

  String _getInitial(String name) {
    if (name.trim().isEmpty) {
      return 'U';
    }

    return name.trim()[0].toUpperCase();
  }

  String _formatDate(dynamic value) {
    if (value == null) {
      return '-';
    }

    try {
      final date = DateTime.parse(value.toString());

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return value.toString();
    }
  }

  Color _roleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return const Color(0xFF7C3AED);

      case 'candidate':
        return const Color(0xFF2563EB);

      default:
        return Colors.grey;
    }
  }

  Widget _roleBadge(String role) {
    final color = _roleColor(role);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role.isEmpty ? '-' : role,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildUserAvatar(String name) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xFFEEF2FF),
      child: Text(
        _getInitial(name),
        style: const TextStyle(
          color: Color(0xFF4F46E5),
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildDesktopTable(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 52,
              dataRowMinHeight: 68,
              dataRowMaxHeight: 72,
              horizontalMargin: 20,
              columnSpacing: 30,
              headingTextStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              columns: const [
                DataColumn(label: Text('USER ID')),
                DataColumn(label: Text('USER')),
                DataColumn(label: Text('EMAIL')),
                DataColumn(label: Text('CONTACT')),
                DataColumn(label: Text('ROLE')),
                DataColumn(label: Text('REGISTERED')),
              ],
              rows: filteredUsers.map<DataRow>((user) {
                final name = user['name']?.toString() ?? '-';
                final email = user['email']?.toString() ?? '-';
                final contact = user['contact']?.toString() ?? '-';
                final role = user['role']?.toString() ?? '-';
                final userId = user['user_id']?.toString() ?? '-';
                final createdAt = user['created_at'];

                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '#$userId',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildUserAvatar(name),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 130,
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 190,
                        child: Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        contact,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    DataCell(
                      _roleBadge(role),
                    ),
                    DataCell(
                      Text(
                        _formatDate(createdAt),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    return Column(
      children: [
        ...filteredUsers.map(
          (user) => _buildUserCard(user),
        ),
        const SizedBox(height: 8),
        _buildFooter(),
      ],
    );
  }

  Widget _buildUserCard(dynamic user) {
    final name = user['name']?.toString() ?? '-';
    final email = user['email']?.toString() ?? '-';
    final contact = user['contact']?.toString() ?? '-';
    final role = user['role']?.toString() ?? '-';
    final userId = user['user_id']?.toString() ?? '-';
    final createdAt = user['created_at'];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildUserAvatar(name),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              _roleBadge(role),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 14),
          _mobileInfo(
            Icons.badge_outlined,
            'User ID',
            '#$userId',
          ),
          _mobileInfo(
            Icons.phone_outlined,
            'Contact',
            contact,
          ),
          _mobileInfo(
            Icons.calendar_today_outlined,
            'Registered',
            _formatDate(createdAt),
          ),
        ],
      ),
    );
  }

  Widget _mobileInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: Colors.grey.shade500,
          ),
          const SizedBox(width: 9),
          Text(
            '$title:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final hasFilter =
        searchQuery.trim().isNotEmpty ||
        selectedRole != 'All';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Showing ${filteredUsers.length} of ${users.length} users',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          if (hasFilter && onClearFilters != null)
            TextButton(
              onPressed: onClearFilters,
              child: const Text(
                'Clear Filters',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasFilter =
        searchQuery.trim().isNotEmpty ||
        selectedRole != 'All';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 55,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              hasFilter
                  ? Icons.search_off
                  : Icons.people_outline,
              size: 30,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hasFilter
                ? 'No users found'
                : 'No users available',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasFilter
                ? 'Try changing your search or filter.'
                : 'There are no registered users yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
          if (hasFilter && onClearFilters != null) ...[
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onClearFilters,
              child: const Text('Clear Filters'),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (filteredUsers.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return _buildDesktopTable(context);
        }

        return _buildMobileList();
      },
    );
  }
}