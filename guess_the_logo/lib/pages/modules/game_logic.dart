import 'package:flutter/material.dart';
import 'package:guess_the_logo/highscore/highscore.dart';
import 'package:provider/provider.dart';

import 'dart:math';

class RandomLogoWidget extends StatefulWidget {
  final VoidCallback updateScore;
  const RandomLogoWidget(this.updateScore, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RandomLogoWidgetState createState() => _RandomLogoWidgetState();
  
}

class _RandomLogoWidgetState extends State<RandomLogoWidget> {
  Map<String, List<String>> logoDictionary = {
    'Google': ['Google', 'Amazon', 'Steam', 'OperaGX'],
    'Apple': ['Apple', 'Samsung', 'Huawei', 'LG'],
    'Facebook': ['Facebook', 'Twitter', 'Nestle', 'OpenBook'],
    'BMW': ['BMW', 'VW', 'Audi', 'Nesscaffe'],
    // Add more logo entries and their corresponding answers here
  };
  List<String> logosSet = [];
  List<String> selectedAnswers = [];
  String selectedLogo = '';

  @override
  void initState() {
    super.initState();
    selectRandomLogo();
  }

  void selectRandomLogo() {
    final random = Random();
    if(logosSet.isEmpty){
      logosSet = logoDictionary.keys.toList();
    }
    int randomElement = random.nextInt(logosSet.length);
    String randomLogo = logosSet[randomElement];
    logosSet.remove(logosSet[randomElement]);
    List<String> answers = logoDictionary[randomLogo]!;
    answers.shuffle();
    setState(() {
      selectedLogo = randomLogo;
      selectedAnswers = answers;
    });
  }

  int score=0;
  void selectionMade(myAnswer) {
    if(selectedLogo == myAnswer){
      score++;
      widget.updateScore();
      selectRandomLogo();
    }
    else{
      int highscore = Provider.of<HighscoreProvider>(context, listen: false).highscore;
      if(score > highscore){
        highscore = score;
      }
      Provider.of<HighscoreProvider>(context, listen: false).updateHighscore(highscore);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Randomly Selected Logo:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 200,
          height: 200,
          child: Image.asset('assets/$selectedLogo.png', fit: BoxFit.contain),
        ),
        const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  selectionMade(selectedAnswers[0]);
                },
                child: Text(selectedAnswers[0]),
              ),
              TextButton(
                onPressed: () {
                  selectionMade(selectedAnswers[1]);
                },
                child: Text(selectedAnswers[1]),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  selectionMade(selectedAnswers[2]);
                },
                child: Text(selectedAnswers[2]),
              ),
              TextButton(
                onPressed: () {
                  selectionMade(selectedAnswers[3]);
                },
                child: Text(selectedAnswers[3]),
              ),
            ],
          ),
      ],
    );
  }
}

class LogoWithButtonsWidget extends StatelessWidget {
  final VoidCallback updateScore;
  const LogoWithButtonsWidget(this.updateScore, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          RandomLogoWidget(updateScore),
        ],
      ),
    );
  }
}