import 'package:flutter/material.dart';

import '../assets/widgets/dashboard/dashboard_sidebar.dart';



class ScreeningProgressPage extends StatelessWidget {
  const ScreeningProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: Row(
        children: [
          // ----------------------------------------------------------
          // SIDEBAR
          // ----------------------------------------------------------
          if (isDesktop) const DashboardSidebar(),

          // ----------------------------------------------------------
          // MAIN CONTENT
          // ----------------------------------------------------------
          Expanded(
            child: Column(
              children: [
                

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 32 : 20,
                      vertical: 28,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 1120,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ------------------------------------------------
                            // PAGE TITLE
                            // ------------------------------------------------
                            const Text(
                              'Screening in Progress',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              "Please don't close this window. AI is analyzing the resume.",
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),

                            const SizedBox(height: 28),
                            // PROGRESS CARD
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                24,
                                24,
                                24,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),

                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // ------------------------------------------
                                  // PROGRESS CONTENT
                                  // ------------------------------------------
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final isSmall = constraints.maxWidth < 650;

                                      if (isSmall) {
                                        return Column(
                                          children: [
                                            _buildSteps(),
                                            const SizedBox(height: 35),
                                            _buildProgressIndicator(),
                                          ],
                                        );
                                      }

                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: _buildSteps(),
                                          ),
                                          const SizedBox(width: 40),
                                          SizedBox(
                                            width: 320,
                                            child: _buildProgressIndicator(),
                                          ),
                                        ],
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 28),

                                  // ------------------------------------------
                                  // INFO MESSAGE
                                  // ------------------------------------------
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 13,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFF6C5CE7),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'i',
                                              style: TextStyle(
                                                fontFamily: 'Segoe UI',
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF6C5CE7),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'This may take a few seconds...',
                                          style: TextStyle(
                                            fontFamily: 'Segoe UI',
                                            fontSize: 14,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // ------------------------------------------
                                  // VIEW RESULT BUTTON
                                  // ------------------------------------------
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // TODO:
                                        // Navigate to screening result page
                                        // when backend/result page is ready.
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor:
                                            const Color(0xFF111827),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 13,
                                        ),
                                        side: const BorderSide(
                                          color: Color(0xFFE5E7EB),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'View result',
                                        style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  // ========================================================================
  // SCREENING STEPS
  // ========================================================================

  Widget _buildSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompletedStep('Extracting Text'),
        const SizedBox(height: 18),
        _buildCompletedStep('Extracting Skills'),
        const SizedBox(height: 18),
        _buildCompletedStep('Extracting Experience'),
        const SizedBox(height: 18),
        _buildCurrentStep('Matching with Job'),
        const SizedBox(height: 18),
        _buildPendingStep('Calculating Score'),
        const SizedBox(height: 18),
        _buildPendingStep('Generating Result'),
      ],
    );
  }

  // ========================================================================
  // COMPLETED STEP
  // ========================================================================

  Widget _buildCompletedStep(String title) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF169B62),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  // ========================================================================
  // CURRENT STEP
  // ========================================================================

  Widget _buildCurrentStep(String title) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF6C5CE7),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.sync,
            color: Colors.white,
            size: 15,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  // ========================================================================
  // PENDING STEP
  // ========================================================================

  Widget _buildPendingStep(String title) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFDDE3EA),
              width: 2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF8993A4),
          ),
        ),
      ],
    );
  }

  // ========================================================================
  // CIRCULAR PROGRESS
  // ========================================================================

  Widget _buildProgressIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 158,
          height: 158,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: 158,
                height: 158,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 13,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFF0F2F7),
                  ),
                ),
              ),

              // Purple progress
              SizedBox(
                width: 158,
                height: 158,
                child: CircularProgressIndicator(
                  value: 0.65,
                  strokeWidth: 13,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF6038C8),
                  ),
                ),
              ),

              // Percentage
              const Text(
                '65%',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'Analyzing skills & experience',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12,
            color: Color(0xFF7A8494),
          ),
        ),
      ],
    );
  }
}
