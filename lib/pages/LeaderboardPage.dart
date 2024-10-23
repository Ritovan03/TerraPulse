import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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