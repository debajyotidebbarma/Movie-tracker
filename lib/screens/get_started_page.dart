import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'login_page.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircleAvatar(
        backgroundColor: HexColor('#f5f6f8'),
        child: Column(
          children: [
            Spacer(),
            Text('Movie Tracker', style: Theme.of(context).textTheme.headline3),
            SizedBox(
              height: 50,
            ),
            Text('"Watch and Chill"',
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 29,
                    fontStyle: FontStyle.italic)),
            SizedBox(
              height: 50,
            ),
            TextButton.icon(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: HexColor('#69639f'),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: Icon(Icons.login_rounded),
                label: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('Sign in to Get Started'))),
            Spacer(),
          ],
        ),
      ),
    );
  }
}


