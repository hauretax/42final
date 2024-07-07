import 'package:diaryfinalapp/models/entry.dart';
import 'package:diaryfinalapp/pages/entry_form_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarLandscapePage extends StatefulWidget {
  final List<Entry> entries;
  final String userTag;
  final Function() updateAll;
  final Function(Entry) onDelete;
  const CalendarLandscapePage(
      {required this.entries,
      required this.onDelete,
      required this.updateAll,
      required this.userTag,
      super.key});

  @override
  _CalendarLandscapePageState createState() => _CalendarLandscapePageState();
}

class _CalendarLandscapePageState extends State<CalendarLandscapePage> {
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
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Scrollable(viewportBuilder: (context, position) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: TableCalendar(
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
              );
            }),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                                      userUid: widget.userTag,
                                      entry: entry,
                                      onDelete: widget.onDelete,
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                )
                                .then((_) =>
                                    {setState(() {}), widget.updateAll()});
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
          ),
        ],
      ),
    );
  }
}
