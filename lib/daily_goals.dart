import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness/fitness.dart';
import 'package:healthhub/healthhub.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_screen.dart';

int noOfGoalsAchieved = 0;
var firebasegoal;

class daily_goals extends StatefulWidget {
  static const String id = 'daily_goals';

  @override
  _daily_goalsState createState() => _daily_goalsState();
}

class _daily_goalsState extends State<daily_goals> {
  int dailyGoal = -1;
  final goalHolder = TextEditingController();

  String temp = '';
  String textHint() {
    //globalDailyGoal = dailyGoal;
    if (globalDailyGoal == -1) {
      return 'Enter no of steps';
    } else if (globalDailyGoal == -2) {
      return '';
    } else {
      return '$globalDailyGoal Steps';
    }
  }

  List<DataPoint> _todaysteps = [];
  List<DataPoint> _dataPoint = [];
  int stepstoday;
  int step1, step2, step3, step4, step5, step6, totalSteps = 0;
  String date1, date2, date3, date4, date5, date6;
  String day1,
      day2,
      day3,
      day4,
      day5,
      day6,
      month1,
      month2,
      month3,
      month4,
      month5,
      month6;
  String datetoday = DateTime.now().day.toString();
  int month = DateTime.now().month;

  final Date = DateTime.now();
  String getmonth(int mo) {
    if (month == 1) {
      return 'January';
    } else if (month == 2) {
      return 'February';
    } else if (month == 3) {
      return 'March';
    } else if (month == 4) {
      return 'April';
    } else if (month == 5) {
      return 'May';
    } else if (month == 6) {
      return 'June';
    } else if (month == 7) {
      return 'July';
    } else if (month == 8) {
      return 'August';
    } else if (month == 9) {
      return 'September';
    } else if (month == 10) {
      return 'October';
    } else if (month == 11) {
      return 'November';
    } else if (month == 12) {
      return 'December';
    }
  }

  String months;

  Icon isGoalAchieved(int steps) {
    if (steps == null) {
      steps = 0;
    }
    if (noOfGoalsAchieved > 0 && steps == stepstoday) {
      setState(() {
        noOfGoalsAchieved = 0;
      });
    }
    if (globalDailyGoal == -1) {
      setState(() {
        noOfGoalsAchieved = 0;
      });
      return Icon(Icons.assignment_late_outlined,
          color: Colors.red, size: 53.0);
    } else if (steps >= (globalDailyGoal)) {
      setState(() {
        noOfGoalsAchieved++;
      });
      print(
          '======================global daily goal $globalDailyGoal============================================No of Goals achieved $noOfGoalsAchieved ---------');

      return Icon(Icons.assignment_turned_in_outlined,
          color: Colors.green, size: 53.0);
    } else {
      return Icon(
        Icons.assignment_late_outlined,
        color: Colors.red,
        size: 53.0,
      );
    }
  }

  Future<void> data() async {
    await readdata();
  }

  @override
  void initState() {
    data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Activity'),
        backgroundColor: Colors.purple,
        toolbarHeight: 60.0,
      ),
      body: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 10.0, top: 40.0, bottom: 20.0),
              child: Text(
                'Set Your Daily Step Goal ',
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                controller: goalHolder,
                onTap: () {
                  setState(() {
                    globalDailyGoal = -2;
                  });
                  goalHolder.clear();
                },
                onSubmitted: (value) async {
                  setState(() {
                    globalDailyGoal = int.parse(value);
                    print(
                        'gloabal daily goal on submitted $globalDailyGoal - - - -- - - - - -- - - - - - - - -- - - - ');
                  });
                  await FirebaseFirestore.instance
                      .collection('fitness_tracker')
                      .where('user', isEqualTo: loggedinuser.email)
                      .get()
                      .then((QuerySnapshot querySnapshot) async {
                    if (querySnapshot.docs.isNotEmpty) {
                      if (value == '') {
                        await FirebaseFirestore.instance
                            .collection('fitness_tracker')
                            .doc(loggedinuser.email)
                            .update({'dailyStepGoal': 0}).catchError((e) {
                          print(e);
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection('fitness_tracker')
                            .doc(loggedinuser.email)
                            .update({
                          "dailyStepGoal": globalDailyGoal,
                        }).catchError((e) {
                          print(e);
                        });
                      }
                    } else {
                      if (value == '') {
                        final docref = await FirebaseFirestore.instance
                            .collection('fitness_tracker')
                            .doc(loggedinuser.uid)
                            .set({
                          'user': loggedinuser.email,
                          'dailyStepGoal': 0,
                        });
                      } else {
                        final docref = await FirebaseFirestore.instance
                            .collection('fitness_tracker')
                            .doc(loggedinuser.email)
                            .set({
                          'user': loggedinuser.email,
                          'dailyStepGoal': globalDailyGoal,
                        });
                      }
                    }
                  });

                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    hintText: textHint(),
                    hintStyle: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.normal,
                      fontSize: 25.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide.none,
                    )),
              ),
            ),
            Divider(
              thickness: 3.0,
              indent: 30.0,
              endIndent: 30.0,
              color: Colors.blue,
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Day',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: Colors.purple,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    'Goal Achieved',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        '$datetoday $months',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 30.0,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Text(
                        '$stepstoday steps',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 80.0, bottom: 20.0),
                  child: isGoalAchieved(stepstoday),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        '$date1 $month1',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 30.0,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Text(
                        '$step1 steps',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 80.0, bottom: 20.0),
                  child: isGoalAchieved(step1),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        '$date2 $month2',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 30.0,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Text(
                        '$step2 steps',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 80.0, bottom: 20.0),
                  child: isGoalAchieved(step2),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        '$date3 $month3',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 30.0,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Text(
                        '$step3 steps',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 80.0, bottom: 20.0),
                  child: isGoalAchieved(step3),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        '$date4 $month4',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 30.0,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Text(
                        '$step4 steps',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 80.0, bottom: 20.0),
                  child: isGoalAchieved(step4),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        '$date5 $month5',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 30.0,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Text(
                        '$step5 steps',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 80.0, bottom: 20.0),
                  child: isGoalAchieved(step5),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        '$date6 $month6',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 30.0,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Text(
                        '$step6 steps',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 80.0, bottom: 20.0),
                  child: isGoalAchieved(step6),
                ),
              ],
            ),
            SizedBox(height: 30.0),
          ],
        ),
      ]),
    );
  }

  Future<void> readdata() async {
    DateTime current = DateTime.now();

    DateTime dateTimeto = DateTime.now().subtract(Duration(
        hours: current.hour, minutes: current.minute, seconds: current.second));

    DateTime datefrom = dateTimeto.subtract(const Duration(days: 1));

    final result = await Fitness.read(
        timeRange: TimeRange(start: datefrom, end: dateTimeto),
        bucketByTime: 1,
        timeUnit: TimeUnit.days);
    final results = await Fitness.read(
        timeRange: TimeRange(start: dateTimeto, end: DateTime.now()),
        bucketByTime: 1,
        timeUnit: TimeUnit.days);

    await FirebaseFirestore.instance
        .collection('fitness_tracker')
        .where('user', isEqualTo: loggedinuser.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        firebasegoal = querySnapshot.docs[0].data();
        setState(() {
          globalDailyGoal = firebasegoal['dailyStepGoal'];
        });
      } else {
        setState(() {
          globalDailyGoal = -1;
        });
      }
    });

    _todaysteps = results;
    _dataPoint = result;

    setState(() {
      step1 = _dataPoint[0].value;
      stepstoday = _todaysteps[0].value;
      totalSteps += step1.toInt();
      totalSteps += stepstoday.toInt();
      date1 = datefrom.day.toString();
      months = getmonth(month);
      month1 = getmonth(datefrom.month);
    });
    for (int i = 1; i <= 5; i++) {
      List<DataPoint> _datapoints = [];
      dateTimeto = dateTimeto.subtract(const Duration(days: 1));
      datefrom = datefrom.subtract(const Duration(days: 1));
      final results = await Fitness.read(
          timeRange: TimeRange(start: datefrom, end: dateTimeto),
          bucketByTime: 1,
          timeUnit: TimeUnit.days);
      _datapoints = results;

      if (i == 1) {
        setState(() {
          step2 = _datapoints[0].value;
          totalSteps += step2.toInt();
          date2 = datefrom.day.toString();
          month2 = getmonth(datefrom.month);
        });
      } else if (i == 2) {
        setState(() {
          step3 = _datapoints[0].value;
          totalSteps += step3.toInt();
          date3 = datefrom.day.toString();
          month3 = getmonth(datefrom.month);
        });
      } else if (i == 3) {
        setState(() {
          step4 = _datapoints[0].value;
          totalSteps += step4.toInt();
          date4 = datefrom.day.toString();
          month4 = getmonth(datefrom.month);
        });
      } else if (i == 4) {
        setState(() {
          step5 = _datapoints[0].value;
          totalSteps += step5.toInt();
          date5 = datefrom.day.toString();
          month5 = getmonth(datefrom.month);
        });
      } else {
        setState(() {
          step6 = _datapoints[0].value;
          totalSteps += step6.toInt();
          date6 = datefrom.day.toString();
          month6 = getmonth(datefrom.month);
        });
      }
    }
  }
}
