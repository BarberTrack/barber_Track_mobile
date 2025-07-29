import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvailabilityCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;

  const AvailabilityCalendar({
    super.key,
    required this.onDateSelected,
    this.selectedDate,
  });

  @override
  State<AvailabilityCalendar> createState() => _AvailabilityCalendarState();
}

class _AvailabilityCalendarState extends State<AvailabilityCalendar> {
  DateTime _focusedMonth = DateTime.now();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2), width: 1),
      ),
      child: Column(children: [_buildHeader(), _buildCalendarGrid()]),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _canGoPreviousMonth()
                ? () {
                    setState(() {
                      _focusedMonth = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month - 1,
                      );
                    });
                  }
                : null,
            icon: Icon(
              Icons.chevron_left,
              color: _canGoPreviousMonth() ? Colors.blueAccent : Colors.grey,
            ),
          ),
          Text(
            DateFormat('MMMM yyyy', 'es').format(_focusedMonth),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          IconButton(
            onPressed: _canGoNextMonth()
                ? () {
                    setState(() {
                      _focusedMonth = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month + 1,
                      );
                    });
                  }
                : null,
            icon: Icon(
              Icons.chevron_right,
              color: _canGoNextMonth() ? Colors.blueAccent : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final theme = Theme.of(context);
    final daysInMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );
    final startingWeekday = firstDayOfMonth.weekday;

    final weekDays = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays
                .map(
                  (day) => Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: Text(
                      day,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),

          ...List.generate(6, (weekIndex) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                final dayNumber =
                    weekIndex * 7 + dayIndex + 1 - (startingWeekday - 1);

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return Container(width: 32, height: 32);
                }

                final date = DateTime(
                  _focusedMonth.year,
                  _focusedMonth.month,
                  dayNumber,
                );
                final isToday = _isSameDay(date, DateTime.now());
                final isSelected =
                    _selectedDate != null && _isSameDay(date, _selectedDate!);
                final isEnabled = _isDateEnabled(date);

                return GestureDetector(
                  onTap: isEnabled
                      ? () {
                          setState(() {
                            _selectedDate = date;
                          });
                          widget.onDateSelected(date);
                        }
                      : null,
                  child: Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blueAccent
                          : isToday
                          ? Colors.blueAccent.withOpacity(0.3)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: isToday && !isSelected
                          ? Border.all(color: Colors.blueAccent, width: 1)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      dayNumber.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : isEnabled
                            ? (isToday
                                  ? Colors.blueAccent
                                  : theme.colorScheme.onSurface)
                            : Colors.grey.shade400,
                        fontWeight: isSelected || isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isDateEnabled(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);

    return !checkDate.isBefore(today);
  }

  bool _canGoPreviousMonth() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final previousMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);

    return !previousMonth.isBefore(currentMonth);
  }

  bool _canGoNextMonth() {
    final maxDate = DateTime.now().add(const Duration(days: 30));
    final nextMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);

    return nextMonth.isBefore(DateTime(maxDate.year, maxDate.month + 1));
  }
}
