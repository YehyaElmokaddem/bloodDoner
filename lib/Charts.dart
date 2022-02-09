import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Charts extends StatefulWidget {
  // final Widget child;
  final String uid;
  final String location;
  final List counter;
  Charts({@required this.uid, @required this.location,@required this.counter});
  //Charts({Key key, this.child}) : super(key: key);

  ChartsState createState() => ChartsState();
}

class ChartsState extends State<Charts> {
  //List<charts.Series<Pollution, String>> _seriesData;
  List<charts.Series<Task, String>> _seriesData;
  List<charts.Series<Donation, int>> _seriesLineData;
  var linesalesdata = List<Donation>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesData = List<charts.Series<Task, String>>();
    _seriesLineData = List<charts.Series<Donation, int>>();
  }
  @override
  Widget build(BuildContext context) {
    //createChart();
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Blood")
          .where("location_ID", isEqualTo: widget.location)
          .snapshots(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData)
          return CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            backgroundColor: Colors.grey,
          );
        var bardata = [
          new Task('O+', snapshot.data.docs.first.data()['O+'].toDouble(), Color(0xff3366cc)),
          new Task('O-', snapshot.data.docs.first.data()['O-'].toDouble(), Color(0xff3366cc)),
          new Task('A+', snapshot.data.docs.first.data()['A+'].toDouble(), Color(0xff3366cc)),
          new Task('A-', snapshot.data.docs.first.data()['A-'].toDouble(), Color(0xff3366cc)),
          new Task('B+', snapshot.data.docs.first.data()['B+'].toDouble(), Color(0xff3366cc)),
          new Task('B-', snapshot.data.docs.first.data()['B-'].toDouble(), Color(0xff3366cc)),
          new Task('AB+', snapshot.data.docs.first.data()['AB+'].toDouble(), Color(0xff3366cc)),
          new Task('AB-', snapshot.data.docs.first.data()['AB-'].toDouble(), Color(0xff3366cc)),
        ];
        _seriesData.add(
          charts.Series(
            domainFn: (Task task, _) => task.task,
            measureFn: (Task task, _) => task.taskvalue,

            colorFn: (Task task, _) =>
                charts.ColorUtil.fromDartColor(task.colorval),
            id: 'blood',
            data: bardata,
            labelAccessorFn: (Task row, _) => '${row.taskvalue}',
          ),
        );
        return MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                leading: GestureDetector(child: Icon(Icons.arrow_back),onTap: (){Navigator.pop(context);}),
                title: Text(widget.location),
                backgroundColor: Colors.red,
                //backgroundColor: Color(0xff308e1c),
                bottom: TabBar(
                  indicatorColor: Color(0xff9962D0),
                  tabs: [
                    Tab(icon: Icon(FontAwesomeIcons.chartBar)),
                    Tab(icon: Icon(FontAwesomeIcons.chartLine)),
                  ],
                ),
                //title: Text('BLOOD CHARTS '),
              ),
              body: TabBarView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Available Blood Types. threshold = '+snapshot.data.docs.first.data()['threshold'].toString(),style: TextStyle(fontSize: 21.0,fontWeight: FontWeight.bold),),

                            Expanded(
                              child: charts.BarChart(
                                _seriesData,
                                animate: true,
                                animationDuration: Duration(seconds: 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("appointments")
                          .where("location_ID", isEqualTo: widget.location)
                          .where("status", isEqualTo: "done")
                          .snapshots(),
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                            backgroundColor: Colors.grey,
                          );

                        /*linesalesdata.add(new Donation(0, counter[0]));
                        linesalesdata.add(new Donation(1, counter[1]));
                        linesalesdata.add(new Donation(2, counter[2]));
                        linesalesdata.add(new Donation(3, counter[3]));
                        linesalesdata.add(new Donation(4, counter[4]));
                        linesalesdata.add(new Donation(5, counter[5]));
                        linesalesdata.add(new Donation(6, counter[6]));*/

                        var linesalesdata = [
                         new Donation(0, widget.counter[0]),
                          new Donation(1, widget.counter[1]),
                          new Donation(2, widget.counter[2]),
                          new Donation(3, widget.counter[3]),
                          new Donation(4, widget.counter[4]),
                          new Donation(5, widget.counter[5]),
                          new Donation(6, widget.counter[6]),

                        ];
                        //sleep(const Duration(milliseconds:500));
                        _seriesLineData.add(
                          charts.Series(
                            colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
                            id: 'blood',
                            data: linesalesdata,
                            domainFn: ( Donation v1,  _) => v1.Value1,
                            measureFn: (Donation v2, _) => v2.Value2,
                          ),
                        );
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    ' Donations Count This week ',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                                  Expanded(
                                    child: charts.LineChart(
                                        _seriesLineData,
                                        defaultRenderer: new charts.LineRendererConfig(
                                            includeArea: true, stacked: true),
                                        animate: true,
                                        animationDuration: Duration(seconds: 1),
                                        domainAxis: new charts.NumericAxisSpec(
                                            viewport: new charts.NumericExtents(0.0, 6.0)),

                                        behaviors: [
                                          new charts.ChartTitle('Time (0 = 6 days ago , 6 = today)',
                                              behaviorPosition: charts.BehaviorPosition.bottom,
                                              titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
                                          new charts.ChartTitle('Donations Count',
                                              behaviorPosition: charts.BehaviorPosition.start,
                                              titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                                        ]
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      )
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
  Future<void> createChart() async {


    DateTime now = DateTime.now();

    CollectionReference userRef = FirebaseFirestore.instance.collection("appointments");
    QuerySnapshot userSnapshot = await userRef.where("status",isEqualTo: "done").get();
    userSnapshot.docs.forEach((DocumentSnapshot app)async {

        Timestamp timestamp = app.get("time") as Timestamp;
        DateTime dateTime = timestamp.toDate();
        Duration diff = now.difference(dateTime);
        if(now.isAfter(dateTime))
          {
            if(diff.inDays == 0)
            {
              setState(() {
                widget.counter[6]++;
              });

            }
            else if(diff.inDays == 1)
            {
              setState(() {
                widget.counter[5]++;
              });
            }
            else if(diff.inDays == 2)
            {
              setState(() {
                widget.counter[4]++;
              });
            }
            else if(diff.inDays == 3)
            {
              setState(() {
                widget.counter[3]++;
              });
            }
            else if(diff.inDays == 4)
            {
              setState(() {
                widget.counter[2]++;
              });
            }
            else if(diff.inDays == 5)
            {
              setState(() {
                widget.counter[1]++;
              });
            }
            else if(diff.inDays == 6)
            {
              setState(() {
                widget.counter[0]++;
              });
            }
          }

    });

  }
}

class Task {
  String task;
  double taskvalue;
  Color colorval;
  Task(this.task, this.taskvalue, this.colorval);
}
class Donation {
  int  Value1;
  int  Value2;
  Donation(this.Value1, this.Value2);
}