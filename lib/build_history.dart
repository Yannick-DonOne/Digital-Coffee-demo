import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/groups.dart';
import 'package:flutter_application_1/history_page.dart';

class BuildHistory extends StatefulWidget {
  BuildHistory({Key? key}) : super(key: key);

  @override
  _BuildHistoryState createState() => _BuildHistoryState();
}

class _BuildHistoryState extends State<BuildHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: brownColor,
      ),
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: Repo.history.length,
            itemBuilder: (context, index) {
              return HistoryPage(Repo.history[index]);
            }),
      ),
    );
  }
}
