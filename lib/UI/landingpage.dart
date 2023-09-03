import 'package:flutter/material.dart';
import 'package:powerliftingapp/UI/mainmenu.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LandingPage> {

  @override
  Widget build(BuildContext context) {

     return Scaffold(
      appBar: AppBar(
        title: const Text('PowerAssistant by Angga Syfa Kurniawan'),
        elevation: 15.0,
      ),
      backgroundColor:  Colors.grey,
      body: Container(
        padding: EdgeInsets.all(35),
        child: ListView(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/Powercrop.png')
                )
              )
            ),
            Text(
              'Gettin Strong With\nPower Assistant',
              textAlign: TextAlign.center, 
              style: TextStyle(           
                color: Colors.black,
                fontSize: 40,
              )
            ),
            const Divider(
              height: 30,
              thickness: 5,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            SizedBox(height: 10,),
            Text(
                'Lets get started and put on some iron !!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.grey,
              ),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainMenu()),
                );
              },
              child: Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white
                ),
                ),
            ),
          ]
        ),
      )
    );
  }
}