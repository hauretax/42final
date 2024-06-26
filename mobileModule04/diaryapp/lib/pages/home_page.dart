
import 'package:diaryapp/common_widgets/dog_builder.dart';
import 'package:diaryapp/models/dog.dart';
import 'package:diaryapp/pages/dog_form_page.dart';
import 'package:diaryapp/services/database_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Dog>> _getDogs() async {
    return await _databaseService.dogs();
  }

  Future<void> _onDogDelete(Dog dog) async {
    await _databaseService.deleteDog(dog.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dog Database'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Dogs'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Breeds'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DogBuilder(
              future: _getDogs(),
              onEdit: (value) {
                {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => DogFormPage(dog: value),
                          fullscreenDialog: true,
                        ),
                      )
                      .then((_) => setState(() {}));
                }
              },
              onDelete: _onDogDelete,
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                
              },
              heroTag: 'addBreed',
            ),
            SizedBox(height: 12.0),
            
          ],
        ),
      ),
    );
  }
}