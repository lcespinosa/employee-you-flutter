
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeCounter extends StatefulWidget {

  final bool hasDate;
  final DateTime startTime;

  TimeCounter({this.hasDate = true, this.startTime});

  @override
  State<StatefulWidget> createState() => _TimeCounterState();

}

class _TimeCounterState extends State<TimeCounter> {

  Timer _timer;
  DateTime currentTime;

  @override
  void initState() {
    super.initState();
    // Get the current time
    if (widget.startTime != null) {
      currentTime = widget.startTime;
    }
    else {
      currentTime = DateTime.now();
    }
    startTimer();
  }

  void startTimer() {
    // Set 1 second callback
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      // Update interface
      setState(() {
        // minus one second because it calls back once a second
        currentTime = currentTime.add(Duration(seconds: 1));
      });
    });
  }

  String getCurrentTime() {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(currentTime);
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  top: BorderSide(width: 1.0, color: Color(0xFFDFDFDF)),
                  left: BorderSide(width: 1.0, color: Color(0xFFDFDFDF)),
                  right: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
                  bottom: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
            child: Text(
              getCurrentTime(),
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
              ),
            ),
          )
        ],
      ),
    );
  }
}