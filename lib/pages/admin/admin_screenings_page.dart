import 'package:flutter/material.dart';

import '../../services/admin_service.dart';
import '../../assets/widgets/admin/admin_sidebar.dart';
import '../../assets/widgets/admin/admin_stat_card.dart';
import '../../assets/widgets/admin/admin_screenings_table.dart';
import 'admin_dashboard_page.dart';
import 'admin_users_page.dart';
import 'admin_resumes_page.dart';
import 'admin_login_page.dart';

class AdminScreeningsPage extends StatefulWidget {
  final String token;

  const AdminScreeningsPage({
    super.key,
    required this.token,
  });

  @override
  State<AdminScreeningsPage> createState() => _AdminScreeningsPageState();
}

class _AdminScreeningsPageState extends State<AdminScreeningsPage> {
  final AdminService _adminService = AdminService();

  final TextEditingController _searchController =
      TextEditingController();

  List<dynamic> screenings = [];
  List<dynamic> filteredScreenings = [];

  bool isLoading = true;
  String? error;

  String selectedStatus = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      _filterScreenings(_searchController.text);
    });

    loadScreenings();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadScreenings() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await _adminService.getScreenings(widget.token);

      setState(() {
        screenings = data;
        filteredScreenings = data;
        isLoading = false;
      });

      _filterScreenings(_searchController.text);
    } catch (e) {
      setState(() {
        isLoading = false;
        error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _filterScreenings(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    final result = screenings.where((screening) {
      final screeningId =
          (screening['screening_id'] ?? '').toString().toLowerCase();

      final userId =
          (screening['user_id'] ?? '').toString().toLowerCase();

      final resumeId =
          (screening['resume_id'] ?? '').toString().toLowerCase();

      final jobId =
          (screening['job_id'] ?? '').toString().toLowerCase();

      final status =
          (screening['status'] ?? '').toString().toLowerCase();

      final screeningResult =
          (screening['screening_result'] ?? '')
              .toString()
              .toLowerCase();

      final matchesSearch =
          normalizedQuery.isEmpty ||
          screeningId.contains(normalizedQuery) ||
          userId.contains(normalizedQuery) ||
          resumeId.contains(normalizedQuery) ||
          jobId.contains(normalizedQuery) ||
          status.contains(normalizedQuery) ||
          screeningResult.contains(normalizedQuery);

      final matchesStatus =
          selectedStatus == 'All' ||
          status == selectedStatus.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();

    setState(() {
      searchQuery = normalizedQuery;
      filteredScreenings = result;
    });
  }

  void _changeStatus(String? value) {
    if (value == null) return;

    setState(() {
      selectedStatus = value;
    });

    _filterScreenings(_searchController.text);
  }

  void _clearFilters() {
    _searchController.clear();

    setState(() {
      selectedStatus = 'All';
      searchQuery = '';
    });

    _filterScreenings('');
  }

  Future<void> _showScreeningDetail(dynamic screening) async {
    final screeningId =
        int.tryParse((screening['screening_id'] ?? '').toString());

    if (screeningId == null) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final detail = await _adminService.getScreeningDetail(
        token: widget.token,
        screeningId: screeningId,
      );

      if (!mounted) return;

      Navigator.pop(context);

      _showDetailDialog(detail);
    } catch (e) {
      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  void _showDetailDialog(Map<String, dynamic> detail) {
    final screeningId = detail['screening_id'];
    final userId = detail['user_id'];
    final resumeId = detail['resume_id'];
    final jobId = detail['job_id'];
    final status = detail['status'] ?? 'N/A';
    final progress = detail['progress'] ?? 0;
    final score = detail['match_score'];
    final result = detail['screening_result'];
    final createdAt = detail['created_at'];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 560,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.analytics_outlined,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          'Screening Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _detailRow(
                    'Screening ID',
                    screeningId?.toString() ?? 'N/A',
                  ),
                  _detailRow(
                    'User ID',
                    userId?.toString() ?? 'N/A',
                  ),
                  _detailRow(
                    'Resume ID',
                    resumeId?.toString() ?? 'N/A',
                  ),
                  _detailRow(
                    'Job ID',
                    jobId?.toString() ?? 'N/A',
                  ),
                  _detailRow(
                    'Status',
                    status.toString(),
                  ),
                  _detailRow(
                    'Progress',
                    '$progress%',
                  ),
                  _detailRow(
                    'Match Score',
                    score != null ? '$score%' : 'N/A',
                  ),
                  _detailRow(
                    'Result',
                    result?.toString() ?? 'N/A',
                  ),
                  _detailRow(
                    'Created At',
                    createdAt?.toString() ?? 'N/A',
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        backgroundColor:
                            const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(String item) {
    if (item == 'Screenings') return;

    if (item == 'Dashboard') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboardPage(
            token: widget.token,
          ),
        ),
      );
    } else if (item == 'Users') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminUsersPage(
            token: widget.token,
          ),
        ),
      );
    } else if (item == 'Resumes') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminResumesPage(
            token: widget.token,
          ),
        ),
      );
    } else if (item == 'Settings') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Settings page is not available yet.',
          ),
        ),
      );
    } else if (item == 'Logout') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminLoginPage(),
        ),
        (route) => false,
      );
    }
  }

  int get totalScreenings => screenings.length;

  int get completedCount {
    return screenings.where((screening) {
      return (screening['status'] ?? '')
              .toString()
              .toUpperCase() ==
          'COMPLETED';
    }).length;
  }

  int get processingCount {
    return screenings.where((screening) {
      return (screening['status'] ?? '')
              .toString()
              .toUpperCase() ==
          'PROCESSING';
    }).length;
  }

  int get pendingCount {
    return screenings.where((screening) {
      return (screening['status'] ?? '')
              .toString()
              .toUpperCase() ==
          'PENDING';
    }).length;
  }

  Widget _buildSearchField() {
    return SizedBox(
      width: 320,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search screenings...',
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF4F46E5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
          ),
          items: const [
            DropdownMenuItem(
              value: 'All',
              child: Text('All Status'),
            ),
            DropdownMenuItem(
              value: 'PENDING',
              child: Text('Pending'),
            ),
            DropdownMenuItem(
              value: 'PROCESSING',
              child: Text('Processing'),
            ),
            DropdownMenuItem(
              value: 'COMPLETED',
              child: Text('Completed'),
            ),
          ],
          onChanged: _changeStatus,
        ),
      ),
    );
  }

  Widget _buildStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 800;

        final cards = [
          AdminStatCard(
            title: 'Total Screenings',
            value: totalScreenings.toString(),
            icon: Icons.analytics_outlined,
            color: const Color(0xFF4F46E5),
          ),
          AdminStatCard(
            title: 'Completed',
            value: completedCount.toString(),
            icon: Icons.check_circle_outline,
            color: const Color(0xFF16A34A),
          ),
          AdminStatCard(
            title: 'Processing',
            value: processingCount.toString(),
            icon: Icons.sync_outlined,
            color: const Color(0xFF2563EB),
          ),
          AdminStatCard(
            title: 'Pending',
            value: pendingCount.toString(),
            icon: Icons.pending_actions_outlined,
            color: const Color(0xFFD97706),
          ),
        ];

        if (isSmall) {
          return Column(
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                cards[i],
                if (i != cards.length - 1)
                  const SizedBox(height: 12),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              Expanded(child: cards[i]),
              if (i != cards.length - 1)
                const SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Screenings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Monitor and review candidate screening results',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Refresh',
          onPressed: isLoading ? null : loadScreenings,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 700;

        if (isSmall) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchField(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildStatusDropdown(),
                  ),
                  const SizedBox(width: 10),
                  if (searchQuery.isNotEmpty ||
                      selectedStatus != 'All')
                    TextButton(
                      onPressed: _clearFilters,
                      child: const Text('Clear'),
                    ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildSearchField(),
            ),
            const SizedBox(width: 12),
            _buildStatusDropdown(),
            if (searchQuery.isNotEmpty ||
                selectedStatus != 'All') ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: _clearFilters,
                child: const Text('Clear'),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: loadScreenings,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return AdminScreeningsTable(
      screenings: screenings,
      filteredScreenings: filteredScreenings,
      searchQuery: searchQuery,
      selectedStatus: selectedStatus,
      onClearFilters: _clearFilters,
      onViewDetails: _showScreeningDetail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: AdminSidebar(
        selectedItem: 'Screenings',
        onItemSelected: _navigate,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF111827),
        ),
        title: const Text(
          'Admin Panel',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: isLoading ? null : loadScreenings,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(right: 18),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFEEF2FF),
              child: Icon(
                Icons.admin_panel_settings_outlined,
                color: Color(0xFF4F46E5),
                size: 21,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildStats(),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Screening Records',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildToolbar(),
                    const SizedBox(height: 20),
                    _buildContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}