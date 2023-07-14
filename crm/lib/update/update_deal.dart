// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:crm/detail/deal_detail.dart';
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

class DealUpdate extends StatefulWidget {
  const DealUpdate({super.key});

  @override
  State<DealUpdate> createState() => _DealUpdateState();
}

class _DealUpdateState extends State<DealUpdate> {
  String urlHead = '';
  String key = '';

  int dealid = 0;
  dynamic _dealdata = [];
  bool _isLoading = true;

  DateTime selectedDate = DateTime.now();

  List<String> _listtype = [];

  final _dtitlecontroller = TextEditingController();
  final _opencontroller = TextEditingController();
  final _oppnamecontroller = TextEditingController();
  final _deploycontroller = TextEditingController();
  final _notecontroller = TextEditingController();

  String opendate = '';
  String deploydate = '';

  @override
  void initState() {
    super.initState();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    dealid = Provider.of<DataModel>(context, listen: false).getDealId();
    _listtype = Provider.of<DataModel>(context, listen: false).getOppName();
    opendate = DateFormat('yyyy-MM-dd').format(selectedDate);
    deploydate = DateFormat('yyyy-MM-dd').format(selectedDate);
    fetchDealDetail();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _dtitlecontroller.dispose();
    _opencontroller.dispose();
    _oppnamecontroller.dispose();
    _deploycontroller.dispose();
    _notecontroller.dispose();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> fetchDealDetail() async {
    try {
      String url = "$urlHead/deal/detail";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'dealId': dealid,
        }),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var data1 = decodedResponse["Data"];
        setState(() {
          _dealdata = data1[0];
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> dealUpdate(int opptype) async {
    try {
      final String dealtitle = _dtitlecontroller.text;
      final String dealnote = _notecontroller.text;
      String url = "$urlHead/deal/update";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "id": dealid,
          "oppTypeId": opptype,
          "title": dealtitle,
          "openning": opendate,
          "deployDate": deploydate,
          "notes": dealnote
        }),
        headers: headers,
      );
      if (response.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Cập nhật deal thành công.'))));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DealDetail()));
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: screenHeight * 0.1,
                      color: const Color(0xff343442),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.25,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Tiêu đề: ', style: secondaryB),
                                    SizedBox(width: screenWidth * 0.05),
                                    Expanded(
                                      child: Text('${_dealdata['Title']}',
                                          style: secondary),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Trạng thái:', style: secondaryB),
                                    SizedBox(width: screenWidth * 0.05),
                                    Expanded(
                                      child: Text(
                                        '${_dealdata['StatusName']}',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none,
                                            color: _dealdata['Status'] == 8
                                                ? Colors.red
                                                : _dealdata['Status'] == 7
                                                    ? Colors.grey
                                                    : _dealdata['Status'] == 6
                                                        ? Colors.green
                                                        : _dealdata['Status'] ==
                                                                5
                                                            ? Colors.blue
                                                            : Colors.amber[600],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Ngày nhập: ', style: secondaryB),
                                    SizedBox(width: screenWidth * 0.05),
                                    Expanded(
                                        child: Text(
                                            DateFormat('yyyy-MM-dd').format(
                                                DateTime.parse(
                                                    '${_dealdata['DealDate']}')),
                                            style: secondary))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Ngày hoàn thành: ',
                                        style: secondaryB),
                                    SizedBox(width: screenWidth * 0.05),
                                    Expanded(
                                        child: Text(
                                            DateFormat('yyyy-MM-dd').format(
                                                DateTime.parse(
                                                    '${_dealdata['CompleteDate']}')),
                                            style: secondary))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.4,
                        decoration: const BoxDecoration(
                          color: Color(0xff515167),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Tiêu đề:', style: secondaryB),
                                  SizedBox(width: screenWidth * 0.05),
                                  SizedBox(
                                    width: screenWidth * 0.5,
                                    child: TextField(
                                        controller: _dtitlecontroller,
                                        decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white))),
                                        style: secondary),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Thể loại:', style: secondaryB),
                                  SizedBox(width: screenWidth * 0.05),
                                  SizedBox(
                                    width: screenWidth * 0.49,
                                    height: screenHeight * 0.05,
                                    child: TextField(
                                      controller: _oppnamecontroller,
                                      decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white))),
                                      style: secondary,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => SimpleDialog(
                                            title: const Text(
                                                'Chọn thể loại tiệc'),
                                            children: _listtype
                                                .map((type) => InkWell(
                                                      onTap: () {
                                                        _oppnamecontroller
                                                            .text = type;
                                                        Provider.of<DataModel>(
                                                                context,
                                                                listen: false)
                                                            .oppId(_listtype
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
                              Row(
                                children: [
                                  Text('Ngày triển khai:', style: secondaryB),
                                  SizedBox(width: screenWidth * 0.05),
                                  SizedBox(
                                    width: screenWidth * 0.36,
                                    child: TextField(
                                        controller: _deploycontroller,
                                        decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white))),
                                        onTap: () async {
                                          DateTime? newDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: selectedDate,
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2100));
                                          newDate ??= DateTime.now();
                                          setState(() =>
                                              _deploycontroller.text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(newDate!));
                                          deploydate = DateFormat('yyyy-MM-dd')
                                              .format(newDate);
                                        },
                                        style: secondary),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Ngày mở tiệc:', style: secondaryB),
                                  SizedBox(width: screenWidth * 0.05),
                                  SizedBox(
                                    width: screenWidth * 0.4,
                                    child: TextField(
                                        controller: _opencontroller,
                                        decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white))),
                                        onTap: () async {
                                          DateTime? newDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: selectedDate,
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2100));
                                          newDate ??= DateTime.now();
                                          setState(() => _opencontroller.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(newDate!));
                                          opendate = DateFormat('yyyy-MM-dd')
                                              .format(newDate);
                                        },
                                        style: secondary),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Text('Ghi chú:', style: secondaryB),
                                    SizedBox(width: screenWidth * 0.05),
                                    SizedBox(
                                      width: screenWidth * 0.5,
                                      child: TextField(
                                          controller: _notecontroller,
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white)),
                                          ),
                                          style: secondary),
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
                          'Cập nhật deal',
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
                            color: Colors.white),
                      ),
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
                                dealUpdate(Provider.of<DataModel>(context,
                                        listen: false)
                                    .getOppId());
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
