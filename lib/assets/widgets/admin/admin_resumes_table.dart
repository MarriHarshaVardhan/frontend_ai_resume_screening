import 'package:flutter/material.dart';

class AdminResumesTable extends StatelessWidget {
  final List<dynamic> resumes;
  final List<dynamic> filteredResumes;
  final String searchQuery;
  final String selectedType;
  final VoidCallback? onClearFilters;

  const AdminResumesTable({
    super.key,
    required this.resumes,
    required this.filteredResumes,
    this.searchQuery = '',
    this.selectedType = 'All',
    this.onClearFilters,
  });

  Color _typeColor(String? type) {
    switch (type?.toUpperCase()) {
      case 'PDF':
        return Colors.red;
      case 'DOCX':
        return Colors.blue;
      case 'DOC':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _typeBadge(String? type) {
    final color = _typeColor(type);

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
        type ?? '-',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _desktopTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 52,

              // Fixed invalid BoxConstraints issue.
              dataRowMinHeight: 56,
              dataRowMaxHeight: 70,

              columnSpacing: 30,
              columns: const [
                DataColumn(
                  label: Text('RESUME ID'),
                ),
                DataColumn(
                  label: Text('USER ID'),
                ),
                DataColumn(
                  label: Text('FILE NAME'),
                ),
                DataColumn(
                  label: Text('TYPE'),
                ),
                DataColumn(
                  label: Text('EXPERIENCE'),
                ),
                DataColumn(
                  label: Text('QUALIFICATION'),
                ),
                DataColumn(
                  label: Text('UPLOADED'),
                ),
              ],
              rows: filteredResumes.map((resume) {
                final fileName =
                    resume['resume_file_name']?.toString() ?? '-';

                final fileType = _getFileType(
                  resume['resume_file_type']?.toString(),
                );

                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '#${resume['resume_id'] ?? '-'}',
                      ),
                    ),
                    DataCell(
                      Text(
                        '${resume['user_id'] ?? '-'}',
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 220,
                        child: Text(
                          fileName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      _typeBadge(fileType),
                    ),
                    DataCell(
                      SizedBox(
                        width: 120,
                        child: Text(
                          resume['experience']?.toString() ?? '-',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 160,
                        child: Text(
                          resume['qualification']?.toString() ?? '-',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        _formatDate(
                          resume['created_at'],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          _footer(),
        ],
      ),
    );
  }

  Widget _mobileCard(dynamic resume) {
    final fileName =
        resume['resume_file_name']?.toString() ?? '-';

    final fileType = _getFileType(
      resume['resume_file_type']?.toString(),
    );

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
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
                  color: const Color(0xFFEDE7FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF6338D6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Resume #${resume['resume_id'] ?? '-'}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _typeBadge(fileType),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _mobileInfo(
                  'User ID',
                  '${resume['user_id'] ?? '-'}',
                ),
              ),
              Expanded(
                child: _mobileInfo(
                  'Type',
                  fileType,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _mobileInfo(
                  'Experience',
                  resume['experience']?.toString() ?? '-',
                ),
              ),
              Expanded(
                child: _mobileInfo(
                  'Qualification',
                  resume['qualification']?.toString() ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                _formatDate(
                  resume['created_at'],
                ),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mobileInfo(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Showing ${filteredResumes.length} of ${resumes.length} resumes',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          if ((searchQuery.isNotEmpty ||
                  selectedType != 'All') &&
              onClearFilters != null)
            TextButton(
              onPressed: onClearFilters,
              child: const Text(
                'Clear Filters',
              ),
            ),
        ],
      ),
    );
  }

  Widget _empty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.description_outlined,
            size: 50,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            'No resumes found',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getFileType(String? type) {
    if (type == null || type.trim().isEmpty) {
      return 'Other';
    }

    final normalized = type.toLowerCase();

    if (normalized.contains('pdf')) {
      return 'PDF';
    }

    if (normalized.contains('docx') ||
        normalized.contains('wordprocessingml')) {
      return 'DOCX';
    }

    if (normalized == 'doc' ||
        normalized.contains('msword')) {
      return 'DOC';
    }

    return 'Other';
  }

  String _formatDate(dynamic date) {
    if (date == null) {
      return '-';
    }

    try {
      final parsedDate = DateTime.parse(
        date.toString(),
      );

      final day = parsedDate.day
          .toString()
          .padLeft(2, '0');

      final month = parsedDate.month
          .toString()
          .padLeft(2, '0');

      final year = parsedDate.year.toString();

      return '$day/$month/$year';
    } catch (_) {
      return date.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (filteredResumes.isEmpty) {
      return _empty();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return _desktopTable();
        }

        return Column(
          children: filteredResumes
              .map(
                (resume) => _mobileCard(resume),
              )
              .toList(),
        );
      },
    );
  }
}