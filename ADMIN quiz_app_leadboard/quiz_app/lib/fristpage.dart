import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/controller/getdata_firebase.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    final functionsProvider = Provider.of<FunctionsProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Center(child: Text('Leaderboard')),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height:
                        screenHeight * 0.01), // Space between header and rows

                StreamBuilder<List<UserData>>(
                  stream: functionsProvider.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available.'));
                    } else {
                      final userDataList = snapshot.data!
                          .where((user) =>
                              user.userName.isNotEmpty &&
                              user.photoUrl.isNotEmpty)
                          .toSet()
                          .toList();

                      userDataList.sort((a, b) {
                        // Convert timeTaken to integer for proper comparison
                        int timeTakenA = int.tryParse(a.timeTaken) ?? 0;
                        int timeTakenB = int.tryParse(b.timeTaken) ?? 0;
                        int scoreA = int.tryParse(a.score) ?? 0;
                        int scoreB = int.tryParse(b.score) ?? 0;
                        // Compare by score in descending order
                        int scoreComparison = scoreB.compareTo(scoreA);

                        // If scores are the same, compare by timeTaken in ascending order
                        if (scoreComparison == 0) {
                          return timeTakenA.compareTo(timeTakenB);
                        }
                        return scoreComparison;
                      });

                      print("Sorted List:");
                      for (var user in userDataList) {
                        print(
                            "${user.userName}: Score ${user.score}, Time ${user.timeTaken}");
                      }

                      return Column(
                        children: userDataList.asMap().entries.map((entry) {
                          int index = entry.key;
                          UserData userData = entry.value;
                          DateTime dateTime = userData.timestamp.toDate();
                          String formattedDate =
                              DateFormat('dd MMM yyyy, hh:mm a')
                                  .format(dateTime);
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 4),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01),
                            child: Padding(
                              padding: EdgeInsets.all(screenHeight * 0.02),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      (index + 1).toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.02),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Card(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                userData.photoUrl!,
                                              ),
                                              fit: BoxFit.cover,
                                            )),
                                        height: screenHeight * 0.15,
                                        width: screenWidth * 0.006,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      userData.userName!.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenHeight * 0.025),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      userData.score.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: screenHeight * 0.028),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${userData.timeTaken} sec',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: screenHeight * 0.028),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      formattedDate,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenHeight * 0.018),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
