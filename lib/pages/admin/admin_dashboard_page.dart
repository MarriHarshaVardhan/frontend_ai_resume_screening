import 'package:flutter/material.dart';

import '../../services/admin_service.dart';
import '../../assets/widgets/admin/admin_sidebar.dart';
import '../../assets/widgets/admin/admin_stat_card.dart';
import 'admin_users_page.dart';
import 'admin_resumes_page.dart';
import 'admin_screenings_page.dart';
import 'admin_login_page.dart';

class AdminDashboardPage extends StatefulWidget {
  final String token;

  const AdminDashboardPage({
    super.key,
    required this.token,
  });

  @override
  State<AdminDashboardPage> createState() =>
      _AdminDashboardPageState();
}

class _AdminDashboardPageState
    extends State<AdminDashboardPage> {
  final AdminService adminService = AdminService();

  Map<String, dynamic>? dashboard;

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data =
          await adminService.getDashboard(widget.token);

      if (!mounted) return;

      setState(() {
        dashboard = data;
        isLoading = false;
      });
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

  void _navigate(String item) {
    if (item == 'Dashboard') {
      Navigator.pop(context);
      return;
    }

    if (item == 'Users') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminUsersPage(
            token: widget.token,
          ),
        ),
      );
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminLoginPage(),
        ),
        (route) => false,
      );
    }
  }

  int _getInt(String key) {
    return dashboard?[key] ?? 0;
  }

  Widget _buildDashboardContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return _buildError();
    }

    if (dashboard == null) {
      return _buildEmpty();
    }

    return RefreshIndicator(
      onRefresh: loadDashboard,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          return SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(
              isMobile ? 16 : 28,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                const SizedBox(height: 24),
                _buildStatCards(constraints),
                const SizedBox(height: 24),
                _buildScreeningOverview(),
                const SizedBox(height: 24),
                _buildQuickActions(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Monitor your resume screening system',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: 8,
                  color: Colors.green,
                ),
                SizedBox(width: 7),
                Text(
                  'System Active',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(
    BoxConstraints constraints,
  ) {
    final width = constraints.maxWidth;

    int columns;

    if (width >= 1200) {
      columns = 3;
    } else if (width >= 700) {
      columns = 2;
    } else {
      columns = 1;
    }

    final cards = [
      AdminStatCard(
        title: 'Total Users',
        value: '${_getInt('total_users')}',
        icon: Icons.people_outline,
        color: const Color(0xFF4F46E5),
      ),
      AdminStatCard(
        title: 'Total Resumes',
        value: '${_getInt('total_resumes')}',
        icon: Icons.description_outlined,
        color: const Color(0xFF0891B2),
      ),
      AdminStatCard(
        title: 'Total Screenings',
        value: '${_getInt('total_screenings')}',
        icon: Icons.fact_check_outlined,
        color: const Color(0xFF7C3AED),
      ),
      AdminStatCard(
        title: 'Completed',
        value: '${_getInt('completed_screenings')}',
        icon: Icons.check_circle_outline,
        color: Colors.green,
      ),
      AdminStatCard(
        title: 'Processing',
        value: '${_getInt('processing_screenings')}',
        icon: Icons.sync_outlined,
        color: Colors.orange,
      ),
      AdminStatCard(
        title: 'Pending',
        value: '${_getInt('pending_screenings')}',
        icon: Icons.pending_outlined,
        color: Colors.blue,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio:
            columns == 1 ? 3.1 : 1.7,
      ),
      itemBuilder: (context, index) {
        return cards[index];
      },
    );
  }

  Widget _buildScreeningOverview() {
    final total = _getInt('total_screenings');

    final completed =
        _getInt('completed_screenings');

    final processing =
        _getInt('processing_screenings');

    final pending =
        _getInt('pending_screenings');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Screening Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Current screening status',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          _buildProgressRow(
            'Completed',
            completed,
            total,
            Colors.green,
          ),
          const SizedBox(height: 18),
          _buildProgressRow(
            'Processing',
            processing,
            total,
            Colors.orange,
          ),
          const SizedBox(height: 18),
          _buildProgressRow(
            'Pending',
            pending,
            total,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(
    String title,
    int value,
    int total,
    Color color,
  ) {
    final percentage =
        total == 0 ? 0.0 : value / total;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '(${(percentage * 100).toStringAsFixed(0)}%)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: Colors.grey.shade100,
            valueColor:
                AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _quickAction(
                title: 'View Users',
                icon: Icons.people_outline,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminUsersPage(
                        token: widget.token,
                      ),
                    ),
                  );
                },
              ),
              _quickAction(
                title: 'View Resumes',
                icon: Icons.description_outlined,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminResumesPage(
                        token: widget.token,
                      ),
                    ),
                  );
                },
              ),
              _quickAction(
                title: 'View Screenings',
                icon: Icons.fact_check_outlined,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AdminScreeningsPage(
                        token: widget.token,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 18,
      ),
      label: Text(title),
      style: OutlinedButton.styleFrom(
        foregroundColor:
            const Color(0xFF4F46E5),
        side: BorderSide(
          color: Colors.grey.shade300,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
              'Failed to load dashboard',
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
              onPressed: loadDashboard,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Text(
        'No dashboard data available.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F9FC),

      drawer: AdminSidebar(
        selectedItem: 'Dashboard',
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
          'Admin Dashboard',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: loadDashboard,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(right: 18),
            child: CircleAvatar(
              radius: 17,
              backgroundColor:
                  Color(0xFFEEF2FF),
              child: Icon(
                Icons.admin_panel_settings_outlined,
                color: Color(0xFF4F46E5),
                size: 20,
              ),
            ),
          ),
        ],
      ),

      body: _buildDashboardContent(),
    );
  }
}