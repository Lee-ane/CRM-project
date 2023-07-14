// ignore_for_file: avoid_print

import 'package:crm/components/buttons.dart';
import 'package:crm/components/textfields.dart';
import 'package:crm/detail/task_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:crm/Models/data_model.dart';
import 'package:crm/style/style.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _QuoteState();
}

class _QuoteState extends State<Task> {
  String urlHead = '';
  String key = '';
  String role = '';
  dynamic taskdata = [];
  DateTime selectedDate = DateTime.now();
  String startDate = '';
  String endDate = '';
  bool _isLoading = true;
  int page = 1;

  Map<String, int> status = {};
  List<String> statusData = [];
  List<String> progress = [];
  Map<String, int> progressChart = {};

  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    role = Provider.of<DataModel>(context, listen: false).getRole();
    startDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    endDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    _startDate.text = startDate;
    _endDate.text = endDate;
    fetchTasks();
    _loadData();
  }

//Lấy dữ liệu của công việc của cá nhân nhân viên
  Future<void> fetchTasks() async {
    try {
      String url = "$urlHead/task/assign/user";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'pageNumber': page,
          'startDate': startDate,
          'endDate': endDate,
        }),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var data = decodedResponse["Data"];
        setState(() {
          taskdata = [...taskdata, ...data];
          for (int i = 0; i < taskdata.length; i++) {
            statusData.add(taskdata[i]['StatusName'].toString());
            if (taskdata[i]['SuccessId'] is int) {
              progress.add('Đã duyệt');
            } else {
              progress.add('Chưa duyệt');
            }
          }
          for (String element in statusData) {
            status[element] = (status[element] ?? 0) + 1;
          }
          for (String opponent in progress) {
            progressChart[opponent] = (progressChart[opponent] ?? 0) + 1;
          }
        });
      } else {
        setState(() {
          'error:' 'Request failed with status: ${response.statusCode}.';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _startDate.dispose();
    _endDate.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<Data> statusData =
        status.entries.map((entry) => Data(entry.key, entry.value)).toList();
    List<Data> progressData = progressChart.entries
        .map((entry) => Data(entry.key, entry.value))
        .toList();
    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: _isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 300),
                    child: SpinKitDualRing(color: Colors.black),
                  ),
                )
              : Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: screenHeight * 0.2,
                          color: const Color(0xff343442),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 220),
                          child: SizedBox(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.21,
                            child: taskdata.isEmpty
                                ? Empty(screenWidth: screenWidth)
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: taskdata.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          int taskid = taskdata[index]['Id'];
                                          Provider.of<DataModel>(context,
                                                  listen: false)
                                              .taskId(taskid);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TaskDetail()));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: screenWidth * 0.7,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color(0xff515167),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: screenHeight * 0.07,
                                                    width: screenWidth * 0.6,
                                                    child: Text(
                                                      '${taskdata[index]['TaskName']}',
                                                      style: task,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  Text(
                                                      'Nhân viên đảm nhiệm: ${taskdata[index]['OBJ_NAME']}',
                                                      style: taskinf),
                                                  Text(
                                                    'Ngày Nhập: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(taskdata[index]['CreatedDate']))}',
                                                    style: taskinf,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Stack(children: [
                                                            Container(
                                                              width:
                                                                  screenWidth *
                                                                      0.55,
                                                              height:
                                                                  screenHeight *
                                                                      0.015,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100)),
                                                            ),
                                                            Container(
                                                              width: (taskdata[
                                                                              index]
                                                                          [
                                                                          'Progress'] /
                                                                      100) *
                                                                  (screenWidth *
                                                                      0.55),
                                                              height:
                                                                  screenHeight *
                                                                      0.015,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.blue,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                              ),
                                                            ),
                                                          ]),
                                                          Text(
                                                              '${taskdata[index]['Progress']}%',
                                                              style: task)
                                                        ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Center(
                        child: SizedBox(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.4,
                          child: taskdata.isEmpty
                              ? Center(
                                  child:
                                      Text('No data to display.', style: empty))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 2,
                                  itemBuilder: ((context, index) {
                                    return index == 0
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 30),
                                            child: Container(
                                              width: screenWidth * 0.9,
                                              height: screenHeight * 0.4,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 0.5,
                                                      style: BorderStyle.solid),
                                                  color: Colors.white),
                                              child: SfCircularChart(
                                                tooltipBehavior:
                                                    TooltipBehavior(
                                                        enable: true),
                                                title: ChartTitle(
                                                    text: 'Task status'),
                                                legend: Legend(isVisible: true),
                                                series: <CircularSeries>[
                                                  PieSeries<Data, String>(
                                                      dataSource: statusData,
                                                      xValueMapper:
                                                          (Data data, _) =>
                                                              data.status,
                                                      yValueMapper:
                                                          (Data data, _) =>
                                                              data.value,
                                                      dataLabelSettings:
                                                          const DataLabelSettings(
                                                              isVisible: true)),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: screenWidth * 0.9,
                                            height: screenHeight * 0.4,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.5,
                                                    style: BorderStyle.solid)),
                                            child: SfCircularChart(
                                              tooltipBehavior:
                                                  TooltipBehavior(enable: true),
                                              title: ChartTitle(
                                                  text: 'Confirm status'),
                                              legend: Legend(isVisible: true),
                                              series: <CircularSeries>[
                                                PieSeries<Data, String>(
                                                  dataSource: progressData,
                                                  xValueMapper:
                                                      (Data data, _) =>
                                                          data.status,
                                                  yValueMapper:
                                                      (Data data, _) =>
                                                          data.value,
                                                  dataLabelSettings:
                                                      const DataLabelSettings(
                                                          isVisible: true),
                                                ),
                                              ],
                                            ),
                                          );
                                  })),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CalendarBT(
                            screenHeight: screenHeight,
                            startDate: DateTF(
                                controller: _startDate,
                                text: 'Ngày bắt đầu',
                                function: () async {
                                  DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100));
                                  newDate ??= selectedDate;
                                  setState(() {
                                    _startDate.text = DateFormat('yyyy-MM-dd')
                                        .format(newDate!);
                                    startDate = DateFormat('yyyy-MM-dd')
                                        .format(newDate);
                                  });
                                }),
                            endDate: DateTF(
                                controller: _endDate,
                                text: 'Ngày kết thúc',
                                function: () async {
                                  DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100));
                                  newDate ??= DateTime.now();
                                  setState(() {
                                    _endDate.text = DateFormat('yyyy-MM-dd')
                                        .format(newDate!);
                                    endDate = DateFormat('yyyy-MM-dd')
                                        .format(newDate);
                                  });
                                }),
                            function: () {
                              setState(() {
                                fetchTasks();
                                _loadData();
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          Column(
                            children: [
                              Text(
                                '${DateFormat('dd/MM/yyyy').format(DateTime.parse(startDate))} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(endDate))}',
                                style: dashboard,
                              ),
                              Text('Hiện có ${taskdata.length} công việc',
                                  style: dashboard)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
