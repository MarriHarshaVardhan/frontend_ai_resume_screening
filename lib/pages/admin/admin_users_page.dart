import 'package:flutter/material.dart';

import '../../services/admin_service.dart';
import '../../assets/widgets/admin/admin_sidebar.dart';
import '../../assets/widgets/admin/admin_users_table.dart';
import '../../core/routes/app_routes.dart';
import 'admin_dashboard_page.dart';
import 'admin_resumes_page.dart';
import 'admin_screenings_page.dart';

class AdminUsersPage extends StatefulWidget {
  final String token;

  const AdminUsersPage({
    super.key,
    required this.token,
  });

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final AdminService adminService = AdminService();

  final TextEditingController searchController =
      TextEditingController();

  List<dynamic> users = [];
  List<dynamic> filteredUsers = [];

  bool isLoading = true;
  String? error;

  String selectedRole = 'All';

  @override
  void initState() {
    super.initState();

    searchController.addListener(_filterUsers);

    loadUsers();
  }

  @override
  void dispose() {
    searchController.removeListener(_filterUsers);
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadUsers() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await adminService.getUsers(widget.token);

      if (!mounted) return;

      setState(() {
        users = data;
        filteredUsers = data;
        isLoading = false;
      });

      _filterUsers();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString().replaceFirst(
              'Exception: ',
              '',
            );
        isLoading = false;
      });
    }
  }

  void _filterUsers() {
    final query =
        searchController.text.trim().toLowerCase();

    final filtered = users.where((user) {
      final name =
          user['name']?.toString().toLowerCase() ?? '';

      final email =
          user['email']?.toString().toLowerCase() ?? '';

      final contact =
          user['contact']?.toString().toLowerCase() ?? '';

      final role =
          user['role']?.toString().toLowerCase() ?? '';

      final matchesSearch =
          query.isEmpty ||
          name.contains(query) ||
          email.contains(query) ||
          contact.contains(query) ||
          role.contains(query);

      final matchesRole =
          selectedRole == 'All' ||
          role == selectedRole.toLowerCase();

      return matchesSearch && matchesRole;
    }).toList();

    if (!mounted) return;

    setState(() {
      filteredUsers = filtered;
    });
  }

  void _clearFilters() {
    searchController.clear();

    setState(() {
      selectedRole = 'All';
    });

    _filterUsers();
  }

  void _navigate(String item) {
    if (item == 'Dashboard') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboardPage(
            token: widget.token,
          ),
        ),
      );
      return;
    }

    if (item == 'Users') {
      Navigator.pop(context);
      return;
    }

    if (item == 'Resumes') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminResumesPage(
            token: widget.token,
          ),
        ),
      );
      return;
    }

    if (item == 'Screenings') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminScreeningsPage(
            token: widget.token,
          ),
        ),
      );
      return;
    }

    if (item == 'Settings') {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Settings will be available soon.',
          ),
        ),
      );

      return;
    }

    if (item == 'Logout') {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.landing,
        (route) => false,
      );
    }
  }

  Widget _buildPageHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        if (isMobile) {
          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Users',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Manage registered users',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              _buildUserCount(),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Users',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Manage registered users',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            _buildUserCount(),
          ],
        );
      },
    );
  }

  Widget _buildUserCount() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.people_outline,
            size: 17,
            color: Color(0xFF4F46E5),
          ),
          const SizedBox(width: 7),
          Text(
            '${users.length} Users',
            style: const TextStyle(
              color: Color(0xFF4338CA),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        if (isMobile) {
          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              _buildSearchField(),
              const SizedBox(height: 10),
              _buildRoleDropdown(),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildSearchField(),
            ),
            const SizedBox(width: 12),

            // Increased width to prevent dropdown overflow.
            SizedBox(
              width: 170,
              child: _buildRoleDropdown(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search users...',
        prefixIcon: const Icon(
          Icons.search,
          size: 20,
        ),
        suffixIcon:
            searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      searchController.clear();
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                    ),
                  )
                : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: Color(0xFF4F46E5),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: selectedRole,

      // Important: allows dropdown content to use
      // the available width properly.
      isExpanded: true,

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(
          Icons.filter_list,
          size: 19,
        ),
        contentPadding:
            const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: Color(0xFF4F46E5),
          ),
        ),
      ),

      items: const [
        DropdownMenuItem(
          value: 'All',
          child: Text(
            'All Roles',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DropdownMenuItem(
          value: 'candidate',
          child: Text(
            'Candidate',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DropdownMenuItem(
          value: 'admin',
          child: Text(
            'Admin',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],

      onChanged: (value) {
        if (value == null) return;

        setState(() {
          selectedRole = value;
        });

        _filterUsers();
      },
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return _buildError();
    }

    return RefreshIndicator(
      onRefresh: loadUsers,
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            const SizedBox(height: 24),
            _buildToolbar(),
            const SizedBox(height: 20),
            AdminUsersTable(
              users: users,
              filteredUsers: filteredUsers,
              searchQuery: searchController.text,
              selectedRole: selectedRole,
              onClearFilters: _clearFilters,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 52,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 14),
            const Text(
              'Failed to load users',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error ?? 'Something went wrong.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: loadUsers,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      drawer: AdminSidebar(
        selectedItem: 'Users',
        onItemSelected: _navigate,
      ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Color(0xFF111827),
        ),
        title: const Text(
          'Users',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: loadUsers,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(right: 18),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: Color(0xFFEEF2FF),
              child: Icon(
                Icons.admin_panel_settings_outlined,
                color: Color(0xFF4F46E5),
                size: 20,
              ),
            ),
          ),
        ],
      ),

      body: _buildBody(),
    );
  }
}