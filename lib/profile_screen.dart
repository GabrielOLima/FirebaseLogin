import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login/button.dart';
import 'package:flutter_login/missile.dart';
import 'package:flutter_login/player.dart';

import 'ball.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

enum direction { LEFT, RIGHT }

class _ProfileScreenState extends State<ProfileScreen> {
  // player
  static double playerX = 0;

  // missile
  double missileX = playerX;
  double missileHeight = 10;
  bool midShot = false;

  // ball
  double ballX = 0.5;
  double ballY = 0;
  var ballDirection = direction.LEFT;

  void startGame() {
    resetMissile();
    midShot = false;
    ballY = 0;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (ballX - 0.02 < -1) {
        ballDirection = direction.RIGHT;
      } else if (ballX + 0.02 > 1) {
        ballDirection = direction.LEFT;
      }
      if (ballDirection == direction.LEFT) {
        setState(() {
          ballX -= 0.02;
        });
      } else if (ballDirection == direction.RIGHT) {
        setState(() {
          ballX += 0.02;
        });
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (playerX - 0.1 < -1) {
        // do nothing
      } else {
        playerX -= 0.1;
      }
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 > 1) {
        // do nothing
      } else {
        playerX += 0.1;
      }
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  double heightToCoordinate(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double missileY = 1 - 2 * height / totalHeight;
    return missileY;
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 10;
  }

  void shootMissile() {
    if (midShot == false) {
      Timer.periodic(Duration(milliseconds: 100), (timer) {
        midShot = true;
        setState(() {
          missileHeight += 10;
        });

        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          // stop missile
          resetMissile();
          timer.cancel();
          midShot = false;
        }

        if (ballY > heightToCoordinate(missileHeight) &&
            (ballX - missileX).abs() < 0.03) {
          resetMissile();
          ballY = 5;
          timer.cancel();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.pink[200],
            child: Center(
              child: Stack(
                children: [
                  MyBall(ballX: ballX, ballY: ballY),
                  MyMissile(
                    height: missileHeight,
                    missileX: missileX,
                  ),
                  MyPlayer(
                    playerX: playerX,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    icon: Icons.play_arrow,
                    function: startGame,
                  ),
                  MyButton(
                    icon: Icons.arrow_back,
                    function: moveLeft,
                  ),
                  MyButton(
                    icon: Icons.arrow_upward,
                    function: shootMissile,
                  ),
                  MyButton(
                    icon: Icons.arrow_forward,
                    function: moveRight,
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
