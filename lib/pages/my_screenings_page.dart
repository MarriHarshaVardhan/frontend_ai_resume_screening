import 'package:flutter/material.dart';

import '../assets/widgets/my_screenings/screening_search_bar.dart';
import '../assets/widgets/my_screenings/screenings_table.dart';
import '../assets/widgets/my_screenings/screenings_pagination.dart';

class MyScreeningsPage extends StatefulWidget {
  const MyScreeningsPage({super.key});

  @override
  State<MyScreeningsPage> createState() => _MyScreeningsPageState();
}

class _MyScreeningsPageState extends State<MyScreeningsPage> {
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;

  final List<Map<String, dynamic>> _screenings = [
    {
      'jobTitle': 'AI Engineer',
      'candidate': 'Ravi Kumar',
      'matchScore': '85%',
      'status': 'Completed',
      'date': '01 Sep 2026',
    },
    {
      'jobTitle': 'Data Analyst',
      'candidate': 'Priya Sharma',
      'matchScore': '78%',
      'status': 'Completed',
      'date': '31 Aug 2026',
    },
    {
      'jobTitle': 'Python Developer',
      'candidate': 'Arjun Reddy',
      'matchScore': 'Pending',
      'status': 'In Progress',
      'date': '31 Aug 2026',
    },
    {
      'jobTitle': 'Machine Learning Engineer',
      'candidate': 'Sneha Patel',
      'matchScore': '92%',
      'status': 'Completed',
      'date': '30 Aug 2026',
    },
    {
      'jobTitle': 'Backend Developer',
      'candidate': 'Rahul Verma',
      'matchScore': '81%',
      'status': 'Completed',
      'date': '29 Aug 2026',
    },
  ];

  List<Map<String, dynamic>> _filteredScreenings = [];

  @override
  void initState() {
    super.initState();
    _filteredScreenings = List.from(_screenings);
  }

  void _searchScreenings(String value) {
    setState(() {
      if (value.isEmpty) {
        _filteredScreenings = List.from(_screenings);
      } else {
        final query = value.toLowerCase();

        _filteredScreenings = _screenings.where((screening) {
          return screening['jobTitle']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              screening['candidate']
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList();
      }
    });
  }

  void _viewScreening() {
    // Later we will navigate to Screening Result Page
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        title: const Text(
          'My Screenings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3748),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Screenings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'View and manage all your resume screenings',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 24),

            ScreeningSearchBar(
              controller: _searchController,
              onChanged: _searchScreenings,
            ),

            const SizedBox(height: 24),

            ScreeningsTable(
              screenings: _filteredScreenings,
              onView: _viewScreening,
            ),

            const SizedBox(height: 24),

            ScreeningsPagination(
              currentPage: _currentPage,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}