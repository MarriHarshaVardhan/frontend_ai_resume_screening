import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../assets/widgets/dashboard/dashboard_sidebar.dart';
import '../assets/widgets/dashboard/dashboard_header.dart';
import '../core/constants/user_session.dart';
import 'package:file_picker/file_picker.dart';

class NewScreeningPage extends StatefulWidget {
  const NewScreeningPage({super.key});

  @override
  State<NewScreeningPage> createState() => _NewScreeningPageState();
}

class _NewScreeningPageState extends State<NewScreeningPage> {
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  String? _selectedFileName;

  @override
  void dispose() {
    _jobTitleController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm Logout',
              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          content: const Text('Are you sure you want to logout of your account?',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                UserSession.logout();
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleChooseFile() async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc', 'docx'],
  );

  if (file != null) {
    setState(() {
      _selectedFileName = file.name;
    });
  }
}

  void _handleStartScreening() {
    if (_selectedFileName == null || _jobTitleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a resume and enter a job title')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Screening started! (mock - API not connected yet)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: !isDesktop
          ? Drawer(
              child: DashboardSidebar(
                activeRoute: 'New Screening',
                onItemSelected: (item) => Navigator.pop(context),
                onLogoutTap: () {
                  Navigator.pop(context);
                  _handleLogout();
                },
              ),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            DashboardSidebar(
              activeRoute: 'New Screening',
              onItemSelected: (item) {},
              onLogoutTap: _handleLogout,
            ),
          Expanded(
            child: Column(
              children: [
                if (!isDesktop)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Builder(
                          builder: (btnContext) => IconButton(
                            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                            onPressed: () => Scaffold.of(btnContext).openDrawer(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('AI Resume Screener',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: isDesktop ? 36.0 : 16.0, vertical: 28.0),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DashboardHeader(
                              userName: UserSession.userName,
                              subtitle: 'Upload a resume and job details to start screening.',
                              userInitials: UserSession.initials,
                              onNotificationTap: () {},
                              onProfileTap: () {},
                            ),
                            const SizedBox(height: 24),
                            _buildFormCard(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Upload Resume',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          _buildUploadBox(),
          const SizedBox(height: 24),
          const Text('Job Title',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          _buildTextField(_jobTitleController, 'Enter job title'),
          const SizedBox(height: 24),
          const Text('Required Skills (comma separated)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          _buildTextField(_skillsController, 'e.g. Python, Machine Learning, SQL', maxLines: 3),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _handleStartScreening,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Start Screening',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 32),
          const SizedBox(height: 12),
          Text(
            _selectedFileName ?? 'Drag & drop your file here',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          const Text('PDF, DOC, DOCX (max 10 MB)',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _handleChooseFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Choose File', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}