import 'package:bloodDonor/models/time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:intl/intl.dart';

class TimeScreen extends StatefulWidget {
  final String uid;
  final String location;
  TimeScreen({@required this.uid, @required this.location});
  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  //for Times and Bookings
  int total8 = 0;
  int total9 = 0;
  int total10 = 0;
  int total11 = 0;
  int total12 = 0;
  int total1 = 0;
  int total2 = 0;
  int total3 = 0;
  bool btnEnbDisb = true;

  var times;
  List<int> _time = [];
  bool allBooked = false;
  bool isSlotPack = false;

  TimeOfDay time;
  DateTime dateTime = DateTime.now();
  DateTime _finalDateTime;
  @override
  void initState() {
    super.initState();
    print(dateTime.toString());
    print("Time is: " + dateTime.hour.toString());

    times = <Time>[
      Time(
          dayTime: 'Until 01:00 PM',
          timeRange: '8:00 AM',
          imgPath: (10 - total8).toString(),
          index: 1),
      Time(
          dayTime: '',
          timeRange: '9:00 AM',
          imgPath: (10 - total9).toString(),
          index: 2),
      Time(
          dayTime: '',
          timeRange: '10:00 AM',
          imgPath: (10 - total10).toString(),
          index: 3),
      Time(
          dayTime: '',
          timeRange: '11:00 AM',
          imgPath: (10 - total11).toString(),
          index: 4),
      Time(
          dayTime: '',
          timeRange: '12:00 PM',
          imgPath: (10 - total12).toString(),
          index: 5),
      Time(
          dayTime: '',
          timeRange: '01:00 PM',
          imgPath: (10 - total1).toString(),
          index: 6),
      Time(
          dayTime: '',
          timeRange: '02:00 PM',
          imgPath: (10 - total2).toString(),
          index: 7),
      Time(
          dayTime: '',
          timeRange: '3:00 PM',
          imgPath: (10 - total3).toString(),
          index: 8),
    ];
    checkAvlTimes(DateTime.now());
    _time = [
      0,
      total8,
      total9,
      total10,
      total11,
      total12,
      total1,
      total2,
      total3
    ];
  }

  Future<void> createAppoinment(userSelectedDateTime) async {
    await FirebaseFirestore.instance.collection('appointments').add({
      'location_ID': '${widget.location}',
      'status': 'pending',
      'time': userSelectedDateTime,
      'user_ID': widget.uid,
    });

    CollectionReference counterRef = FirebaseFirestore.instance.collection("counters");
    QuerySnapshot counterSnapshot = await counterRef.limit(1).get();
    counterSnapshot.docs.forEach((DocumentSnapshot count)async {
      int pending = count.get("pending") +1;
      int appointments = count.get("appointments") +1;

      FirebaseFirestore.instance.collection("counters")
          .doc(count.id).update(
          {"pending": pending});
      FirebaseFirestore.instance.collection("counters")
          .doc(count.id).update(
          {"appointments": appointments});

    });
  }

  int _index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              tileColor: Colors.white,
              title: Text('Choose Date'),
              trailing: InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(4000),
                  );
                  if (date != null) {
                    checkAvlTimes(Timestamp.fromDate(date).toDate());
                    setState(() {
                      dateTime = date;
                    });
                  }
                },
                child: Text(dateTime == null
                    ? 'Select Date'
                    : '${dateTime.day} - ${dateTime.month} - ${dateTime.year}'),
              ),
            ),
            // ListTile(
            //   tileColor: Colors.white,
            //   title: Text('Specific Time'),
            //   trailing: InkWell(
            //     onTap: () async {
            //       final mTime = await showTimePicker(
            //         context: context,
            //         initialTime: TimeOfDay.now(),
            //       );
            //
            //       if (mTime != null) {
            //         setState(() {
            //           time = mTime;
            //         });
            //       }
            //     },
            //     child: Text(
            //         time == null ? 'Select Time' : '${time.hour}:${time.minute}'),
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(top: 0),
              color: Colors.white,
              child: Column(
                children: [
                  ...times
                      .map(
                        (e) => InkWell(
                      onTap: () {
                        _index = e.index;
                        // time=e.timeRange;
                        if (_time[e.index] == 10) {
                          isSlotPack = true;
                          showAppointMax();
                        } else {
                          isSlotPack = false;
                        }
                        _finalDateTime =
                            getSelectedTime(times, e.index, dateTime);
                        setState(() {});
                        print(_index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 12),
                          tileColor: _index == e.index
                              ? Colors.red
                              : _time[e.index] == 10
                              ? Colors.grey[500]
                              : Colors.white,
                          title: Text(
                            e.timeRange,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _index == e.index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                _time[e.index] == 10
                                    ? "Unavailable "
                                    : "Available  ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _index == e.index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: _time[e.index] == 10
                                    ? Colors.red
                                    : Colors.green,
                              )
                            ],
                          ),
                          leading: CircleAvatar(
                            child: Text(e.imgPath),
                          ),
                          trailing: Container(
                            height: 20,
                            width: 20,
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(Icons.chevron_right,
                                  color: Colors.red, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ],
              ),
            ),

            SizedBox(height: 40),
            FlatButton(
              onPressed: () async {
                if (dateTime == null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Text('Date and time should not be null'),
                              ),
                            ],
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'))
                          ],
                        );
                      });
                  return;
                }
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    barrierColor: Colors.black26,
                    builder: (context) {
                      return AlertDialog(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          ));
                    });

                final appoinments = await FirebaseFirestore.instance
                    .collection('appointments')
                    .where('user_ID',
                    isEqualTo: FirebaseAuth.instance.currentUser.uid)
                    .get();

                if (appoinments.docs.isEmpty) {
                  if (allBooked) {
                    showDayIsPacked();
                  } else {
                    if (isSlotPack) {
                      showAppointMax();
                    } else {
                      await createAppoinment(_finalDateTime);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Home(uid: widget.uid)));
                    }
                  }
                } else {
                  if (appoinments.docs
                      .any((element) => element['status'] == 'pending')) {
                    Navigator.pop(context);
                    setState(() {
                      btnEnbDisb = false;
                    });
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Text(
                                      'There is already pending appoinment'),
                                ),
                              ],
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'))
                            ],
                          );
                        });
                  } else {
                    final shouldCreate = appoinments.docs.any((element) {
                      final pastDate = (element['time'] as Timestamp)
                          .toDate()
                          .subtract(Duration(days: 30));

                      return DateTime.now().isAfter(pastDate);
                    });

                    if (shouldCreate) {
                      if (allBooked) {
                        showDayIsPacked();
                      } else {
                        if (isSlotPack) {
                          showAppointMax();
                        } else {
                          await createAppoinment(_finalDateTime);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Home(uid: widget.uid)));
                        }
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Text(
                                        'Appointment is already recorded in past 30 days'),
                                  ),
                                ],
                              ),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  Home(uid: widget.uid)));
                                    },
                                    child: Text('OK'))
                              ],
                            );
                          });
                    }
                  }
                }
              },
              color: Colors.green,
              child: Text(
                btnEnbDisb == true
                    ? 'Set Appointment'
                    : 'Already Pending Appointment',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(height: 20),
            FlatButton(
              color: Colors.redAccent,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  DateTime getSelectedTime(
      List<Time> allTimes, int selectedIndex, DateTime selectedDate) {
    selectedDate == null
        ? selectedDate = DateTime.now()
        : selectedDate = selectedDate;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateFormat timeformatter = DateFormat('hh:mm:ss');
    DateTime selectedTime =
    DateFormat.jm().parse((allTimes[selectedIndex - 1].timeRange));
    String finalTime = timeformatter.format(selectedTime);
    String dateCut = formatter.format(selectedDate);
    String toBeParsed = '$dateCut $finalTime' + '.000';
    DateTime finalDateTime = DateTime.tryParse(toBeParsed);
    return finalDateTime;
  }

  Future<void> checkAvlTimes([DateTime date]) async {
    total8 = 0;
    total9 = 0;
    total10 = 0;
    total11 = 0;
    total12 = 0;
    total1 = 0;
    total2 = 0;
    total3 = 0;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String dateCut = date == null ? "" : formatter.format(date);
    dateCut == ""
        ? formatter.format(DateTime.now())
        : dateCut = formatter.format(date);

    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (context) => Center(child: Container(margin: EdgeInsets.all(4), height: 20, width: 20, child: CircularProgressIndicator())));
    final appoinments =
    await FirebaseFirestore.instance.collection('appointments').get();
    // Navigator.pop(context);
    final _allAppointments = appoinments.docs;
    for (var appointment in _allAppointments) {
      Timestamp _timeStamp = appointment['time'];
      DateTime _dateHour = _timeStamp.toDate();
      String _date = formatter.format(_timeStamp.toDate());
      //date = _allAppointments.first['time'].toDate();
      String status = appointment['status'];
      String locationId = appointment['location_ID'];
      if (_date == dateCut) {
        if (status != "done" && status != "expired") {
          if (locationId == "saif hospital") {
            times.removeAt(6);
            times.removeAt(7);
            switch (_dateHour.hour) {
              case 8:
                total8++;
                break;
              case 9:
                total9++;
                break;
              case 10:
                total10++;
                break;
              case 11:
                total11++;
                break;
              case 12:
                total12++;
                break;
              case 13:
                total1++;
                break;
            // case 14:
            //   total2++;
            //   break;
            // case 15:
            //   total3++;
            //   break;
              default:
                print("no");
            }
          } else if (locationId == "Amiri hospital") {
            switch (_dateHour.hour) {
            // case 8:
            //   total8++;
            //   break;
              case 9:
                total9++;
                break;
              case 10:
                total10++;
                break;
              case 11:
                total11++;
                break;
              case 12:
                total12++;
                break;
              case 13:
                total1++;
                break;
              case 14:
                total2++;
                break;
            // case 15:
            //   total3++;
            //   break;
              default:
                print("no");
            }
          } else if (locationId == "kuwait hospital") {
            switch (_dateHour.hour) {
            // case 8:
            //   total8++;
            //   break;
            // case 9:
            //   total9++;
            //   break;
              case 10:
                total10++;
                break;
              case 11:
                total11++;
                break;
              case 12:
                total12++;
                break;
              case 13:
                total1++;
                break;
              case 14:
                total2++;
                break;
              case 15:
                total3++;
                break;
              default:
                print("no");
            }
          } else if (locationId == "Adan hospital") {
            switch (_dateHour.hour) {
              case 8:
                total8++;
                break;
              case 9:
                total9++;
                break;
              case 10:
                total10++;
                break;
              case 11:
                total11++;
                break;
              case 12:
                total12++;
                break;
              case 13:
                total1++;
                break;
              case 14:
                total2++;
                break;
              case 15:
                total3++;
                break;
              default:
                print("no");
            }
          }
        }
      } else {
        print("No Appointments Today!");
      }
      if (total8 +
          total9 +
          total10 +
          total11 +
          total12 +
          total1 +
          total2 +
          total3 ==
          80) {
        allBooked = true;
      }
      print(
          "$total8 + $total9 + $total10 + $total11 + $total12 + $total1 + $total2 + $total3");
    }
    _time = [
      0,
      total8,
      total9,
      total10,
      total11,
      total12,
      total1,
      total2,
      total3
    ];
    WidgetsFlutterBinding.ensureInitialized();
    if (mounted) setState(() {});
  }

  showAppointMax() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                      'Please choose another time slot. This one is filled already'),
                ),
              ],
            ),
          );
        });
  }

  showDayIsPacked() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                      'Please choose another Date. This one is booked already'),
                ),
              ],
            ),
          );
        });
  }
}