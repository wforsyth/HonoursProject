import 'package:flutter/material.dart';
import 'journalEntry.dart';
import '../auth.dart';
import 'package:honours_project/constants.dart';

class EpilepsyJournal extends StatefulWidget {
  @override
  _EpilepsyJournalState createState() => _EpilepsyJournalState();
}

class _EpilepsyJournalState extends State<EpilepsyJournal> {
  List<JournalEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadJournalEntries();
  }

  Map<DateTime, List<Map<String, dynamic>>> selectedEvents = {};

  DateTime normaliseToDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  Future<void> _loadJournalEntries() async {
    try {
      List<Map<String, dynamic>> loadedEntries =
          await Auth().getJournalEntries();

      selectedEvents.clear();
      _entries.clear();

      for (var entry in loadedEntries) {
        String entryDateString = entry['date'];
        String entryTimeString = entry['time'];
        DateTime entryDate = DateTime.parse(entryDateString);
        DateTime normalisedReminderDate = normaliseToDay(entryDate);

        List<String> timeParts = entryTimeString.split(":");
        TimeOfDay entryTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
          );

        if (selectedEvents[normalisedReminderDate] == null) {
          selectedEvents[normalisedReminderDate] = [];
        }
        selectedEvents[normalisedReminderDate]!.add(entry);

        _entries.add(JournalEntry(
          date: entryDate,
          time: entryTime,
          description: entry['description'],
        ));
      }

      setState(() {});
    } catch (e) {
      print('Error getting reminders $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _entries.isEmpty
                ? Center(child: Text("No journal entries added."))
                : ListView.builder(
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      return EntryCard(entry: _entries[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalEntryScreen(),
            ),
          );
          if (result != null) {
            _loadJournalEntries();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        foregroundColor: kScaffoldColor,
        tooltip: 'Add Journal Entry',
      ),
    );
  }
}

class EntryCard extends StatefulWidget {
  final JournalEntry entry;

  const EntryCard({Key? key, required this.entry}) : super(key: key);

  @override
  _EntryCardState createState() => _EntryCardState();
}

class _EntryCardState extends State<EntryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Date: ${widget.entry.date.toLocal().toString().split(' ')[0]}',
        ),
        subtitle: Text('Time: ${widget.entry.time.format(context)}'),
        trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.entry.description),
          ),
        ],
      ),
    );
  }
}

class JournalEntry {
  final DateTime date;
  final TimeOfDay time;
  final String description;

  JournalEntry({
    required this.date,
    required this.time,
    required this.description,
  });
}
