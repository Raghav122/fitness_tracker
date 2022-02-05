import 'package:fitness/fitness.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class weekly_data extends StatefulWidget {
  static const String id = 'weeklydata';
  @override
  _weekly_dataState createState() => _weekly_dataState();
}

class _weekly_dataState extends State<weekly_data> {
  //_weekly_dataState({@required this.Date, @required this.stepstoday});

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
        toolbarHeight: 60.0,
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  '$date6-$datetoday $months',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.ac_unit_outlined,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    '$totalSteps steps',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Divider(
                thickness: 2.0,
                indent: 20.0,
                endIndent: 20.0,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 45),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$date6 $month6',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 35.0,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$step6 steps',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$date5 $month5',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 35.0,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$step5 steps',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$date4 $month4',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 35.0,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$step4 steps',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$date3 $month3',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 35.0,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$step3 steps',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$date2 $month2',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 35.0,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$step2 steps',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$date1 $month1',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 35.0,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$step1 steps',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  '$datetoday $months',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 35.0,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                child: Text(
                  '$stepstoday steps',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
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

    _todaysteps = results;
    _dataPoint = result;

    setState(() {
      stepstoday = _todaysteps[0].value;
      step1 = _dataPoint[0].value;
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
