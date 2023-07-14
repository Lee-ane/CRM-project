// ignore_for_file: file_names, avoid_print
import 'dart:convert';

import 'package:crm/pages/deal.dart';
import 'package:crm/pages/quote.dart';
import 'package:crm/pages/schedule.dart';
import 'package:crm/pages/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'Models/data_model.dart';
import 'package:http/http.dart' as http;
import 'style/style.dart';
import 'package:flutter/material.dart';

class DashBoardAd extends StatefulWidget {
  const DashBoardAd({super.key});

  @override
  State<DashBoardAd> createState() => _DashBoardState();
}

List<Widget> _widgetOptions = <Widget>[
  const EventCalendar(),
  const Deal(),
  const Quote(),
];

class _DashBoardState extends State<DashBoardAd> {
  int _selectedIndex = 0;
  String key = '';
  String urlHead = '';
  String username = '';
  String role = '';
  dynamic _task = [];
  dynamic _oppo = [];
  dynamic _priority = [];

  List<String> priority = [];
  List<String> oppoType = [];
  List<String> tasktype = [];

  @override
  void initState() {
    super.initState();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    username = Provider.of<DataModel>(context, listen: false).getUser();
    role = Provider.of<DataModel>(context, listen: false).getRole();
    fetchTaskType();
    fetchOppoType();
    fetchPriority();
  }

//Lấy dữ liệu thể loại
  Future<void> fetchTaskType() async {
    try {
      String url = "$urlHead/Task/TaskType";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var data = decodedResponse["Data"];
        setState(() {
          _task = data;
          for (int i = 0; i < _task.length; i++) {
            tasktype.add(_task[i]['TypeName'].toString());
          }
          Provider.of<DataModel>(context, listen: false).taskType(tasktype);
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

//Lấy dữ liệu Opp
  Future<void> fetchOppoType() async {
    try {
      String url = "$urlHead/oppotype";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var data = decodedResponse["Data"];
        setState(() {
          _oppo = data;
          for (int j = 0; j < _oppo.length; j++) {
            oppoType.add(_oppo[j]['Name'].toString());
          }
          Provider.of<DataModel>(context, listen: false).oppName(oppoType);
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

//Lấy dữ liệu về mật độ
  Future<void> fetchPriority() async {
    try {
      String url = "$urlHead/priority";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var data = decodedResponse["Data"];
        setState(() {
          _priority = data;
          for (int k = 0; k < _priority.length; k++) {
            priority.add(_priority[k]['Name'].toString());
          }
          Provider.of<DataModel>(context, listen: false).priorityName(priority);
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              color: const Color(0xff343442),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text('Dashboard', style: dashboard),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                            _selectedIndex == 0
                                ? 'Schedule'
                                : _selectedIndex == 1
                                    ? 'Deals'
                                    : 'Quotes',
                            style: title),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const User()));
                    },
                    child: Container(
                      width: screenWidth * 0.1,
                      height: screenHeight * 0.05,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      child: Center(child: Text(username, style: piechart)),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.8,
                  child: _widgetOptions.elementAt(_selectedIndex)),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.calendarCheck), label: 'Schedule'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.fileLines), label: 'Deals'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.fileCircleCheck), label: 'Quotes'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff343442),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
