import 'package:flutter/material.dart';

import '../../services/admin_service.dart';
import '../../assets/widgets/admin/admin_sidebar.dart';
import '../../assets/widgets/admin/admin_stat_card.dart';
import '../../assets/widgets/admin/admin_resumes_table.dart';
import 'admin_dashboard_page.dart';
import 'admin_users_page.dart';
import 'admin_screenings_page.dart';
import 'admin_login_page.dart';

class AdminResumesPage extends StatefulWidget {
  final String token;

  const AdminResumesPage({
    super.key,
    required this.token,
  });

  @override
  State<AdminResumesPage> createState() => _AdminResumesPageState();
}

class _AdminResumesPageState extends State<AdminResumesPage> {
  final AdminService _adminService = AdminService();
  final TextEditingController _searchController =
      TextEditingController();

  List<dynamic> resumes = [];
  List<dynamic> filteredResumes = [];

  bool isLoading = true;
  String? error;

  String selectedType = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      _filterResumes(_searchController.text);
    });

    loadResumes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadResumes() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await _adminService.getResumes(widget.token);

      setState(() {
        resumes = data;
        filteredResumes = data;
        isLoading = false;
      });

      _filterResumes(_searchController.text);
    } catch (e) {
      setState(() {
        isLoading = false;
        error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _filterResumes(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    setState(() {
      searchQuery = normalizedQuery;

      filteredResumes = resumes.where((resume) {
        final fileName =
            (resume['resume_file_name'] ?? '').toString().toLowerCase();

        final fileType =
            _getFileType(resume['resume_file_type']).toLowerCase();

        final userId =
            (resume['user_id'] ?? '').toString().toLowerCase();

        final experience =
            (resume['experience'] ?? '').toString().toLowerCase();

        final qualification =
            (resume['qualification'] ?? '').toString().toLowerCase();

        final matchesSearch =
            normalizedQuery.isEmpty ||
            fileName.contains(normalizedQuery) ||
            fileType.contains(normalizedQuery) ||
            userId.contains(normalizedQuery) ||
            experience.contains(normalizedQuery) ||
            qualification.contains(normalizedQuery);

        final matchesType =
            selectedType == 'All' ||
            fileType == selectedType.toLowerCase();

        return matchesSearch && matchesType;
      }).toList();
    });
  }

  String _getFileType(dynamic value) {
    final type = (value ?? '').toString().toLowerCase();

    if (type.contains('pdf')) {
      return 'PDF';
    }

    if (type.contains('docx')) {
      return 'DOCX';
    }

    if (type.contains('doc')) {
      return 'DOC';
    }

    if (type.isEmpty) {
      return 'Other';
    }

    return type.toUpperCase();
  }

  void _changeType(String? value) {
    if (value == null) return;

    setState(() {
      selectedType = value;
    });

    _filterResumes(_searchController.text);
  }

  void _clearFilters() {
    _searchController.clear();

    setState(() {
      selectedType = 'All';
    });

    _filterResumes('');
  }

  void _navigate(String item) {
    if (item == 'Resumes') return;

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
    } else if (item == 'Screenings') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminScreeningsPage(
            token: widget.token,
          ),
        ),
      );
    } else if (item == 'Settings') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings page is not available yet.'),
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

  int get totalResumes => resumes.length;

  int get pdfCount {
    return resumes.where((resume) {
      return _getFileType(resume['resume_file_type']) == 'PDF';
    }).length;
  }

  int get docCount {
    return resumes.where((resume) {
      final type = _getFileType(resume['resume_file_type']);
      return type == 'DOC' || type == 'DOCX';
    }).length;
  }

  Widget _buildSearchField() {
    return SizedBox(
      width: 320,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search resumes...',
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

  Widget _buildTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedType,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
          ),
          items: const [
            DropdownMenuItem(
              value: 'All',
              child: Text('All Types'),
            ),
            DropdownMenuItem(
              value: 'PDF',
              child: Text('PDF'),
            ),
            DropdownMenuItem(
              value: 'DOC',
              child: Text('DOC'),
            ),
            DropdownMenuItem(
              value: 'DOCX',
              child: Text('DOCX'),
            ),
          ],
          onChanged: _changeType,
        ),
      ),
    );
  }

  Widget _buildStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 800;

        if (isSmall) {
          return Column(
            children: [
              AdminStatCard(
                title: 'Total Resumes',
                value: totalResumes.toString(),
                icon: Icons.description_outlined,
                color: const Color(0xFF4F46E5),
              ),
              const SizedBox(height: 12),
              AdminStatCard(
                title: 'PDF Resumes',
                value: pdfCount.toString(),
                icon: Icons.picture_as_pdf_outlined,
                color: const Color(0xFFDC2626),
              ),
              const SizedBox(height: 12),
              AdminStatCard(
                title: 'DOC Resumes',
                value: docCount.toString(),
                icon: Icons.article_outlined,
                color: const Color(0xFF2563EB),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: AdminStatCard(
                title: 'Total Resumes',
                value: totalResumes.toString(),
                icon: Icons.description_outlined,
                color: const Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminStatCard(
                title: 'PDF Resumes',
                value: pdfCount.toString(),
                icon: Icons.picture_as_pdf_outlined,
                color: const Color(0xFFDC2626),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminStatCard(
                title: 'DOC Resumes',
                value: docCount.toString(),
                icon: Icons.article_outlined,
                color: const Color(0xFF2563EB),
              ),
            ),
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
                'Resumes',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Manage and review uploaded candidate resumes',
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
          onPressed: isLoading ? null : loadResumes,
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
                    child: _buildTypeDropdown(),
                  ),
                  const SizedBox(width: 10),
                  if (searchQuery.isNotEmpty || selectedType != 'All')
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
            _buildTypeDropdown(),
            if (searchQuery.isNotEmpty || selectedType != 'All') ...[
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
                onPressed: loadResumes,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return AdminResumesTable(
      resumes: resumes,
      filteredResumes: filteredResumes,
      searchQuery: searchQuery,
      selectedType: selectedType,
      onClearFilters: _clearFilters,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: AdminSidebar(
        selectedItem: 'Resumes',
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
            onPressed: isLoading ? null : loadResumes,
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
                      'Resume Records',
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