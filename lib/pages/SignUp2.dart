import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leaf_lens/pages/SignUp3.dart';
import 'package:leaf_lens/pages/homepage.dart';

class SignUp2 extends StatefulWidget {
  final Map<String, dynamic> userData;

  const SignUp2({Key? key, required this.userData}) : super(key: key);

  @override
  _SignUp2State createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? selectedLocation;
  String? selectedPersonType;
  String? selectedDiscoverySource;
  bool _isLoading = false;

  final List<String> locations = [
    'Himalayas',
    'Deccan Plateau',
    'South India',
    'East India',
  ];

  final List<String> personTypes = [
    'Hill and wind type',
    'Sea and beach type',
    'Pine trees and river type',
    'Snow capped mountain type',
  ];

  final List<String> discoverySources = [
    'Friends',
    'Advertisement',
  ];

  Future<void> _saveUserData() async {
    if (selectedLocation == null ||
        selectedPersonType == null ||
        selectedDiscoverySource == null) {
      _showErrorDialog(
        context,
        'Missing Information',
        'Please fill in all fields before continuing.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final completeUserData = {
          ...widget.userData,
          'uid': user.uid,
          'coin': 10,
          'location': selectedLocation,
          'personType': selectedPersonType,
          'discoverySource': selectedDiscoverySource,
          'email': user.email,
          'photoURL': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        };

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(completeUserData);

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignUp3()),
                (route) => false,
          );
        }
      }
    } catch (e) {
      _showErrorDialog(
        context,
        'Error',
        'Failed to save user data: ${e.toString()}',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildDropdown({
    required String labelText,
    required IconData icon,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          labelText: labelText,
        ),
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        style: const TextStyle(color: Colors.black),
        dropdownColor: Colors.white,
        isExpanded: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/Fishing-amico.png',
                width: 300,
              ),
              const SizedBox(height: 20),
              Text(
                "Tell us more!",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Help us personalize your experience",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 30),
              _buildDropdown(
                labelText: 'Location',
                icon: Icons.location_on,
                items: locations,
                value: selectedLocation,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLocation = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildDropdown(
                labelText: 'What type of person are you?',
                icon: Icons.landscape,
                items: personTypes,
                value: selectedPersonType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPersonType = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildDropdown(
                labelText: 'How did you discover us?',
                icon: Icons.help_outline,
                items: discoverySources,
                value: selectedDiscoverySource,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDiscoverySource = newValue;
                  });
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveUserData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                    'Complete Setup',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}