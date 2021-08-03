import 'dart:html';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'peluso.dev',
      theme: ThemeData(scaffoldBackgroundColor: Colors.lightBlue),
      home: const MyHomePage(title: 'peluso.dev'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SizedBox.expand(
            child: Container(
          color: Color.fromARGB(255, 0, 20, 199),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 175.0,
              fontFamily: 'Blockstepped',
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText('peluso.dev',
                    speed: const Duration(milliseconds: 200)),
              ],
              isRepeatingAnimation: false,
              onTap: () {},
            ),
          ),
        )));
  }
}
