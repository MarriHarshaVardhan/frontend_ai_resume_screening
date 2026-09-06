import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../assets/widgets/common/app_notification.dart';
import '../../core/routes/app_routes.dart';
import '../../services/admin_service.dart';
import 'admin_login_page.dart';

class AdminRegistrationPage extends StatefulWidget {
  const AdminRegistrationPage({super.key});

  @override
  State<AdminRegistrationPage> createState() =>
      _AdminRegistrationPageState();
}

class _AdminRegistrationPageState
    extends State<AdminRegistrationPage> {
  final AdminService _adminService = AdminService();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _contactController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerAdmin() async {
    if (isLoading) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await _adminService.registerAdmin(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        contact: _contactController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      AppNotification.success(
        context,
        response['message'] ??
            'Admin registered successfully! Redirecting to login...',
      );

      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminLoginPage(),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      final errorMessage = e
          .toString()
          .replaceFirst('Exception: ', '');

      AppNotification.error(
        context,
        errorMessage,
      );
    }
  }

  void _goToLanding() {
    if (isLoading) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.landing,
      (route) => false,
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        size: 20,
        color: Colors.grey.shade500,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
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
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey ==
                    LogicalKeyboardKey.numpadEnter)) {
          _registerAdmin();
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _buildFieldLabel('Admin Name'),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                hint: 'Enter admin name',
                icon: Icons.person_outline,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter admin name';
                }

                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            _buildFieldLabel('Email'),
            TextFormField(
              controller: _emailController,
              keyboardType:
                  TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                hint: 'Enter admin email',
                icon: Icons.email_outlined,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter email';
                }

                final emailRegex = RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                );

                if (!emailRegex.hasMatch(
                  value.trim(),
                )) {
                  return 'Please enter a valid email';
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            _buildFieldLabel('Contact'),
            TextFormField(
              controller: _contactController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                hint: 'Enter contact number',
                icon: Icons.phone_outlined,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter contact number';
                }

                if (value.trim().length < 10) {
                  return 'Please enter a valid contact number';
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            _buildFieldLabel('Password'),
            TextFormField(
              controller: _passwordController,
              obscureText: obscurePassword,
              textInputAction:
                  TextInputAction.next,
              decoration: _inputDecoration(
                hint: 'Enter password',
                icon: Icons.lock_outline,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword =
                          !obscurePassword;
                    });
                  },
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Please enter password';
                }

                if (value.length < 5) {
                  return 'Password must be at least 5 characters';
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            _buildFieldLabel('Confirm Password'),
            TextFormField(
              controller:
                  _confirmPasswordController,
              obscureText: obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                _registerAdmin();
              },
              decoration: _inputDecoration(
                hint: 'Confirm password',
                icon: Icons.lock_reset_outlined,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword =
                          !obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return 'Please confirm password';
                }

                if (value !=
                    _passwordController.text) {
                  return 'Passwords do not match';
                }

                return null;
              },
            ),

            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    isLoading ? null : _registerAdmin,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
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
                        'Create Admin Account',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Expanded(
      child: Container(
        color: const Color(0xFF111827),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Colors.white,
                    size: 34,
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'AI Resume\nScreener',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Manage candidates, resumes and\nAI screening results from one place.',
                  style: TextStyle(
                    color: Colors.white.withValues(
                      alpha: 0.65,
                    ),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 35),

                _buildFeature(
                  Icons.people_outline,
                  'Manage candidates',
                ),

                const SizedBox(height: 16),

                _buildFeature(
                  Icons.description_outlined,
                  'Review resumes',
                ),

                const SizedBox(height: 16),

                _buildFeature(
                  Icons.fact_check_outlined,
                  'Monitor AI screenings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 21,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRightPanel() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 35,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Admin Account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Register a new administrator account',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildForm(),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an admin account?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const AdminLoginPage(),
                                  ),
                                );
                              },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color:
                                Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: TextButton.icon(
                      onPressed: _goToLanding,
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 17,
                      ),
                      label: const Text(
                        'Back to Landing',
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: const Color(0xFF111827),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.admin_panel_settings_outlined,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          const Text(
            'AI Resume Screener',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile =
              constraints.maxWidth < 800;

          if (isMobile) {
            return SafeArea(
              child: Column(
                children: [
                  _buildMobileHeader(),

                  Expanded(
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.all(24),
                      child: _buildRightPanel(),
                    ),
                  ),
                ],
              ),
            );
          }

          return Row(
            children: [
              _buildLeftPanel(),
              _buildRightPanel(),
            ],
          );
        },
      ),
    );
  }
}