import 'package:fitness_tracker/calculateBMI.dart';
import 'package:fitness_tracker/daily_goals.dart';
import 'package:fitness_tracker/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/fitness.dart';
import 'package:healthhub/healthhub.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'weeklyData.dart';
import 'daily_goals.dart';

final _firestore = FirebaseFirestore.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
User loggedinuser = FirebaseAuth.instance.currentUser;
String displayName = loggedinuser.displayName;
var firebaseGoalHome;
int popUpShown = 0;
int snackbarshown = 0;
int globalDailyGoal = -1;

enum PermissionStatus {
  granted,
  denied,
}
Future<void> signOutGoogle() async {
  await _googleSignIn.disconnect();
  await FirebaseAuth.instance.signOut();
  print("User Signed Out");
}

class homeScreen extends StatefulWidget {
  // ignore: camel_case_types
  static const String id = 'home_screen';
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  // ignore: camel_case_types
  List<Widget> _list = [];
  int steps;
  String energy;
  String distance;
  List<DataPoint> _datapoint = [];

  Future<void> data() async {
    await readData();
  }

  Future<void> _refresh() async {
    readData();
    await Future.delayed(Duration(seconds: 2));
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
        backgroundColor: Colors.purple,
        toolbarHeight: 60.0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          TextButton(
              child: Icon(
                Icons.launch,
                color: Colors.white,
              ),
              onPressed: () {
                //showAlertDialog(context);
                return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('Warning'),
                          content: Text('Do you want to logout ?'),
                          actions: <Widget>[
                            // ignore: deprecated_member_use
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () {
                                signOutGoogle();
                                Fluttertoast.showToast(
                                    msg: "Signed Out Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.popAndPushNamed(
                                    context, welcomeScreen.id);
                              },
                            ),
                            TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                })
                          ],
                        ));
              }),
        ],
        title: Text(
          'Fitness Tracker',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
                  child: Text(
                    '$displayName',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                        color: Colors.deepPurple),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 225.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$steps',
                        style: TextStyle(
                          fontSize: 70.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //showSnackbar(),
                      SizedBox(height: 20.0),
                      Text(
                        'Steps',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 15.0, top: 15.0, right: 7.0, bottom: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        height: 200.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '$distance ',
                              style: TextStyle(
                                fontSize: 40.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 1.0),
                            Text(
                              'km',
                              style: TextStyle(
                                fontSize: 27.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'Distance Covered ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            // SizedBox(height: 5.0),
                            // Text(
                            //   '(approx)',
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 20.0,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 7.0, top: 15.0, right: 15.0, bottom: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        height: 200.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '$energy ',
                              style: TextStyle(
                                fontSize: 40.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 1.0),
                            Text(
                              'k',
                              style: TextStyle(
                                fontSize: 27.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'Calories burnt',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 15.0, bottom: 15.0),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, daily_goals.id);
                    },
                    child: Container(
                      height: 180.0,
                      child: Material(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10.0),
                          elevation: 20.0,
                          // height: 70.0,
                          // margin: EdgeInsets.all(15.0),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 12.0,
                                        bottom: 7.0),
                                    child: Text(
                                      'Your daily goals',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 27.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, bottom: 16.0, right: 12.0),
                                    child: Text(
                                      'Last 7 days',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 45.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Text(
                                      '$noOfGoalsAchieved/7',
                                      style: TextStyle(
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 2.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 2.0, top: 4.0, bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 12.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12.0, bottom: 6.0),
                                    child: Text(
                                      'Achieved',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 2.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'S',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'M',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'T',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'W',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'T',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'F',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 17.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'S',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 15.0, bottom: 15.0),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, calculateBMI.id);
                    },
                    child: Container(
                      height: 70.0,
                      child: Material(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10.0),
                        elevation: 20.0,
                        // height: 70.0,
                        // margin: EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            'Tap to Check BMI !',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 15.0, bottom: 15.0),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => weekly_data()));
                      // Navigator.pushNamed(context, weekly_data.id);
                    },
                    child: Container(
                      height: 200.0,
                      child: Material(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10.0),
                          elevation: 20.0,
                          // height: 70.0,
                          // margin: EdgeInsets.all(15.0),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 12.0,
                                        bottom: 4.0),
                                    child: Text(
                                      'Steps',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, bottom: 12.0, right: 12.0),
                                    child: Text(
                                      'Last 7 days',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Divider(
                                thickness: 0.5,
                                indent: 78.0,
                                endIndent: 20.0,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Text(
                                      '$steps',
                                      style: TextStyle(
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 2.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 2.0, top: 4.0, bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 12.0,
                                        top: 4.0,
                                        bottom: 1.0),
                                    child: Icon(
                                      Icons.adjust_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12.0, bottom: 6.0),
                                    child: Text(
                                      'Today',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 2.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'S',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'M',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'T',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'W',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'T',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 2.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'F',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0,
                                        right: 17.0,
                                        top: 0.0,
                                        bottom: 1.0),
                                    child: Text(
                                      'S',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> requestPermissions() async {
    final result = await Fitness.requestPermission();
    // final _healthhub = await Healthhub.requestAuthorization();
    bool _res = await readPermissions();
    if (_res == true) {
      return true;
    }
    return false;
  }

  Future<bool> readPermissions() async {
    bool result = await Fitness.hasPermission();
    final _healthhub = await Healthhub.requestAuthorization();
    if (result == true) {
      return true;
    }
    bool finalres = await requestPermissions();
    if (finalres) {
      return true;
    }
    return false;
  }

  Future<void> readData() async {
    bool res = await readPermissions();

    setState(() {
      globalDailyGoal = 0;
    });

    DateTime current = DateTime.now();
    DateTime dateFrom;
    DateTime dateTo;

    dateFrom = current.subtract(Duration(
      hours: current.hour,
      minutes: current.minute,
      seconds: current.second,
    ));
    dateTo = DateTime.now();

    final results = await Fitness.read(
        timeRange: TimeRange(
            start: dateFrom,
            end: dateTo), //dateTo.subtract(const Duration(days: 1))
        bucketByTime: 1,
        timeUnit: TimeUnit.days);

    final energyburned = await Healthhub.getHealthDataFromType(
        dateFrom, dateTo, HealthDataType.ACTIVE_ENERGY_BURNED);
    _datapoint = results;
    print("date from $dateFrom date to $dateTo");

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

    await FirebaseFirestore.instance
        .collection('fitness_tracker')
        .where('user', isEqualTo: loggedinuser.email)
        .get()
        .then((QuerySnapshot _querySnapshot) async {
      if (_querySnapshot.docs.isNotEmpty) {
        firebaseGoalHome = _querySnapshot.docs[0].data();
        setState(() {
          globalDailyGoal = firebaseGoalHome['dailyStepGoal'];
        });
      }
    });

    int ds;
    if (_datapoint.isEmpty) {
      ds = 0;
    } else {
      ds = _datapoint[0].value;
    }

    double d = ds * (0.5427547571);
    d = d / 1000;
    double energys = 0.0;
    if (energyburned.isEmpty) {
      energys = 0;
    } else {
      int index = energyburned.length - 1;
      print(' Index      ------------------------        $index');
      while (index >= 0) {
        energys += energyburned[index].value;
        index--;
      }
      energys = energys / 1000;
    }

    setState(() {
      steps = ds;
      distance = d.toStringAsFixed(2);
      energy = energys.toStringAsFixed(3);
    });
  }

  Widget showSnackbar() {
    if (snackbarshown == 0 && globalDailyGoal != -1) {
      if (steps > globalDailyGoal) {
        snackbarshown = 1;
        return SnackBar(
            content: Text('Congrats!! You achieved your daily step Goal'));
      } else {
        return SizedBox.shrink();
      }
    } else {
      return SizedBox.shrink();
    }
  }
}
