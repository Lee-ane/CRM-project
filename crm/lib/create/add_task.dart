// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:crm/detail/quote_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:crm/Models/data_model.dart';
import 'package:crm/style/style.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String urlHead = '';
  String key = '';

  int quoteId = 0;
  bool _isLoading = true;
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String endDate = '';

  String role = '';

  dynamic _employees = [];
  dynamic _taskName = [];

  int taskType = 0;
  int assign = 0;
  int priority = 0;

  List<String> _listTypeName = [];
  final List<String> _listTaskName = [];
  List<String> _listPriors = [];
  final List<String> _listEmployeesName = [];

  final _taskController = TextEditingController();
  final _endDateController = TextEditingController();
  final _taskNoteController = TextEditingController();
  final _priorNameController = TextEditingController();
  final _assignUserController = TextEditingController();
  final _typeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    quoteId = Provider.of<DataModel>(context, listen: false).getQuoteId();
    role = Provider.of<DataModel>(context, listen: false).getRole();
    _listTypeName =
        Provider.of<DataModel>(context, listen: false).getTaskType();
    _listPriors = Provider.of<DataModel>(context, listen: false).getPriority();
    fetchEmployees();
    fetchTaskName();
    _loadData();
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
    _taskController.dispose();
    _endDateController.dispose();
    _taskNoteController.dispose();
    _priorNameController.dispose();
    _assignUserController.dispose();
    _typeNameController.dispose();
  }

// Lấy dữ liệu loại công việc
  Future<void> fetchTaskName() async {
    try {
      String url = "$urlHead/Task/List";
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
          _taskName = data;
          for (int k = 0; k < _taskName.length; k++) {
            _listTaskName.add(_taskName[k]['TaskName'].toString());
          }
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

// Lấy dữ liệu nhân viên
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

// Tạo công việc
  Future<void> createTask() async {
    try {
      String taskName = _taskController.text;
      String taskNote = _taskNoteController.text;
      String url = "$urlHead/admin/task/create";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode([
          {
            "quotesId": quoteId,
            "taskName": taskName,
            "startDate": selectedDate,
            "endDate": endDate,
            "assignToUser": assign,
            "notes": taskNote,
            "taskType": taskType,
            "priority": priority
          }
        ]),
        headers: headers,
      );
      if (response.statusCode == 200) {
        try {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Center(child: Text('Tạo Task thành công.'))));
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const QuoteDetail()));
          });
        } catch (e) {
          print(e);
        }
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formWidth = MediaQuery.of(context).size.width;
    final formHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: SpinKitDualRing(color: Colors.black))
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: formHeight * 0.1,
                        color: const Color(0xff343442),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Container(
                          width: formWidth * 0.9,
                          height: formHeight * 0.8,
                          decoration: BoxDecoration(
                              color: const Color(0xff515167),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text('Tiêu đề', style: secondaryB),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: TextField(
                                    controller: _taskController,
                                    decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white))),
                                    style: secondary,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            SingleChildScrollView(
                                          child: SimpleDialog(
                                            title: const Text('Chọn Task'),
                                            children: _listTaskName
                                                .map(
                                                  (task) => InkWell(
                                                    onTap: () {
                                                      _taskController.text =
                                                          task;

                                                      Navigator.pop(context);
                                                    },
                                                    child: ListTile(
                                                      title: Text(task),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                  child:
                                      Text('Ngày kết thúc', style: secondaryB),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: TextField(
                                      controller: _endDateController,
                                      decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white))),
                                      onTap: () async {
                                        DateTime? newDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.parse(
                                                    selectedDate),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100));
                                        newDate ??= DateTime.now();
                                        setState(() => _endDateController.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(newDate!));
                                        endDate = DateFormat('yyyy-MM-dd')
                                            .format(newDate);
                                      },
                                      style: secondary),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                  child: Text('Ghi chú', style: secondaryB),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: TextField(
                                      controller: _taskNoteController,
                                      decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white))),
                                      style: secondary),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 0, 15),
                                  child: Row(
                                    children: [
                                      Text('Mật độ:', style: secondaryB),
                                      SizedBox(width: formWidth * 0.1),
                                      SizedBox(
                                        width: formWidth * 0.51,
                                        height: formHeight * 0.05,
                                        child: TextField(
                                          decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              fillColor:
                                                  const Color(0xff343442),
                                              filled: true,
                                              labelText: 'Mật độ',
                                              labelStyle: secondaryB),
                                          controller: _priorNameController,
                                          style: secondary,
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  SimpleDialog(
                                                title:
                                                    const Text('Chọn priority'),
                                                children: _listPriors
                                                    .map(
                                                      (prior) => InkWell(
                                                        onTap: () {
                                                          _priorNameController
                                                              .text = prior;
                                                          Provider.of<DataModel>(
                                                                  context,
                                                                  listen: false)
                                                              .priorityId(_listPriors
                                                                      .indexOf(
                                                                          prior) +
                                                                  1);
                                                          Navigator.pop(
                                                              context);
                                                          priority = Provider
                                                                  .of<DataModel>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .getPriorityId();
                                                        },
                                                        child: ListTile(
                                                          title: Text(prior),
                                                        ),
                                                      ),
                                                    )
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
                                      Text('Phân công:', style: secondaryB),
                                      SizedBox(width: formWidth * 0.05),
                                      SizedBox(
                                        width: formWidth * 0.50,
                                        height: formHeight * 0.05,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Phân công',
                                            labelStyle: secondaryB,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            fillColor: const Color(0xff343442),
                                            filled: true,
                                          ),
                                          controller: _assignUserController,
                                          style: secondary,
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  SimpleDialog(
                                                title: const Text(
                                                    'Chọn nhân viên'),
                                                children: _listEmployeesName
                                                    .map(
                                                      (user) => InkWell(
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
                                                                      _employees[
                                                                              i]
                                                                          [
                                                                          'OBJ_AUTOID']);
                                                            }
                                                          }
                                                          assign = Provider.of<
                                                                      DataModel>(
                                                                  context,
                                                                  listen: false)
                                                              .getEmployId();

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: ListTile(
                                                          title: Text(user),
                                                        ),
                                                      ),
                                                    )
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
                                      Text('Thể loại:', style: secondaryB),
                                      SizedBox(width: formWidth * 0.05),
                                      SizedBox(
                                        width: formWidth * 0.55,
                                        height: formHeight * 0.05,
                                        child: TextField(
                                          decoration: InputDecoration(
                                              labelText: 'Thể loại',
                                              labelStyle: secondaryB,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              fillColor:
                                                  const Color(0xff343442),
                                              filled: true),
                                          controller: _typeNameController,
                                          style: secondary,
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  SingleChildScrollView(
                                                child: SimpleDialog(
                                                  title: const Text(
                                                      'Chọn thể loại'),
                                                  children: _listTypeName
                                                      .map(
                                                        (type) => InkWell(
                                                          onTap: () {
                                                            _typeNameController
                                                                .text = type;
                                                            Provider.of<DataModel>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .taskId(_listTypeName
                                                                        .indexOf(
                                                                            type) +
                                                                    2);
                                                            Navigator.pop(
                                                                context);
                                                            taskType = Provider
                                                                    .of<DataModel>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                .getTaskId();
                                                          },
                                                          child: ListTile(
                                                            title: Text(type),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
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
                    ],
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Container(
                          width: formWidth * 0.45,
                          height: formHeight * 0.05,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                  style: BorderStyle.solid)),
                          child: Center(
                              child: Text(
                            'Thêm Task',
                            style: userInfo,
                          ))),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(FontAwesomeIcons.arrowLeftLong,
                              color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                title: 'Chắc chắn muốn tạo task chứ?',
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
                                  createTask();
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
            ),
    );
  }
}




// Container(
                    //   color: Colors.transparent,
                    //   height: formHeight * 0.85,
                    //   width: formWidth * 0.9,
                    //   child: ScrollConfiguration(
                    //     behavior: ScrollConfiguration.of(context)
                    //         .copyWith(scrollbars: false),
                    //     child: NotificationListener<ScrollUpdateNotification>(
                    //       onNotification: (notification) => true,
                    //       child: GridView.builder(
                    //         controller: _scrollController,
                    //         gridDelegate:
                    //             SliverGridDelegateWithFixedCrossAxisCount(
                    //                 crossAxisCount: 1,
                    //                 crossAxisSpacing: 20.0,
                    //                 mainAxisSpacing: formHeight * 0.05,
                    //                 mainAxisExtent: formHeight * 0.6),
                    //         itemCount: _taskName.length,
                    //         itemBuilder: (context, index) {
                    //           final cardHeight =
                    //               MediaQuery.of(context).size.height;
                    //           return Column(
                    //             children: <Widget>[
                    //               Container(
                    //                 decoration: const BoxDecoration(
                    //                     color: Color(0xff515167),
                    //                     borderRadius: BorderRadius.only(
                    //                         topLeft: Radius.circular(10),
                    //                         topRight: Radius.circular(10))),
                    //                 child: CheckboxListTile(
                    //                   title: Container(
                    //                     decoration: const BoxDecoration(
                    //                         color: Color(0xff343442)),
                    //                     child: Text(
                    //                       _taskName[index]['TaskName'],
                    //                       overflow: TextOverflow.ellipsis,
                    //                       style: primary,
                    //                     ),
                    //                   ),
                    //                   value: isChecked[index],
                    //                   onChanged: (bool? value) {
                    //                     setState(() {
                    //                       isChecked[index] = value!;
                    //                     });
                    //                   },
                    //                 ),
                    //               ),
                    //               Container(
                    //                 decoration: const BoxDecoration(
                    //                     color: Color(0xff515167),
                    //                     borderRadius: BorderRadius.only(
                    //                         bottomLeft: Radius.circular(10),
                    //                         bottomRight: Radius.circular(10))),
                    //                 child: AnimatedContainer(
                    //                   duration:
                    //                       const Duration(milliseconds: 300),
                    //                   curve: Curves.easeInOut,
                    //                   height: isChecked[index]
                    //                       ? formHeight * 0.5
                    //                       : 0,
                    //                   child: Padding(
                    //                     padding: const EdgeInsets.all(16),
                    //                     child: Column(
                    //                       children: <Widget>[
                    //                         Column(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment.start,
                    //                           crossAxisAlignment:
                    //                               CrossAxisAlignment.start,
                    //                           children: [
                    //                             TextButton(
                    //                               onPressed: () async {
                    //                                 DateTime? newDate =
                    //                                     await showDatePicker(
                    //                                         context: context,
                    //                                         initialDate:
                    //                                             selectedDate,
                    //                                         firstDate:
                    //                                             DateTime(2000),
                    //                                         lastDate:
                    //                                             DateTime(2100));
                    //                                 newDate ??= DateTime.now();
                    //                                 setState(
                    //                                   () => _endDateController
                    //                                       .text = DateFormat(
                    //                                           'yyyy-MM-dd')
                    //                                       .format(newDate!),
                    //                                 );
                    //                               },
                    //                               child: Text(
                    //                                   'Ngày kết thúc: ${_endDateController.text}',
                    //                                   style: primary),
                    //                             ),
                    //                             SizedBox(
                    //                                 height: cardHeight * 0.025),
                    //                             TextField(
                    //                               decoration: InputDecoration(
                    //                                   border: const OutlineInputBorder(
                    //                                       borderRadius:
                    //                                           BorderRadius.all(
                    //                                               Radius.circular(
                    //                                                   10))),
                    //                                   fillColor: const Color(
                    //                                       0xff343442),
                    //                                   filled: true,
                    //                                   labelText: 'Ghi chú',
                    //                                   labelStyle: secondaryB),
                    //                               style: secondary,
                    //                             ),
                    //                             SizedBox(
                    //                                 height: cardHeight * 0.025),
                                                // TextField(
                                                //   decoration: InputDecoration(
                                                //       border: const OutlineInputBorder(
                                                //           borderRadius:
                                                //               BorderRadius.all(
                                                //                   Radius.circular(
                                                //                       10))),
                                                //       fillColor: const Color(
                                                //           0xff343442),
                                                //       filled: true,
                                                //       labelText: 'Mật độ',
                                                //       labelStyle: secondaryB),
                                                //   controller:
                                                //       _priorNameController,
                                                //   style: secondary,
                                                //   onTap: () {
                                                //     showDialog(
                                                //       context: context,
                                                //       builder: (context) =>
                                                //           SimpleDialog(
                                                //         title: const Text(
                                                //             'Chọn priority'),
                                                //         children: _listPriors
                                                //             .map(
                                                //               (prior) =>
                                                //                   InkWell(
                                                //                 onTap: () {
                                                //                   _priorNameController
                                                //                           .text =
                                                //                       prior;
                                                //                   Provider.of<DataModel>(
                                                //                           context,
                                                //                           listen:
                                                //                               false)
                                                //                       .priorityId(
                                                //                           _listPriors.indexOf(prior) +
                                                //                               1);
                                                //                   Navigator.pop(
                                                //                       context);
                                                //                   priority = Provider.of<
                                                //                               DataModel>(
                                                //                           context,
                                                //                           listen:
                                                //                               false)
                                                //                       .getPriorityId();
                                                //                 },
                                                //                 child: ListTile(
                                                //                   title: Text(
                                                //                       prior),
                                                //                 ),
                                                //               ),
                                                //             )
                                                //             .toList(),
                                                //       ),
                                                //     );
                                                //   },
                                                // ),
                    //                             SizedBox(
                    //                                 height: cardHeight * 0.025),
                                                // TextField(
                                                //   decoration: InputDecoration(
                                                //     labelText: 'Phân công',
                                                //     labelStyle: secondaryB,
                                                //     border: OutlineInputBorder(
                                                //       borderRadius:
                                                //           BorderRadius.circular(
                                                //               10),
                                                //     ),
                                                //     fillColor:
                                                //         const Color(0xff343442),
                                                //     filled: true,
                                                //   ),
                                                //   controller:
                                                //       _assignUserController,
                                                //   style: secondary,
                                                //   onTap: () {
                                                //     showDialog(
                                                //       context: context,
                                                //       builder: (context) =>
                                                //           SimpleDialog(
                                                //         title: const Text(
                                                //             'Chọn nhân viên'),
                                                //         children:
                                                //             _listEmployeesName
                                                //                 .map(
                                                //                   (user) =>
                                                //                       InkWell(
                                                //                     onTap: () {
                                                //                       _assignUserController
                                                //                               .text =
                                                //                           user;
                                                //                       for (int i =
                                                //                               0;
                                                //                           i < _employees.length;
                                                //                           i++) {
                                                //                         if (user ==
                                                //                             _employees[i]['OBJ_NAME']) {
                                                //                           Provider.of<DataModel>(context, listen: false).employId(_employees[i]
                                                //                               [
                                                //                               'OBJ_AUTOID']);
                                                //                         }
                                                //                       }
                                                //                       assign = Provider.of<DataModel>(
                                                //                               context,
                                                //                               listen: false)
                                                //                           .getEmployId();

                                                //                       Navigator.pop(
                                                //                           context);
                                                //                     },
                                                //                     child:
                                                //                         ListTile(
                                                //                       title: Text(
                                                //                           user),
                                                //                     ),
                                                //                   ),
                                                //                 )
                                                //                 .toList(),
                                                //       ),
                                                //     );
                                                //   },
                                                // ),
                    //                             SizedBox(
                    //                                 height: cardHeight * 0.025),
                                                // TextField(
                                                //   decoration: InputDecoration(
                                                //       labelText: 'Thể loại',
                                                //       labelStyle: secondaryB,
                                                //       border:
                                                //           OutlineInputBorder(
                                                //               borderRadius:
                                                //                   BorderRadius
                                                //                       .circular(
                                                //                           10)),
                                                //       fillColor: const Color(
                                                //           0xff343442),
                                                //       filled: true),
                                                //   controller:
                                                //       _typeNameController,
                                                //   style: secondary,
                                                //   onTap: () {
                                                //     showDialog(
                                                //       context: context,
                                                //       builder: (context) =>
                                                //           SingleChildScrollView(
                                                //         child: SimpleDialog(
                                                //           title: const Text(
                                                //               'Chọn thể loại'),
                                                //           children:
                                                //               _listTypeName
                                                //                   .map(
                                                //                     (type) =>
                                                //                         InkWell(
                                                //                       onTap:
                                                //                           () {
                                                //                         _typeNameController.text =
                                                //                             type;
                                                //                         Provider.of<DataModel>(context,
                                                //                                 listen: false)
                                                //                             .taskId(_listTypeName.indexOf(type) + 2);
                                                //                         Navigator.pop(
                                                //                             context);
                                                //                         taskType =
                                                //                             Provider.of<DataModel>(context, listen: false).getTaskId();
                                                //                       },
                                                //                       child:
                                                //                           ListTile(
                                                //                         title: Text(
                                                //                             type),
                                                //                       ),
                                                //                     ),
                                                //                   )
                                                //                   .toList(),
                                                //         ),
                                                //       ),
                                                //     );
                                                //   },
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // )