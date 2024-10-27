import 'package:flutter/material.dart';
import 'dart:ui'; // Add this import for ImageFilter
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaf_lens/controllers/gemini_controller.dart';
import 'package:get/get.dart';
import 'package:leaf_lens/pages/species_list_page.dart';
import 'package:leaf_lens/pages/vision_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LeaderboardPage.dart';
import 'MarketPlace.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  GeminiChatController geminiChatController = Get.find();
  int totalBioPoints = 0;
  String username = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      geminiChatController.streamAnswer.value = "";
    });
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalBioPoints = prefs.getInt('total_bio_points') ?? 0;
      username = prefs.getString('username') ?? 'You';
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      appBar: _buildGlassAppBar(context),
      body: _page(_selectedIndex), // Fix: Call _page with _selectedIndex
      bottomNavigationBar: _buildGlassBottomNav(context),
    );
  }

  PreferredSizeWidget _buildGlassAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title:
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '🌏',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.9),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'Terra Pulse',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildInfoButton(context),
                ],
              ),



            ),

          ),
        ),
      ),
    );
  }

  Widget _buildInfoButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.info_outline, color: Colors.white),
        onPressed: () => _showCreditsDialog(context),
      ),
    );
  }

  Widget _buildGlassBottomNav(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              unselectedItemColor: Colors.grey.withOpacity(0.7),
              selectedItemColor: Colors.green,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped, // Fix: Use _onItemTapped instead of onItemTapped
              type: BottomNavigationBarType.fixed,
              items: _buildNavItems(),
            ),
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavItems() {
    return [
      _buildNavItem(Icons.home_rounded, 'Home'),
      _buildNavItem(Icons.shopping_bag_rounded, 'Market'),
      _buildNavItem(Icons.leaderboard_rounded, 'Leaders'),
      _buildNavItem(Icons.person_rounded, 'Profile'),
    ];
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _selectedIndex == _getItemIndex(label)
              ? Colors.green.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon),
      ),
      label: label,
    );
  }

  int _getItemIndex(String label) {
    switch (label) {
      case 'Home':
        return 0;
      case 'Market':
        return 1;
      case 'Leaders':
        return 2;
      case 'Profile':
        return 3;
      default:
        return 0;
    }
  }

  void _showCreditsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text(
              "Made with 💚",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            content: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCreatorInfo(
                    name: "Abhijit Patil",
                    role: "Flutter-dev",
                    isLead: true,
                  ),
                  const SizedBox(height: 16),
                  _buildCreatorInfo(
                    name: "Ritovan Dasgupta",
                    role: "Flutter dev",
                    isLead: false,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.pink.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, color: Colors.pink.shade300, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "Love it!",
                      style: TextStyle(color: Colors.pink.shade300),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCreatorInfo({
    required String name,
    required String role,
    required bool isLead,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isLead ? Icons.stars_rounded : Icons.code_rounded,
            color: Colors.green,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (isLead)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'LEAD',
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _page(int index) {
    switch (index) {
      case 0:
        return const VisionPage();
      case 1:
        return const MarketplacePage();
      case 2:
        return LeaderboardPage(userBioPoints: totalBioPoints, username: username);
      case 3:
        return const ProfileWithSpeciesPage();
      default:
        return const VisionPage();
    }
  }
}