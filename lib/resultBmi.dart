import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class resultBmi extends StatelessWidget {
  static const String id = 'resultBmi';

  resultBmi(
      {@required this.bmiresult,
      @required this.resultText,
      @required this.interpretation});

  final double bmiresult;
  final String resultText;
  final String interpretation;

  String resultValue;
  void fun() {
    resultValue = bmiresult.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    fun();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60.0,
        title: Text(
          'BMI Result',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text(
              'Bmi',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
          //SizedBox(height: 2.0),
          Text(
            '$resultValue',
            style: TextStyle(
              fontSize: 70.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            'Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              color: Colors.purple,
            ),
          ),
          Text(
            '$resultText',
            style: TextStyle(
              fontSize: 45.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            'Comment',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 80.0, right: 30.0, bottom: 20.0),
            child: Text(
              '$interpretation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
