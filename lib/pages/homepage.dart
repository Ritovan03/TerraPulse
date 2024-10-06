import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaf_lens/controllers/gemini_controller.dart';
import 'package:get/get.dart';
import 'package:leaf_lens/pages/species_list_page.dart';
import 'package:leaf_lens/pages/vision_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Row(
          children: [
            Text(
              '🌏',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              'Terra Pulse',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: const Text("Made by"),
                      content: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Abhijit Patil (lead)",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Flutter-dev",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Ritovan Dasgupta",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Flutter dev",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),

                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "💖Love it!",
                            style: TextStyle(color: Colors.pink),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: _page(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'MarketPlace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _page(int index) {
    switch (index) {
      case 0:
        return const VisionPage();
      case 1 :
        return const Marketplacepage();
      case 2:
        return LeaderboardPage(userBioPoints: totalBioPoints, username: username);
      case 3:
        return const SpeciesListPage();
      default:
        return const VisionPage();
    }
  }
}

class Marketplacepage extends StatelessWidget{

  const Marketplacepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Market place 🛍️🛒',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }



}


class LeaderboardPage extends StatelessWidget {
  final int userBioPoints;
  final String username;

  const LeaderboardPage({super.key, required this.userBioPoints, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              '🏁Leaderboard🏁',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            _buildLeaderboardItem(1, 'Abhijit', 500, 'assets/abhijit.png', gradientColors: [const Color(0xFFFFAFBD), const Color(0xFFC9FFBF)]),
            _buildLeaderboardItem(2, 'Ritovan', 450, 'assets/ritovan.jpg', gradientColors: [const Color(0xFF74EBD5), const Color(0xFFACB6E5)]),
            _buildLeaderboardItem(3, 'Naman', 400, 'assets/robot.png', gradientColors: [const Color(0xFFFFE3E3), const Color(0xFFDBE7FC)]),
            _buildLeaderboardItem(4, username, userBioPoints, 'assets/man.png', gradientColors: [const Color(0xFFE8F7FF), const Color(0xFFD1F2EB)]),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(int rank, String username, int score, String photoPath, {List<Color>? gradientColors}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: gradientColors ?? [const Color(0xFF74EBD5), const Color(0xFFACB6E5)],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(photoPath),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rank $rank',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      username,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              'Bio Points: $score',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
