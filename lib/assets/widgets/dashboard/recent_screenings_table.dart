import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ScreeningItem {
  final String candidateName;
  final String jobTitle;
  final String matchScore;
  final String status;
  final String date;

  const ScreeningItem({
    required this.candidateName,
    required this.jobTitle,
    required this.matchScore,
    required this.status,
    required this.date,
  });
}

class RecentScreeningsTable extends StatelessWidget {
  final List<ScreeningItem> screenings;
  final VoidCallback? onViewAllTap;

  const RecentScreeningsTable({
    super.key,
    required this.screenings,
    this.onViewAllTap,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Card Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Screenings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onViewAllTap ?? () {},
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.cardBorder),

          // Responsive Table
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth > 700 ? constraints.maxWidth : 700,
                  ),
                  child: DataTable(
                    horizontalMargin: 24,
                    columnSpacing: 32,
                    headingRowHeight: 48,
                    dataRowMinHeight: 64,
                    dataRowMaxHeight: 64,
                    dividerThickness: 1,
                    headingRowColor: WidgetStateProperty.all(Colors.transparent),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Candidate',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Job Title',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Match Score',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                    rows: screenings.map((item) {
                      final isCompleted = item.status.toLowerCase() == 'completed';

                      return DataRow(
                        cells: [
                          // Candidate Name
                          DataCell(
                            Text(
                              item.candidateName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          // Job Title
                          DataCell(
                            Text(
                              item.jobTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          // Match Score
                          DataCell(
                            Text(
                              item.matchScore,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          // Status Badge
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? AppColors.statusCompletedBg
                                    : AppColors.statusInProgressBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isCompleted
                                      ? AppColors.statusCompletedText
                                      : AppColors.statusInProgressText,
                                ),
                              ),
                            ),
                          ),
                          // Date
                          DataCell(
                            Text(
                              item.date,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
