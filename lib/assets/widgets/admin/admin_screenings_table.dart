import 'package:flutter/material.dart';

class AdminScreeningsTable extends StatelessWidget {
  final List<dynamic> screenings;
  final List<dynamic> filteredScreenings;
  final String searchQuery;
  final String selectedStatus;
  final Function(int screeningId)? onViewDetails;
  final VoidCallback? onClearFilters;

  const AdminScreeningsTable({
    super.key,
    required this.screenings,
    required this.filteredScreenings,
    this.searchQuery = '',
    this.selectedStatus = 'All',
    this.onViewDetails,
    this.onClearFilters,
  });

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return Colors.green;

      case 'PROCESSING':
        return Colors.orange;

      case 'PENDING':
        return Colors.blue;

      case 'FAILED':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  Widget _statusBadge(String status) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _score(dynamic score) {
    if (score == null) {
      return '-';
    }

    try {
      return '${double.parse(score.toString()).toStringAsFixed(1)}%';
    } catch (_) {
      return score.toString();
    }
  }

  String _formatDate(dynamic value) {
    if (value == null) {
      return '-';
    }

    try {
      final date = DateTime.parse(value.toString());

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return value.toString();
    }
  }

  Widget _desktopTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 52,
              dataRowMinHeight: 68,
              dataRowMaxHeight: 72,
              horizontalMargin: 20,
              columnSpacing: 30,
              headingTextStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              columns: const [
                DataColumn(
                  label: Text('SCREENING ID'),
                ),
                DataColumn(
                  label: Text('USER ID'),
                ),
                DataColumn(
                  label: Text('RESUME ID'),
                ),
                DataColumn(
                  label: Text('JOB ID'),
                ),
                DataColumn(
                  label: Text('STATUS'),
                ),
                DataColumn(
                  label: Text('MATCH SCORE'),
                ),
                DataColumn(
                  label: Text('DATE'),
                ),
                DataColumn(
                  label: Text('ACTION'),
                ),
              ],
              rows: filteredScreenings.map<DataRow>((screening) {
                final screeningId = screening['screening_id'];

                final status =
                    screening['status']?.toString() ?? '-';

                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '#${screeningId ?? '-'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),

                    DataCell(
                      Text(
                        '${screening['user_id'] ?? '-'}',
                      ),
                    ),

                    DataCell(
                      Text(
                        '${screening['resume_id'] ?? '-'}',
                      ),
                    ),

                    DataCell(
                      Text(
                        '${screening['job_id'] ?? '-'}',
                      ),
                    ),

                    DataCell(
                      _statusBadge(status),
                    ),

                    DataCell(
                      Text(
                        _score(
                          screening['match_score'],
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    DataCell(
                      Text(
                        _formatDate(
                          screening['created_at'],
                        ),
                      ),
                    ),

                    DataCell(
                      IconButton(
                        tooltip: 'View Details',
                        icon: const Icon(
                          Icons.visibility_outlined,
                          size: 20,
                          color: Color(0xFF4F46E5),
                        ),
                        onPressed: () {
                          if (screeningId != null &&
                              onViewDetails != null) {
                            onViewDetails!(
                              int.parse(
                                screeningId.toString(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _mobileCard(dynamic screening) {
    final screeningId =
        screening['screening_id'];

    final status =
        screening['status']?.toString() ?? '-';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fact_check_outlined,
                  color: Color(0xFF4F46E5),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Screening #${screeningId ?? '-'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'User #${screening['user_id'] ?? '-'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              _statusBadge(status),
            ],
          ),

          const SizedBox(height: 16),

          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _mobileInfo(
                  Icons.description_outlined,
                  'Resume ID',
                  '${screening['resume_id'] ?? '-'}',
                ),
              ),

              Expanded(
                child: _mobileInfo(
                  Icons.work_outline,
                  'Job ID',
                  '${screening['job_id'] ?? '-'}',
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _mobileInfo(
                  Icons.score_outlined,
                  'Match Score',
                  _score(
                    screening['match_score'],
                  ),
                ),
              ),

              Expanded(
                child: _mobileInfo(
                  Icons.calendar_today_outlined,
                  'Date',
                  _formatDate(
                    screening['created_at'],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                if (screeningId != null &&
                    onViewDetails != null) {
                  onViewDetails!(
                    int.parse(
                      screeningId.toString(),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.visibility_outlined,
                size: 18,
              ),
              label: const Text(
                'View Details',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade500,
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    final hasFilter =
        searchQuery.trim().isNotEmpty ||
        selectedStatus != 'All';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Showing ${filteredScreenings.length} of ${screenings.length} screenings',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          if (hasFilter &&
              onClearFilters != null)
            TextButton(
              onPressed: onClearFilters,
              child: const Text(
                'Clear Filters',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    final hasFilter =
        searchQuery.trim().isNotEmpty ||
        selectedStatus != 'All';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 55,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: Icon(
              hasFilter
                  ? Icons.search_off
                  : Icons.fact_check_outlined,
              size: 30,
              color: Colors.grey.shade500,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            hasFilter
                ? 'No screenings found'
                : 'No screenings available',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            hasFilter
                ? 'Try changing your search or status filter.'
                : 'There are no screening records yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),

          if (hasFilter &&
              onClearFilters != null) ...[
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onClearFilters,
              child: const Text(
                'Clear Filters',
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (filteredScreenings.isEmpty) {
      return _emptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return _desktopTable();
        }

        return Column(
          children: filteredScreenings
              .map(
                (screening) =>
                    _mobileCard(screening),
              )
              .toList(),
        );
      },
    );
  }
}