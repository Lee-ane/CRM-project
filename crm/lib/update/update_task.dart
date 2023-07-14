// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

import 'package:crm/Models/data_model.dart';
import 'package:crm/style/style.dart';

import '../detail/task_detail.dart';

class TaskUpdate extends StatefulWidget {
  const TaskUpdate({super.key});

  @override
  State<TaskUpdate> createState() => _TaskUpdateState();
}

class _TaskUpdateState extends State<TaskUpdate> {
  String urlHead = '';
  String key = '';

  int taskId = 0;
  bool _isLoading = true;

  String role = '';

  dynamic _status = [];
  dynamic _task = [];
  dynamic _employees = [];

  int statusId = 0;
  int assign = 0;

  final List<String> _listStatusName = [];
  final List<String> _listEmployeesName = [];

  final _assignUserController = TextEditingController();
  final _statusNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    taskId = Provider.of<DataModel>(context, listen: false).getTaskId();
    fetchTaskDetail();
    fetchEmployees();
    fetchStatus();
    _loadData();
  }

  Future<void> fetchTaskDetail() async {
    try {
      String url = "$urlHead/Task/Detail";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({"taskId": taskId}),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var data1 = decodedResponse["Data"];
        setState(() {
          _task = data1[0];
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchEmployees() async {
    try {
      String url = "$urlHead/org/employees";
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
          _employees = data;
          for (int i = 0; i < _employees.length; i++) {
            _listEmployeesName.add(_employees[i]['OBJ_NAME']);
          }
          Provider.of<DataModel>(context, listen: false)
              .employName(_listEmployeesName);
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchStatus() async {
    try {
      String url = "$urlHead/status/task";
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
          _status = data;
          for (int i = 0; i < _status.length; i++) {
            _listStatusName.add(_status[i]['Name']);
          }
          Provider.of<DataModel>(context, listen: false)
              .statusName(_listStatusName);
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateTask() async {
    try {
      String url = "$urlHead/admin/task/update";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode(
            {"taskId": taskId, "assignToUser": assign, "status": statusId}),
        headers: headers,
      );
      if (response.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Cập nhật Task thành công.'))));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TaskDetail()));
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

      await Future.delayed(const Duration(seconds: 3));
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
    _assignUserController.dispose();
    _statusNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: SpinKitDualRing(color: Colors.black))
          : Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: screenHeight * 0.1,
                      color: const Color(0xff343442),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Container(
                        height: screenHeight * 0.15,
                        width: screenWidth * 0.9,
                        decoration: const BoxDecoration(
                          color: Color(0xff515167),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Text('Tiêu đề: ${_task['TaskName']}',
                                    style: secondaryB),
                              ),
                              Row(
                                children: [
                                  Text('Trạng thái:', style: secondaryB),
                                  SizedBox(width: screenWidth * 0.05),
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
                                              ? Colors.pink[300]
                                              : _task['Status'] == 2
                                                  ? Colors.blue
                                                  : _task['Status'] == 3
                                                      ? Colors.green
                                                      : Colors.red,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: Container(
                          height: screenHeight * 0.2,
                          width: screenWidth * 0.9,
                          decoration: const BoxDecoration(
                              color: Color(0xff515167),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 0, 15),
                                  child: Row(
                                    children: [
                                      Text('Phân công:', style: secondaryB),
                                      SizedBox(width: screenWidth * 0.05),
                                      SizedBox(
                                        width: screenWidth * 0.4,
                                        height: screenHeight * 0.05,
                                        child: TextField(
                                          controller: _assignUserController,
                                          decoration: const InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.white))),
                                          style: secondary,
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  SimpleDialog(
                                                title: const Text(
                                                    'Chọn nhân viên'),
                                                children: _listEmployeesName
                                                    .map((user) => InkWell(
                                                          onTap: () {
                                                            _assignUserController
                                                                .text = user;
                                                            for (int i = 0;
                                                                i <
                                                                    _employees
                                                                        .length;
                                                                i++) {
                                                              if (user ==
                                                                  _employees[i][
                                                                      'OBJ_NAME']) {
                                                                Provider.of<DataModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .employId(
                                                                        _employees[i]
                                                                            [
                                                                            'OBJ_AUTOID']);
                                                              }
                                                            }
                                                            assign = Provider.of<
                                                                        DataModel>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .getEmployId();

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: ListTile(
                                                            title: Text(user),
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 0, 15),
                                  child: Row(
                                    children: [
                                      Text('Trạng thái:', style: secondaryB),
                                      SizedBox(width: screenWidth * 0.05),
                                      SizedBox(
                                        width: screenWidth * 0.4,
                                        height: screenHeight * 0.05,
                                        child: TextField(
                                          controller: _statusNameController,
                                          decoration: const InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.white))),
                                          style: secondary,
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  SimpleDialog(
                                                title: const Text(
                                                    'Chọn trạng thái'),
                                                children: _listStatusName
                                                    .map((status) => InkWell(
                                                          onTap: () {
                                                            _statusNameController
                                                                .text = status;
                                                            for (int i = 0;
                                                                i <
                                                                    _status
                                                                        .length;
                                                                i++) {
                                                              if (status ==
                                                                  _status[i][
                                                                      'Name']) {
                                                                Provider.of<DataModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .statusId(
                                                                        _status[i]
                                                                            [
                                                                            'Id']);
                                                              }
                                                            }
                                                            statusId = Provider
                                                                    .of<DataModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                .getStatusId();

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: ListTile(
                                                            title: Text(status),
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
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
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Container(
                        width: screenWidth * 0.45,
                        height: screenHeight * 0.05,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                                style: BorderStyle.solid)),
                        child: Center(
                            child: Text(
                          'Cập nhật Task',
                          style: userInfo,
                        ))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(FontAwesomeIcons.arrowLeftLong,
                              color: Colors.white)),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              title: 'Sau khi thay đổi sẽ không hoàn lại',
                              titleColor: Colors.white,
                              confirmBtnText: 'Xác nhận',
                              confirmBtnColor: Colors.green,
                              confirmBtnTextStyle: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              cancelBtnTextStyle: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber[600])),
                              backgroundColor: const Color(0xff515167),
                              cancelBtnText: 'Hủy',
                              showCancelBtn: true,
                              onCancelBtnTap: () {
                                Navigator.of(context).pop();
                              },
                              onConfirmBtnTap: () {
                                updateTask();
                                Navigator.pop(context);
                              },
                            );
                          });
                        },
                        icon: const Icon(FontAwesomeIcons.check,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
