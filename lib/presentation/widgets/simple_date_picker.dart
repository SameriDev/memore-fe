import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../core/theme/app_colors.dart';

class SimpleDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDateSelected;

  const SimpleDatePicker({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onDateSelected,
  });

  @override
  State<SimpleDatePicker> createState() => _SimpleDatePickerState();
}

class _SimpleDatePickerState extends State<SimpleDatePicker> {
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

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.cardBackground,
          border: Border.all(
            color: AppColors.secondary.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surface,
                    AppColors.background,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Title
                  Text(
                    'Chọn ngày sinh',
                    style: GoogleFonts.inika(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Month/Year selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _previousMonth,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.secondary.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Icon(
                          Icons.chevron_left,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        DateFormat('MMMM yyyy', 'vi_VN').format(_displayDate),
                        style: GoogleFonts.inika(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      IconButton(
                        onPressed: _nextMonth,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.secondary.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Icon(
                          Icons.chevron_right,
                          color: AppColors.primary,
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
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.secondary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        DateFormat('EEEE, dd MMMM yyyy', 'vi_VN')
                            .format(_selectedDate),
                        style: GoogleFonts.inika(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Calendar
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildCalendarGrid(),
            ),
            // Action buttons
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Text('Hủy', style: GoogleFonts.inika()),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: AppColors.shadowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      'Chọn',
                      style: GoogleFonts.inika(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
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
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    margin: const EdgeInsets.all(2),
                    child: Text(
                      day,
                      style: GoogleFonts.inika(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 6),
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
              final isSelected = _selectedDate.year == date.year &&
                  _selectedDate.month == date.month &&
                  _selectedDate.day == date.day;
              final isToday = DateTime.now().year == date.year &&
                  DateTime.now().month == date.month &&
                  DateTime.now().day == date.day;

              weekDays.add(
                _buildDateCell(dayNumber, isSelected, isToday),
              );
            } else {
              weekDays.add(const Expanded(child: SizedBox(height: 40)));
            }
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(children: weekDays),
          );
        }),
      ],
    );
  }

  Widget _buildDateCell(int day, bool isSelected, bool isToday) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectDate(day),
        child: Container(
          height: 36,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : isToday
                ? AppColors.secondary.withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isToday && !isSelected
                ? Border.all(color: AppColors.secondary, width: 1.5)
                : isSelected
                ? Border.all(color: AppColors.secondary, width: 1)
                : null,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: GoogleFonts.inika(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : isToday
                    ? AppColors.primary
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
        return SimpleDatePicker(
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