import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/routes/app_routes.dart';
import '../services/auth_service.dart';

import '../assets/widgets/common/custom_button.dart';
import '../assets/widgets/common/custom_text_field.dart';
import '../assets/widgets/common/app_notification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.login(
        emailOrMobile: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      AppNotification.success(
        context,
        'Login successful! Redirecting to dashboard...',
      );

      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (mounted) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.dashboard,
            );
          }
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

      AppNotification.error(
        context,
        errorMessage,
      );
    }
  }

  void _goToLanding() {
    if (_isLoading) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.landing,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: AppColors.ctaGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius:
                                BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary
                                    .withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.document_scanner_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          AppConstants.appName,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 440,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 36,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.border
                              .withValues(alpha: 0.7),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Focus(
                        onKeyEvent: (node, event) {
                          if (event is KeyDownEvent &&
                              (event.logicalKey ==
                                      LogicalKeyboardKey.enter ||
                                  event.logicalKey ==
                                      LogicalKeyboardKey
                                          .numpadEnter)) {
                            if (!_isLoading) {
                              _handleLogin();
                            }

                            return KeyEventResult.handled;
                          }

                          return KeyEventResult.ignored;
                        },
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Welcome Back',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                'Login to your account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Email / Mobile
                              CustomTextField(
                                label: 'Email or Mobile',
                                hintText:
                                    'Enter your email or mobile number',
                                prefixIcon: Icons.mail_outline,
                                keyboardType:
                                    TextInputType.emailAddress,
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return 'Please enter your email or mobile';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Password
                              CustomTextField(
                                label: 'Password',
                                hintText: '••••••••',
                                prefixIcon: Icons.lock_outline,
                                isPassword: true,
                                controller: _passwordController,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'Please enter your password';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 10),

                              Align(
                                alignment:
                                    Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          AppNotification.info(
                                            context,
                                            'Password reset flow coming soon!',
                                          );
                                        },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize
                                            .shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Login Button
                              SizedBox(
                                height: 48,
                                child: _isLoading
                                    ? const Center(
                                        child:
                                            CircularProgressIndicator(),
                                      )
                                    : CustomButton(
                                        text: 'Login',
                                        onPressed: _handleLogin,
                                        type: ButtonType.primary,
                                        height: 48,
                                      ),
                              ),

                              const SizedBox(height: 24),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color:
                                          AppColors.textSecondary,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _isLoading
                                        ? null
                                        : () {
                                            Navigator
                                                .pushReplacementNamed(
                                              context,
                                              AppRoutes.registration,
                                            );
                                          },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight:
                                            FontWeight.w700,
                                        color:
                                            AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

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
                                        AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}