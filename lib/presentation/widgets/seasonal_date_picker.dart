import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../core/theme/app_colors.dart';

enum Season { spring, summer, autumn, winter }

class SeasonalDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDateSelected;

  const SeasonalDatePicker({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onDateSelected,
  });

  @override
  State<SeasonalDatePicker> createState() => _SeasonalDatePickerState();
}

class _SeasonalDatePickerState extends State<SeasonalDatePicker> {
  late DateTime _displayDate;
  late DateTime _selectedDate;
  bool _isLocaleReady = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _displayDate = DateTime(_selectedDate.year, _selectedDate.month);
    _initLocale();
  }

  Future<void> _initLocale() async {
    await initializeDateFormatting('vi_VN', null);
    if (mounted) {
      setState(() {
        _isLocaleReady = true;
      });
    }
  }

  Season _getSeason(int month) {
    switch (month) {
      case 3:
      case 4:
      case 5:
        return Season.spring;
      case 6:
      case 7:
      case 8:
        return Season.summer;
      case 9:
      case 10:
      case 11:
        return Season.autumn;
      case 12:
      case 1:
      case 2:
        return Season.winter;
      default:
        return Season.spring;
    }
  }

  SeasonTheme _getSeasonTheme(Season season) {
    switch (season) {
      case Season.spring:
        return SeasonTheme(
          primaryColor: const Color(0xFF4CAF50),
          secondaryColor: const Color(0xFFE8F5E8),
          backgroundColor: const Color(0xFFF1F8E9),
          decorations: ['🌸', '🌺', '🦋', '🌿', '🌱'],
          seasonName: 'Mùa Xuân',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F5E8), Color(0xFFC8E6C9)],
          ),
        );
      case Season.summer:
        return SeasonTheme(
          primaryColor: const Color(0xFF2196F3),
          secondaryColor: const Color(0xFFE3F2FD),
          backgroundColor: const Color(0xFFE1F5FE),
          decorations: ['☀️', '🌊', '🏖️', '🍉', '🐚'],
          seasonName: 'Mùa Hạ',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
          ),
        );
      case Season.autumn:
        return SeasonTheme(
          primaryColor: const Color(0xFFFF9800),
          secondaryColor: const Color(0xFFFFF3E0),
          backgroundColor: const Color(0xFFFFF8E1),
          decorations: ['🍂', '🍁', '🎃', '🌰', '🦋'],
          seasonName: 'Mùa Thu',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
          ),
        );
      case Season.winter:
        return SeasonTheme(
          primaryColor: const Color(0xFF607D8B),
          secondaryColor: const Color(0xFFECEFF1),
          backgroundColor: const Color(0xFFF5F5F5),
          decorations: ['❄️', '⛄', '🎄', '🧣', '☃️'],
          seasonName: 'Mùa Đông',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
          ),
        );
    }
  }

  void _previousMonth() {
    setState(() {
      _displayDate = DateTime(_displayDate.year, _displayDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayDate = DateTime(_displayDate.year, _displayDate.month + 1);
    });
  }

  void _selectDate(int day) {
    final newDate = DateTime(_displayDate.year, _displayDate.month, day);

    // Check if date is within bounds
    if (widget.firstDate != null && newDate.isBefore(widget.firstDate!)) return;
    if (widget.lastDate != null && newDate.isAfter(widget.lastDate!)) return;

    setState(() {
      _selectedDate = newDate;
    });
    widget.onDateSelected(newDate);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocaleReady) return const SizedBox.shrink();

    final season = _getSeason(_displayDate.month);
    final theme = _getSeasonTheme(season);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Floating seasonal decorations
          ..._buildFloatingDecorations(theme),
          // Main dialog
          Container(
            width: 320,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: theme.gradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with seasonal decorations
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: theme.primaryColor.withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      // Season name
                      Text(
                        theme.seasonName,
                        style: GoogleFonts.inika(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Seasonal decorations
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: theme.decorations
                            .map(
                              (decoration) => Text(
                                decoration,
                                style: const TextStyle(fontSize: 24),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      // Month/Year selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: _previousMonth,
                            icon: Icon(
                              Icons.chevron_left,
                              color: theme.primaryColor,
                            ),
                          ),
                          Text(
                            DateFormat(
                              'MMMM yyyy',
                              'vi_VN',
                            ).format(_displayDate),
                            style: GoogleFonts.inika(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                          ),
                          IconButton(
                            onPressed: _nextMonth,
                            icon: Icon(
                              Icons.chevron_right,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      // Selected date display
                      if (_selectedDate.month == _displayDate.month &&
                          _selectedDate.year == _displayDate.year)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            DateFormat(
                              'EEEE, dd MMMM yyyy',
                              'vi_VN',
                            ).format(_selectedDate),
                            style: GoogleFonts.inika(
                              fontSize: 14,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Calendar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildCalendarGrid(theme),
                ),
                // Action buttons
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                        ),
                        child: Text('Hủy', style: GoogleFonts.inika()),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Chọn', style: GoogleFonts.inika()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingDecorations(SeasonTheme theme) {
    return [
      // Top left decoration
      Positioned(
        top: -10,
        left: 20,
        child: Text(theme.decorations[0], style: const TextStyle(fontSize: 30)),
      ),
      // Top right decoration
      Positioned(
        top: 10,
        right: 10,
        child: Text(theme.decorations[1], style: const TextStyle(fontSize: 25)),
      ),
      // Bottom left decoration
      Positioned(
        bottom: 20,
        left: -10,
        child: Text(theme.decorations[2], style: const TextStyle(fontSize: 28)),
      ),
      // Bottom right decoration
      Positioned(
        bottom: -5,
        right: 30,
        child: Text(theme.decorations[3], style: const TextStyle(fontSize: 22)),
      ),
      // Middle left decoration
      Positioned(
        top: 120,
        left: -15,
        child: Text(theme.decorations[4], style: const TextStyle(fontSize: 20)),
      ),
      // Middle right decoration
      Positioned(
        top: 150,
        right: -10,
        child: Text(theme.decorations[0], style: const TextStyle(fontSize: 26)),
      ),
    ];
  }

  Widget _buildCalendarGrid(SeasonTheme theme) {
    final firstDayOfMonth = DateTime(_displayDate.year, _displayDate.month, 1);
    final lastDayOfMonth = DateTime(
      _displayDate.year,
      _displayDate.month + 1,
      0,
    );
    final firstWeekday = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        // Day headers
        Row(
          children: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7']
              .map(
                (day) => Expanded(
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    child: Text(
                      day,
                      style: GoogleFonts.inika(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        // Calendar grid
        ...List.generate(6, (weekIndex) {
          final weekDays = <Widget>[];
          for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
            final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;
            if (dayNumber > 0 && dayNumber <= lastDayOfMonth.day) {
              final date = DateTime(
                _displayDate.year,
                _displayDate.month,
                dayNumber,
              );
              final isSelected =
                  _selectedDate.year == date.year &&
                  _selectedDate.month == date.month &&
                  _selectedDate.day == date.day;
              final isToday =
                  DateTime.now().year == date.year &&
                  DateTime.now().month == date.month &&
                  DateTime.now().day == date.day;

              weekDays.add(
                _buildDateCell(dayNumber, isSelected, isToday, theme),
              );
            } else {
              weekDays.add(const Expanded(child: SizedBox(height: 40)));
            }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(children: weekDays),
          );
        }),
      ],
    );
  }

  Widget _buildDateCell(
    int day,
    bool isSelected,
    bool isToday,
    SeasonTheme theme,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectDate(day),
        child: Container(
          height: 40,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.primaryColor
                : isToday
                ? theme.primaryColor.withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isToday && !isSelected
                ? Border.all(color: theme.primaryColor, width: 1)
                : null,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: GoogleFonts.inika(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : isToday
                    ? theme.primaryColor
                    : AppColors.text,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateTime? selectedDate;

    await initializeDateFormatting('vi_VN', null);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return SeasonalDatePicker(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          onDateSelected: (date) {
            selectedDate = date;
          },
        );
      },
    );

    return selectedDate;
  }
}

class SeasonTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final List<String> decorations;
  final String seasonName;
  final LinearGradient gradient;

  SeasonTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.decorations,
    required this.seasonName,
    required this.gradient,
  });
}
