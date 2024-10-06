import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeciesListPage extends StatefulWidget {
  const SpeciesListPage({super.key});

  @override
  _SpeciesListPageState createState() => _SpeciesListPageState();
}

class _SpeciesListPageState extends State<SpeciesListPage> {
  List<Map<String, dynamic>> speciesList = [];
  int totalBioPoints = 0;
  int treesPlanted = 0;
  String username = '';

  @override
  void initState() {
    super.initState();
    loadSpeciesData();
    loadUsername();
  }

  Future<void> loadSpeciesData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('species_list') ?? [];
    final List<Map<String, dynamic>> loadedList = [];
    int bioPoints = 0;

    for (var item in savedList) {
      final splitItem = item.split('|');
      if (splitItem.length < 2) {
        continue;
      }
      final prompt = splitItem[0];
      final imagePath = splitItem[1];
      final rarityScale = int.tryParse(splitItem.length > 2 ? splitItem[2] : '0') ?? 0;
      bioPoints += rarityScale;

      loadedList.add({
        'prompt': prompt,
        'imagePath': imagePath,
        'rarityScale': rarityScale,
      });
    }

    setState(() {
      speciesList = loadedList;
      totalBioPoints = bioPoints;
      prefs.setInt('total_bio_points', totalBioPoints);
    });
  }

  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';
    });
  }

  void donateBioPoints() {
    if (totalBioPoints >= 10) {
      setState(() {
        treesPlanted += totalBioPoints ~/ 10;
        totalBioPoints %= 10;
        SharedPreferences.getInstance().then((prefs) {
          prefs.setInt('total_bio_points', totalBioPoints);
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough bio points to plant a tree!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/man.png'),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Skill Level 1 🔆',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.grey[300],
                    minHeight: 10,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Discovered Species: ${speciesList.length} 🐼',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Total Bio Points: $totalBioPoints 🪙',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: donateBioPoints,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    ),
                    child: const Text(
                      'Donate Bio Points to Plant Trees 🥺🙏',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Trees Planted: $treesPlanted 🌳',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: speciesList
                        .sublist(0, (speciesList.length / 2).ceil())
                        .map((species) {
                      final imagePath = species['imagePath'];
                      final prompt = species['prompt'];
                      return _buildSpeciesCard(imagePath, prompt);
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    children: speciesList
                        .sublist((speciesList.length / 2).ceil())
                        .map((species) {
                      final imagePath = species['imagePath'];
                      final prompt = species['prompt'];
                      return _buildSpeciesCard(imagePath, prompt);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeciesCard(String imagePath, String prompt) {
    return Card(
      color: Colors.lightGreen[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                  height: 120,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              prompt,
              style: const TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}