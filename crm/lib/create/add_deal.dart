// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:crm/dash_board.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import '../Models/data_model.dart';
import 'package:crm/style/style.dart';

import '../dash_board_user.dart';

class AddDeal extends StatefulWidget {
  const AddDeal({super.key});

  @override
  State<AddDeal> createState() => _AddDealState();
}

class _AddDealState extends State<AddDeal> {
  String urlHead = '';
  String key = '';
  String role = '';

  DateTime selectedDate = DateTime.now();

  List<String> _listOppType = [];
  dynamic _findCust = [];

  final List<String> _listEmployeesName = [];
  String opendate = '';
  String deploydate = '';
  dynamic _employees = [];
  int assign = 0;

  final _dtitlecontroller = TextEditingController();
  final _oppnamecontroller = TextEditingController();
  final _opencontroller = TextEditingController();
  final _deploycontroller = TextEditingController();
  final _custcontroller = TextEditingController();
  final _custphonecontroller = TextEditingController();
  final _custemailcontroller = TextEditingController();
  final _objectcontroller = TextEditingController();
  final _dealnotecontroller = TextEditingController();
  final _assignUserController = TextEditingController();

  @override
  void initState() {
    super.initState();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    _listOppType = Provider.of<DataModel>(context, listen: false).getOppName();
    assign = Provider.of<DataModel>(context, listen: false).getUserId();
    role = Provider.of<DataModel>(context, listen: false).getRole();
    opendate = DateFormat('yyyy-MM-dd').format(selectedDate);
    deploydate = DateFormat('yyyy-MM-dd').format(selectedDate);
    fetchEmployees();
  }

  @override
  void dispose() {
    super.dispose();
    _assignUserController.dispose();
    _custemailcontroller.dispose();
    _custphonecontroller.dispose();
    _dealnotecontroller.dispose();
    _deploycontroller.dispose();
    _dtitlecontroller.dispose();
    _oppnamecontroller.dispose();
    _opencontroller.dispose();
    _custcontroller.dispose();
    _objectcontroller.dispose();
  }

// Lấy thông tin nhân viên
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

// Tìm thông tin khách hàng
  Future<void> custFind(String phone) async {
    try {
      String url = "$urlHead/customer/find";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({"info": phone}),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var data = decodedResponse["Data"];
        setState(() {
          if (data.isNotEmpty) {
            _findCust = data[0];
            _objectcontroller.text = _findCust['OBJ_AUTOID'].toString();
            _custcontroller.text = _findCust['OBJ_NAME'];
            _custemailcontroller.text = _findCust['OBJ_EMAIL'];
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Center(child: Text('Chưa đăng ký khách hàng.'))));
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

// Tạo deal
  Future<void> createDeal(int opptype) async {
    try {
      final String dealtitle = _dtitlecontroller.text;
      final String name = _custcontroller.text;
      final String phone = _custphonecontroller.text;
      final String email = _custemailcontroller.text;
      final int obj = int.parse(_objectcontroller.text);
      final String note = _dealnotecontroller.text;
      String url = "$urlHead/deal/create";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "oppTypeId": opptype,
          "title": dealtitle,
          "objectID": obj,
          "custName": name,
          "phone": phone,
          "email": email,
          "openning": opendate,
          "deployDate": deploydate,
          "saleMenId": assign,
          "notes": note
        }),
        headers: headers,
      );
      if (response.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Tạo deal thành công.'))));
          role == 'admin'
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const DashBoardAd()))
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashBoardUser()));
        });
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
      body: SingleChildScrollView(
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: formHeight * 0.1,
                color: const Color(0xff343442),
              ),
              SizedBox(
                height: formHeight,
                width: formWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Text('Tiêu đề', style: detailMainB),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                                controller: _dtitlecontroller,
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black))),
                                style: detailMain),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text('Ngày triển khai', style: detailMainB),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                                controller: _deploycontroller,
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black))),
                                onTap: () async {
                                  DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100));
                                  newDate ??= DateTime.now();
                                  setState(() => _deploycontroller.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(newDate!));
                                  deploydate =
                                      DateFormat('yyyy-MM-dd').format(newDate);
                                },
                                style: detailMain),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text('Ngày bắt đầu', style: detailMainB),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                                controller: _opencontroller,
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black))),
                                onTap: () async {
                                  DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100));
                                  newDate ??= DateTime.now();
                                  setState(() => _opencontroller.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(newDate!));
                                  opendate =
                                      DateFormat('yyyy-MM-dd').format(newDate);
                                },
                                style: detailMain),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text('Ghi chú', style: detailMainB),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                                controller: _dealnotecontroller,
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black))),
                                style: detailMain),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 15),
                            child: Visibility(
                              visible: role == 'admin',
                              child: Row(
                                children: [
                                  Text('Phân công:', style: detailMainB),
                                  SizedBox(width: formWidth * 0.05),
                                  SizedBox(
                                    width: formWidth * 0.54,
                                    height: formHeight * 0.05,
                                    child: TextField(
                                      controller: _assignUserController,
                                      decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black))),
                                      style: detailMain,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => SimpleDialog(
                                            title: const Text('Chọn nhân viên'),
                                            children: _listEmployeesName
                                                .map(
                                                  (user) => InkWell(
                                                    onTap: () {
                                                      _assignUserController
                                                          .text = user;
                                                      for (int i = 0;
                                                          i < _employees.length;
                                                          i++) {
                                                        if (user ==
                                                            _employees[i]
                                                                ['OBJ_NAME']) {
                                                          Provider.of<DataModel>(
                                                                  context,
                                                                  listen: false)
                                                              .employId(_employees[
                                                                      i][
                                                                  'OBJ_AUTOID']);
                                                        }
                                                      }
                                                      assign = Provider.of<
                                                                  DataModel>(
                                                              context,
                                                              listen: false)
                                                          .getEmployId();

                                                      Navigator.pop(context);
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
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 15),
                            child: Row(
                              children: [
                                Text('Thể loại:', style: detailMainB),
                                SizedBox(width: formWidth * 0.05),
                                SizedBox(
                                  width: formWidth * 0.58,
                                  height: formHeight * 0.05,
                                  child: TextField(
                                    controller: _oppnamecontroller,
                                    decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black))),
                                    style: detailMain,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => SimpleDialog(
                                          title:
                                              const Text('Chọn thể loại tiệc'),
                                          children: _listOppType
                                              .map((type) => InkWell(
                                                    onTap: () {
                                                      _oppnamecontroller.text =
                                                          type;
                                                      Provider.of<DataModel>(
                                                              context,
                                                              listen: false)
                                                          .oppId(_listOppType
                                                                  .indexOf(
                                                                      type) +
                                                              1);
                                                      Navigator.pop(context);
                                                    },
                                                    child: ListTile(
                                                      title: Text(type),
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
                    Center(
                      child: Text('Thông tin liên lạc', style: userInfo),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration:
                            const BoxDecoration(color: Color(0xff515167)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Số điện thoại khách hàng',
                                      style: secondaryB),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 30),
                                    child: IconButton(
                                      icon: const Icon(FontAwesomeIcons.check,
                                          color: Colors.white),
                                      onPressed: () {
                                        custFind(_custphonecontroller.text);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: TextField(
                                  controller: _custphonecontroller,
                                  decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))),
                                  style: secondary),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                              child:
                                  Text('Họ tên khách hàng', style: secondaryB),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: TextField(
                                  controller: _custcontroller,
                                  decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))),
                                  style: secondary),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                              child:
                                  Text('Email khách hàng', style: secondaryB),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                              child: TextField(
                                  controller: _custemailcontroller,
                                  decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))),
                                  style: secondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
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
                    'Thêm deal',
                    style: userInfo,
                  ))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, right: 10, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(FontAwesomeIcons.arrowLeft,
                        color: Colors.white)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        title: 'Chắc chắn muốn tạo deal chứ?',
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
                          createDeal(
                              Provider.of<DataModel>(context, listen: false)
                                  .getOppId());
                        },
                      );
                    });
                  },
                  icon: const Icon(FontAwesomeIcons.check, color: Colors.white),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
