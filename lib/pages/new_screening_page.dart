import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../core/theme/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../assets/widgets/dashboard/dashboard_sidebar.dart';
import '../assets/widgets/dashboard/dashboard_header.dart';
import '../core/constants/user_session.dart';
import '../services/resume_service.dart';

class NewScreeningPage extends StatefulWidget {
  const NewScreeningPage({super.key});

  @override
  State<NewScreeningPage> createState() => _NewScreeningPageState();
}

class _NewScreeningPageState extends State<NewScreeningPage> {
  final TextEditingController _jobTitleController =
      TextEditingController();

  final TextEditingController _skillsController =
      TextEditingController();

  PlatformFile? _selectedFile;

  bool _isLoading = false;

  @override
  void dispose() {
    _jobTitleController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _handleNavItemSelect(String item) {
    if (item == 'New Screening') {
      return;
    }

    if (item == 'Dashboard') {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.dashboard,
      );
      return;
    }

    if (item == 'My Screenings') {
      Navigator.pushNamed(
        context,
        AppRoutes.myScreenings,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$item page coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout of your account?',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                UserSession.logout();

                Navigator.pop(dialogContext);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= CHOOSE RESUME FILE =================

  Future<void> _handleChooseFile() async {
    try {
      final FilePickerResult? result =
          await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.single;
        });
      }
    } catch (e) {
      debugPrint('File picker error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to select file: $e',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ================= START SCREENING =================

  Future<void> _handleStartScreening() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please upload a resume',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final jobTitle =
        _jobTitleController.text.trim();

    if (jobTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a job title',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final requiredSkills =
        _skillsController.text
            .split(',')
            .map((skill) => skill.trim())
            .where((skill) => skill.isNotEmpty)
            .toList();

    if (requiredSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter at least one required skill',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final screeningId =
          await ResumeService.startScreening(
        _selectedFile!,
        jobTitle,
        requiredSkills,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      Navigator.pushNamed(
        context,
        AppRoutes.screeningProgress,
        arguments: {
          'screening_id': screeningId,
          'job_title': jobTitle,
          'required_skills': requiredSkills,
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      String errorMessage = e.toString();

      errorMessage = errorMessage.replaceFirst(
        'Exception: ',
        '',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    final isDesktop =
        screenWidth > 900;

    return Scaffold(
      backgroundColor: AppColors.background,

      drawer: !isDesktop
          ? Drawer(
              child: DashboardSidebar(
                activeRoute: 'New Screening',
                onItemSelected: (item) {
                  Navigator.pop(context);
                  _handleNavItemSelect(item);
                },
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
              onItemSelected:
                  _handleNavItemSelect,
              onLogoutTap:
                  _handleLogout,
            ),

          Expanded(
            child: Column(
              children: [
                if (!isDesktop)
                  Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Builder(
                          builder:
                              (btnContext) =>
                                  IconButton(
                            icon:
                                const Icon(
                              Icons.menu,
                              color: AppColors
                                  .textPrimary,
                            ),
                            onPressed: () {
                              Scaffold.of(
                                btnContext,
                              ).openDrawer();
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        const Text(
                          'AI Resume Screener',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w700,
                            color: AppColors
                                .textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child:
                      SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal:
                          isDesktop
                              ? 36.0
                              : 16.0,
                      vertical: 28.0,
                    ),
                    child: Center(
                      child: Container(
                        constraints:
                            const BoxConstraints(
                          maxWidth: 1200,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .stretch,
                          children: [
                            DashboardHeader(
                              userName:
                                  UserSession.userName,
                              subtitle:
                                  'Upload a resume and job details to start screening.',
                              userInitials:
                                  UserSession.initials,
                              onNotificationTap:
                                  () {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No new notifications',
                                    ),
                                    duration:
                                        Duration(
                                      seconds: 1,
                                    ),
                                  ),
                                );
                              },
                              onProfileTap: () {
                                _handleNavItemSelect(
                                  'Profile',
                                );
                              },
                            ),

                            const SizedBox(
                              height: 24,
                            ),

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

  // ================= SCREENING FORM =================

  Widget _buildFormCard() {
    return Container(
      constraints:
          const BoxConstraints(
        maxWidth: 700,
      ),
      padding:
          const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.03),
            blurRadius: 12,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Resume',
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.w600,
              color:
                  AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          _buildUploadBox(),

          const SizedBox(height: 24),

          const Text(
            'Job Title',
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.w600,
              color:
                  AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          _buildTextField(
            _jobTitleController,
            'Enter job title',
          ),

          const SizedBox(height: 24),

          const Text(
            'Required Skills (comma separated)',
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.w600,
              color:
                  AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          _buildTextField(
            _skillsController,
            'e.g. Python, Machine Learning, SQL',
            maxLines: 3,
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _handleStartScreening,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primary,
                disabledBackgroundColor:
                    AppColors.primary
                        .withValues(
                  alpha: 0.6,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Start Screening',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FILE UPLOAD BOX =================

  Widget _buildUploadBox() {
    return InkWell(
      onTap: _isLoading
          ? null
          : _handleChooseFile,
      borderRadius:
          BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: _selectedFile != null
                ? AppColors.primary
                : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _selectedFile != null
                  ? Icons.description_rounded
                  : Icons.cloud_upload_outlined,
              color: AppColors.primary,
              size: 36,
            ),

            const SizedBox(height: 12),

            Text(
              _selectedFile?.name ??
                  'Drag & drop your file here',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    FontWeight.w600,
                color:
                    _selectedFile != null
                        ? AppColors.primary
                        : AppColors
                            .textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'PDF, DOC, DOCX (max 10 MB)',
              style: TextStyle(
                fontSize: 12,
                color:
                    AppColors.textMuted,
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _handleChooseFile,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primary,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: Text(
                _selectedFile != null
                    ? 'Change File'
                    : 'Choose File',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TEXT FIELD =================

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8),
          borderSide:
              const BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8),
          borderSide:
              const BorderSide(
            color: AppColors.primary,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8),
        ),
      ),
    );
  }
}