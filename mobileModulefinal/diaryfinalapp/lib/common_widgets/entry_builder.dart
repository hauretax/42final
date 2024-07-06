import 'package:diaryfinalapp/models/entry.dart';
import 'package:flutter/material.dart';

class EntryBuilder extends StatelessWidget {
  const EntryBuilder({
    Key? key,
    required this.future,
    required this.onEdit,
  }) : super(key: key);
  final Future<List<Entry>> future;
  final Function(Entry) onEdit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Entry>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: snapshot.data != null
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final entry = snapshot.data![index];
                    return _buildEntryCard(entry, context);
                  },
                )
              : const Text('No data registred'),
        );
      },
    );
  }

  Widget _buildEntryCard(Entry entry, BuildContext context) {
    DateTime dateTime = DateTime.parse(entry.date.toString());
    return GestureDetector(
        onTap: () => onEdit(entry),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  alignment: Alignment.center,
                  child: Text(entry.icon),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.title,
                    // overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(children: [
                    Text(
                      '${dateTime.year}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${dateTime.day}/${dateTime.month.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ));
  }
}
