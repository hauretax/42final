import 'package:diaryapp/models/dog.dart';
import 'package:diaryapp/services/database_service.dart';
import 'package:flutter/material.dart';

class DogFormPage extends StatefulWidget {
  const DogFormPage({Key? key, this.dog}) : super(key: key);
  final Dog? dog;

  @override
  _DogFormPageState createState() => _DogFormPageState();
}

class _DogFormPageState extends State<DogFormPage> {
  final TextEditingController _nameController = TextEditingController();
  static final List<Color> _colors = [
    Color(0xFF000000),
    Color(0xFFFFFFFF),
    Color(0xFF947867),
    Color(0xFFC89234),
    Color(0xFF862F07),
    Color(0xFF2F1B15),
  ];

  final DatabaseService _databaseService = DatabaseService();

  int _selectedAge = 0;
  int _selectedColor = 0;
  int _selectedBreed = 0;

  @override
  void initState() {
    super.initState();
    if (widget.dog != null) {
      _nameController.text = widget.dog!.name;
      _selectedAge = 10;
      _selectedColor = 0;
    }
  }

  

  Future<void> _onSave() async {
    final name = _nameController.text;
    final age = _selectedAge;
    final color = _colors[_selectedColor];

    // Add save code here
    widget.dog == null
        ? await _databaseService.insertDog(
            Dog(name: name),
          )
        : await _databaseService.updateDog(
            Dog(
              id: widget.dog!.id,
              name: name,
            ),
          );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Dog Record'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter name of the dog here',
              ),
            ),
            SizedBox(height: 16.0),
            // Age Slider
            
            
            SizedBox(height: 24.0),
            // Breed Selector
            
            SizedBox(height: 24.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _onSave,
                child: Text(
                  'Save the Dog data',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}