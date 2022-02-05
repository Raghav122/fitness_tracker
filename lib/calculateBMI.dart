import 'package:fitness_tracker/resultBmi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class calculateBMI extends StatefulWidget {
  static const String id = 'calculateBMI';
  @override
  _calculateBMIState createState() => _calculateBMIState();
}

int weight;
int height;
String heights;
String weights;
double finalAns;

class _calculateBMIState extends State<calculateBMI> {
  double bmiResult() {
    double result;
    height = int.parse(heights);
    weight = int.parse(weights);
    double heightMeter = height / 100;
    result = weight / (heightMeter * heightMeter);
    //result = result.toStringAsFixed(2) as double;
    return result;
  }

  String getResult() {
    if (finalAns >= 25.0) {
      return 'OVER WEIGHT';
    } else if (finalAns > 18.5) {
      return 'NORMAL';
    } else {
      return 'UNDER WEIGHT';
    }
  }

  String getInterpretation() {
    if (finalAns >= 25.0) {
      return 'You have a higher than normal BMI!! EXERCISE MORE';
    } else if (finalAns > 18.5) {
      return 'You have a Normal BMI. Great !!';
    } else {
      return 'You have a lower than normal BMI!! EAT MORE ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        title: Text(
          'Calculate BMI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          SizedBox(height: 60.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            child: TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (value) {
                heights = value;
              },
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  hintText: 'Enter height (in cm)',
                  hintStyle: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                  )),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            child: TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (value) {
                weights = value;
              },
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  hintText: 'Enter weight (in kg)',
                  hintStyle: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                  )),
            ),
          ),
          SizedBox(height: 15.0),
          FlatButton(
            onPressed: () {
              finalAns = bmiResult();
              String text = getResult();
              String Interpret = getInterpretation();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => resultBmi(
                            bmiresult: finalAns,
                            resultText: text,
                            interpretation: Interpret,
                          )));
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Calculate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
