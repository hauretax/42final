import 'package:flutter/material.dart';

List<String> dailyFeelings = [
  '😊', // Joie
  '😄', // Bonne humeur
  '😍', // Amour
  '😎', // Confiance
  '🥳', // Excitation
  '😇', // Satisfaction
  '😂', // Amusement
  '😔', // Tristesse
  '😟', // Inquiétude
  '😕', // Confusion
  '😠', // Colère
  '😴', // Fatigue
  '😞', // Déception
  '😕', // Perplexité
  '🤔', // Réflexion
];

class SmileySelector extends StatefulWidget {
  final Function(String) onSmileySelected;

  const SmileySelector({super.key, required this.onSmileySelected});

  @override
  // ignore: library_private_types_in_public_api
  _SmileySelectorState createState() => _SmileySelectorState();
}

class _SmileySelectorState extends State<SmileySelector> {
  String selectedSmiley = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          'Comment vous sentez-vous aujourd\'hui ?',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          selectedSmiley,
          style: const TextStyle(fontSize: 50),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: dailyFeelings.map((feeling) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSmiley = feeling;
                });
                widget.onSmileySelected(selectedSmiley);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: feeling == selectedSmiley
                        ? Colors.blue
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Text(
                  feeling,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
