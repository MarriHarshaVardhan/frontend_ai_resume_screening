import 'package:flutter/material.dart';

import '../assets/widgets/my_screenings/screening_search_bar.dart';
import '../assets/widgets/my_screenings/screenings_table.dart';
import '../assets/widgets/my_screenings/screenings_pagination.dart';
import '../services/screening_service.dart';

class MyScreeningsPage extends StatefulWidget {
  const MyScreeningsPage({super.key});

  @override
  State<MyScreeningsPage> createState() => _MyScreeningsPageState();
}

class _MyScreeningsPageState extends State<MyScreeningsPage> {
  final TextEditingController _searchController =
      TextEditingController();

  int _currentPage = 1;

  final List<Map<String, dynamic>> _screenings = [];

  List<Map<String, dynamic>> _filteredScreenings = [];

  bool _isLoading = false;
  String? _errorMessage;

  static const int _itemsPerPage = 5;

  int get _totalPages =>
      (_filteredScreenings.length / _itemsPerPage).ceil();

  List<Map<String, dynamic>> get _paginatedScreenings {
    if (_filteredScreenings.isEmpty) {
      return [];
    }

    final startIndex = (_currentPage - 1) * _itemsPerPage;

    if (startIndex >= _filteredScreenings.length) {
      return [];
    }

    final endIndex = (startIndex + _itemsPerPage)
        .clamp(0, _filteredScreenings.length);

    return _filteredScreenings.sublist(
      startIndex,
      endIndex,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadScreenings();
  }

  Future<void> _loadScreenings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ScreeningService.getScreenings();

      final screenings = response.map((screening) {
        return {
          'screeningId': screening['screening_id'],
          'jobTitle': screening['job_title'] ?? '',
          'candidate': screening['candidate'] ?? '',
          'matchScore': screening['match_score'] != null
              ? '${screening['match_score']}%'
              : 'Pending',
          'status': screening['status'] ?? 'Pending',
          'date': screening['date'] ?? '',
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        _screenings
          ..clear()
          ..addAll(screenings);

        _filteredScreenings = List.from(_screenings);

        _currentPage = 1;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  void _searchScreenings(String value) {
    setState(() {
      _currentPage = 1;

      if (value.trim().isEmpty) {
        _filteredScreenings = List.from(_screenings);
      } else {
        final query = value.toLowerCase().trim();

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

            // Loading / Error / Data
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ScreeningsTable(
                screenings: _paginatedScreenings,
                onView: _viewScreening,
              ),

            const SizedBox(height: 24),

            // Dynamic Pagination
            if (!_isLoading &&
                _errorMessage == null &&
                _totalPages > 1)
              ScreeningsPagination(
                currentPage: _currentPage,
                totalPages: _totalPages,
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