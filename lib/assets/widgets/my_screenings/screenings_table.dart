import 'package:flutter/material.dart';

import 'screening_status_badge.dart';

class ScreeningsTable extends StatelessWidget {
  final List<Map<String, dynamic>> screenings;
  final VoidCallback? onView;

  const ScreeningsTable({
    super.key,
    required this.screenings,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFDCE2EA),
        ),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFDCE2EA),
                ),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Job Title',
                    style: _headerStyle,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Candidate',
                    style: _headerStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Match Score',
                    style: _headerStyle,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Status',
                    style: _headerStyle,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Date',
                    style: _headerStyle,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    '',
                    style: _headerStyle,
                  ),
                ),
              ],
            ),
          ),

          // Table Rows
          ...screenings.map(
            (screening) => _ScreeningRow(
              jobTitle: screening['jobTitle'],
              candidate: screening['candidate'],
              matchScore: screening['matchScore'],
              status: screening['status'],
              date: screening['date'],
              onView: onView,
            ),
          ),
        ],
      ),
    );
  }
}

const TextStyle _headerStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: Color(0xFF64748B),
);

class _ScreeningRow extends StatelessWidget {
  final String jobTitle;
  final String candidate;
  final String matchScore;
  final String status;
  final String date;
  final VoidCallback? onView;

  const _ScreeningRow({
    required this.jobTitle,
    required this.candidate,
    required this.matchScore,
    required this.status,
    required this.date,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFDCE2EA),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              jobTitle,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF2D3748),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              candidate,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF64748B),
              ),
            ),
          ),

          Expanded(
            child: Text(
              matchScore,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ScreeningStatusBadge(
                status: status,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
          ),

          SizedBox(
            width: 60,
            child: TextButton(
              onPressed: onView,
              child: const Text(
                'View',
                style: TextStyle(
                  color: Color(0xFF5B3DB5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}