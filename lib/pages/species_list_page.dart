import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileWithSpeciesPage extends StatefulWidget {
  const ProfileWithSpeciesPage({Key? key}) : super(key: key);

  @override
  _ProfileWithSpeciesPageState createState() => _ProfileWithSpeciesPageState();
}

class _ProfileWithSpeciesPageState extends State<ProfileWithSpeciesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> speciesList = [];
  int totalBioPoints = 0;
  int treesPlanted = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    loadSpeciesData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            userData = doc.data();
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> loadSpeciesData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('species_list') ?? [];
    final List<Map<String, dynamic>> loadedList = [];
    int bioPoints = 0;

    for (var item in savedList) {
      final splitItem = item.split('|');
      if (splitItem.length < 2) continue;

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

  Widget _buildProfileCard() {
    if (userData == null) return const SizedBox.shrink();

    return Container(
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
          CircleAvatar(
            radius: 50,
            backgroundImage: userData!['photoURL'] != null
                ? NetworkImage(userData!['photoURL'])
                : const AssetImage('assets/man.png') as ImageProvider,
          ),
          const SizedBox(height: 16.0),
          Text(
            userData!['email'] ?? 'No Email',
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16.0),
          _buildInfoRow('Location', userData!['location'] ?? 'Not specified', Icons.location_on),
          _buildInfoRow('Person Type', userData!['personType'] ?? 'Not specified', Icons.person),
          _buildInfoRow('Discovery Source', userData!['discoverySource'] ?? 'Not specified', Icons.source),
          const SizedBox(height: 16.0),
          const Text(
            'Skill Level 1 🔆',
            style: TextStyle(fontSize: 16.0, color: Colors.black54),
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
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeciesGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: speciesList
                .sublist(0, (speciesList.length / 2).ceil())
                .map((species) => _buildSpeciesCard(species['imagePath'], species['prompt']))
                .toList(),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            children: speciesList
                .sublist((speciesList.length / 2).ceil())
                .map((species) => _buildSpeciesCard(species['imagePath'], species['prompt']))
                .toList(),
          ),
        ),
      ],
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 20.0),
            if (speciesList.isNotEmpty) _buildSpeciesGrid(),
          ],
        ),
      ),
    );
  }
}