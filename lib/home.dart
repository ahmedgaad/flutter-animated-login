import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text(
            'Welcome',
          style: TextStyle(
            fontSize: 39.0,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
