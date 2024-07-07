import 'package:diaryfinalapp/models/entry.dart';
import 'package:diaryfinalapp/pages/entry_form_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final List<Entry> entries;
  final String userTag;
  final Function() updateAll;
  final Function(Entry) onDelete;
  const CalendarPage(
      {required this.entries,
      required this.onDelete,
      required this.updateAll,
      required this.userTag,
      super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime _firstDay = DateTime.utc(2010, 10, 16);
  DateTime _lastDay = DateTime.utc(2030, 3, 14);

  @override
  void initState() {
    super.initState();
    if (widget.entries.isNotEmpty) {
      _firstDay = widget.entries.last.date;
      _lastDay = widget.entries.first.date;
    }
  }

  void _onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      _selectedDay = selectedDate;
      _focusedDay = focusedDate;
    });
  }

  List<Entry> _getEntriesForDay(DateTime day) {
    return widget.entries.where((entry) {
      return isSameDay(entry.date, day);
    }).toList();
  }

  int _getEntryCountForDay(DateTime day) {
    return _getEntriesForDay(day).length;
  }

  @override
  Widget build(BuildContext context) {
    List<Entry> entriesForSelectedDay = _getEntriesForDay(_selectedDay);

    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            firstDay: _firstDay,
            lastDay: _lastDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            focusedDay: _focusedDay,
            onDaySelected: _onDaySelected,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                int entryCount = _getEntryCountForDay(date);
                if (entryCount > 0) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 15.0,
                      height: 15.0,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          entryCount.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: entriesForSelectedDay.isEmpty
                ? const Center(child: Text('No entries for this day'))
                : ListView.builder(
                    itemCount: entriesForSelectedDay.length,
                    itemBuilder: (context, index) {
                      Entry entry = entriesForSelectedDay[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (_) => EntryFormPage(
                                    isEditable: false,
                                    userUid: widget.userTag,
                                    entry: entry,
                                    onDelete: widget.onDelete,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              )
                              .then(
                                  (_) => {setState(() {}), widget.updateAll()});
                        },
                        title: Text(entry.title),
                        subtitle: Text(entry.text),
                        leading: Text(
                          entry.icon,
                          style: const TextStyle(fontSize: 24),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
