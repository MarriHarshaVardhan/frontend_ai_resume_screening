import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/routes/app_routes.dart';
import '../core/constants/app_constants.dart';
import '../assets/widgets/screening_result/candidate_result_header.dart';
import '../assets/widgets/screening_result/result_info_card.dart';
import '../assets/widgets/screening_result/skills_result_card.dart';
import '../assets/widgets/screening_result/recommendation_card.dart';
import '../services/screening_service.dart';

class ScreeningResultPage extends StatefulWidget {
  const ScreeningResultPage({super.key});

  @override
  State<ScreeningResultPage> createState() =>
      _ScreeningResultPageState();
}

class _ScreeningResultPageState
    extends State<ScreeningResultPage> {
  Map<String, dynamic>? _screeningData;

  bool _isLoading = true;
  bool _isDownloading = false;

  String? _errorMessage;
  int? _screeningId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_screeningId == null) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments;

      if (arguments is Map) {
        final screeningId = arguments['screening_id'];

        if (screeningId != null) {
          _screeningId = screeningId as int;
          _loadScreeningResult();
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Screening ID not found';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Screening data not found';
        });
      }
    }
  }

  Future<void> _loadScreeningResult() async {
    try {
      final data =
          await ScreeningService.getScreeningResult(
        _screeningId!,
      );

      if (!mounted) return;

      setState(() {
        _screeningData = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;

        _errorMessage = e
            .toString()
            .replaceFirst('Exception: ', '');
      });
    }
  }

  // DOWNLOAD REPORT
  Future<void> _downloadReport() async {
    if (_screeningId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Screening ID not found'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}/screening-result/$_screeningId/download',
      );

      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception(
          'Unable to open download link',
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report download started'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e
                .toString()
                .replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Screening Result'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final data = _screeningData!;

    final candidateName =
        data['candidate_name'] ?? 'Unknown';

    final jobTitle =
        data['job_title'] ?? 'Unknown';

    final matchScore =
        (data['match_score'] ?? 0).toDouble();

    final experience =
        data['experience'] ?? 'Not Available';

    final qualification =
        data['qualification'] ?? 'Not Available';

    final certifications =
        data['certifications'] ?? [];

    final matchedSkills =
        List<String>.from(
      data['matched_skills'] ?? [],
    );

    final missingSkills =
        List<String>.from(
      data['missing_skills'] ?? [],
    );

    final recommendation =
        data['recommendation'] ??
            'No recommendation available';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        title: const Text(
          'Screening Result',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor:
            const Color(0xFF2D3748),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.dashboard,
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.dashboard_outlined,
              size: 18,
            ),
            label: const Text('Dashboard'),
          ),
          const SizedBox(width: 12),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // PAGE TITLE ONLY
                const Text(
                  'Screening Result',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'AI analysis result for this candidate',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 24),

                // GREEN DOWNLOAD BUTTON IS INSIDE THIS CARD
                CandidateResultHeader(
                  candidateName: candidateName,
                  jobRole: jobTitle,
                  matchScore: matchScore,
                  onDownload: _isDownloading
                      ? null
                      : _downloadReport,
                ),

                const SizedBox(height: 24),

                const Text(
                  'Candidate Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),

                const SizedBox(height: 16),

                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 700) {
                      return Column(
                        children: [
                          ResultInfoCard(
                            title: 'Experience',
                            value:
                                experience.toString(),
                          ),

                          const SizedBox(height: 16),

                          ResultInfoCard(
                            title: 'Qualification',
                            value:
                                qualification.toString(),
                          ),

                          const SizedBox(height: 16),

                          ResultInfoCard(
                            title: 'Certifications',
                            value:
                                certifications is List &&
                                        certifications
                                            .isNotEmpty
                                    ? certifications.join(', ')
                                    : 'Not Available',
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: ResultInfoCard(
                            title: 'Experience',
                            value:
                                experience.toString(),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: ResultInfoCard(
                            title: 'Qualification',
                            value:
                                qualification.toString(),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: ResultInfoCard(
                            title: 'Certifications',
                            value:
                                certifications is List &&
                                        certifications
                                            .isNotEmpty
                                    ? certifications.join(', ')
                                    : 'Not Available',
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 30),

                const Text(
                  'Skills Analysis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),

                const SizedBox(height: 16),

                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 700) {
                      return Column(
                        children: [
                          SkillsResultCard(
                            title: 'Matched Skills',
                            isMatched: true,
                            skills: matchedSkills,
                          ),

                          const SizedBox(height: 16),

                          SkillsResultCard(
                            title: 'Missing Skills',
                            isMatched: false,
                            skills: missingSkills,
                          ),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SkillsResultCard(
                            title: 'Matched Skills',
                            isMatched: true,
                            skills: matchedSkills,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: SkillsResultCard(
                            title: 'Missing Skills',
                            isMatched: false,
                            skills: missingSkills,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 30),

                RecommendationCard(
                  recommendation: recommendation,
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}