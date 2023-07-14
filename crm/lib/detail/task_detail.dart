// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:crm/dash_board_user.dart';
import 'package:crm/detail/quote_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import 'package:crm/Models/data_model.dart';
import 'package:crm/style/style.dart';

import '../update/update_task.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({super.key});

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  String urlHead = '';
  String key = '';
  String role = '';

  bool _isLoading = true;

  String adminName = '';

  int taskid = 0;
  dynamic _task = [];

  int taskstatus = 0;

  final progress = TextEditingController();

  @override
  void initState() {
    super.initState();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    role = Provider.of<DataModel>(context, listen: false).getRole();
    taskid = Provider.of<DataModel>(context, listen: false).getTaskId();
    adminName = Provider.of<DataModel>(context, listen: false).getUser();
    fetchTaskDetail();
    _loadData();
  }

// Lấy thông tin của công việc
  Future<void> fetchTaskDetail() async {
    try {
      String url = "$urlHead/Task/Detail";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({"taskId": taskid}),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);

        var data1 = decodedResponse["Data"];
        setState(() {
          _task = data1[0];
          taskstatus = _task['Status'];
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
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

// Duyệt tién trình công việc
  Future<void> confirmTask() async {
    try {
      String url = "$urlHead/admin/task/confirm";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "taskId": taskid,
        }),
        headers: headers,
      );
      if (response.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Center(child: Text('Confirm công việc đã hoàn thành.'))));
          fetchTaskDetail();
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

// Cập nhật tiến độ công việc
  Future<void> updateTaskProgress() async {
    try {
      int taskProgress = int.parse(progress.text);
      String url = "$urlHead/user/task/update";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "taskId": _task['Id'],
          "progress": taskProgress,
          "status": taskstatus
        }),
        headers: headers,
      );
      if (response.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Cập nhật tiến độ thành công.'))));
          fetchTaskDetail();
          _loadData();
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    progress.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: SpinKitDualRing(color: Colors.black))
          : SingleChildScrollView(
              child: Stack(children: [
                Container(
                  height: screenHeight * 0.2,
                  color: const Color(0xff343442),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text('Chi tiết task', style: detail),
                    )),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25, left: 10),
                    child: IconButton(
                      onPressed: () {
                        if (role == 'admin') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const QuoteDetail()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DashBoardUser()));
                        }
                      },
                      icon: const Icon(FontAwesomeIcons.arrowLeftLong,
                          color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25, right: 10),
                    child: IconButton(
                      onPressed: () {
                        Provider.of<DataModel>(context, listen: false)
                            .taskId(_task["Id"]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TaskUpdate()));
                      },
                      icon: const Icon(FontAwesomeIcons.pencil,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                                style: BorderStyle.solid)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tiêu đề: ${_task['TaskName']}',
                                      style: detailMainB,
                                      overflow: TextOverflow.ellipsis),
                                  Visibility(
                                    visible: _task['Progress'] == 100 &&
                                        _task['Status'] != 1 &&
                                        _task['SuccessId'] is int,
                                    child: SizedBox(
                                        width: screenWidth * 0.2,
                                        child: const Image(
                                            image: AssetImage(
                                                'assets/approved.png'))),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child:
                                        Text('Trạng thái:', style: detailMainB),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _task['Status'] == 1
                                          ? 'Chưa thực hiện'
                                          : _task['Status'] == 2
                                              ? 'Đang thực hiện'
                                              : _task['Status'] == 3
                                                  ? 'Đã thực hiện'
                                                  : 'Hoãn',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                          color: _task['Status'] == 1
                                              ? Colors.grey
                                              : _task['Status'] == 2
                                                  ? Colors.blue
                                                  : _task['Status'] == 3
                                                      ? Colors.green
                                                      : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Visibility(
                                      visible: _task['Progress'] == 100 &&
                                          _task['SuccessId'] is Map &&
                                          role == 'admin',
                                      child: SizedBox(
                                        width: screenWidth * 0.2,
                                        child: TextButton(
                                            child: Text('Confirm',
                                                style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .amber[600]))),
                                            onPressed: () {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.confirm,
                                                title: 'Confirm progress?',
                                                titleColor: Colors.white,
                                                confirmBtnText: 'Xác nhận',
                                                confirmBtnColor: Colors.green,
                                                confirmBtnTextStyle:
                                                    quickalertconf,
                                                cancelBtnText: 'Hủy',
                                                cancelBtnTextStyle:
                                                    quickalertcancel,
                                                backgroundColor:
                                                    const Color(0xff515167),
                                                showCancelBtn: true,
                                                onCancelBtnTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                onConfirmBtnTap: () {
                                                  setState(() {
                                                    confirmTask();
                                                    Navigator.pop(context);
                                                  });
                                                },
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(children: [
                                    Container(
                                      width: screenWidth * 0.65,
                                      height: screenHeight * 0.01,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                    Container(
                                      height: screenHeight * 0.01,
                                      width: (screenWidth * 0.65) *
                                          (_task['Progress'] / 100),
                                      decoration: BoxDecoration(
                                          color: _task['Progress'] == 100
                                              ? Colors.green
                                              : Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    ),
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Text('${_task['Progress']}%',
                                        style: detailMainB),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: screenHeight * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Ngày tạo: ', style: detailMain),
                                  Text('Ngày bắt đầu: ', style: detailMain),
                                  Text('Ngày kết thúc: ', style: detailMain),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(
                                              '${_task['CreatedDate']}')),
                                      style: detailMain),
                                  Text(
                                      DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(
                                              '${_task['StartDate']}')),
                                      style: detailMain),
                                  Text(
                                      ' ${DateFormat('dd-MM-yyyy').format(DateTime.parse('${_task['EndDate']}'))}',
                                      style: detailMain),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Ghi chú: ${_task['Notes']}',
                                  overflow: TextOverflow.clip,
                                  style: detailMain),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: role != 'admin',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.5,
                              child: TextField(
                                controller: progress,
                                decoration: InputDecoration(
                                    labelText: 'Tiến độ công việc',
                                    labelStyle: secondaryB,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    filled: true,
                                    fillColor: const Color(0xff343442)),
                                style: secondary,
                              ),
                            ),
                            Container(
                              width: screenWidth * 0.35,
                              height: screenHeight * 0.072,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.amber[400],
                                  border: Border.all(
                                      color: Colors.black,
                                      width: 0.5,
                                      style: BorderStyle.solid)),
                              child: TextButton(
                                child: const Text(
                                  'Cập nhật tiến độ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.confirm,
                                    title: 'Update progress?',
                                    titleColor: Colors.white,
                                    confirmBtnText: 'Xác nhận',
                                    confirmBtnColor: Colors.green,
                                    confirmBtnTextStyle: quickalertconf,
                                    cancelBtnTextStyle: quickalertcancel,
                                    backgroundColor: const Color(0xff515167),
                                    cancelBtnText: 'Hủy',
                                    showCancelBtn: true,
                                    onCancelBtnTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    onConfirmBtnTap: () {
                                      setState(
                                        () {
                                          if (progress.text.isNotEmpty) {
                                            if (progress.text == '100') {
                                              taskstatus = 3;
                                            } else if (progress.text != '0' &&
                                                progress.text != '100') {
                                              taskstatus = 2;
                                            }
                                            updateTaskProgress();
                                            Navigator.of(context).pop();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Center(
                                                  child: Text(
                                                      'Vui lòng nhập tiến độ'),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
    );
  }
}
