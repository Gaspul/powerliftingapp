import 'package:flutter/material.dart';
import 'package:powerliftingapp/input%20page/bpconfirm.dart';
import 'package:powerliftingapp/input%20page/dlconfirm.dart';
import 'package:powerliftingapp/input%20page/sqconfirm.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('PowerAssistant by Angga Syfa Kurniawan'),
        elevation: 15.0,
      ),
      backgroundColor:  Colors.grey,
      body: Container(
        padding: EdgeInsets.all(60),
        child:ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Choose Your Workout : ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 40,
              )
            ),
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.grey,
              ),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SQConfirm()),
                );
              },
              child: Text(
                'SQUAT',
                style: TextStyle(
                  color: Colors.white
                ),
                ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.grey,
              ),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DLConfirm()),
                );
              },
              child: Text(
                'DEADLIFT',
                style: TextStyle(
                  color: Colors.white
                ),
                ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.grey,
              ),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BPConfirm()),
                );
              },
              child: Text(
                'BENCH PRESS',
                style: TextStyle(
                  color: Colors.white
                ),
                ),
            ),
          ],
          )
      )
    );
  }
}