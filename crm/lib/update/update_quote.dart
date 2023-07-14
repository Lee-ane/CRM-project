// ignore_for_file: avoid_print

import 'dart:convert';

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

class QuoteUpdate extends StatefulWidget {
  const QuoteUpdate({super.key});

  @override
  State<QuoteUpdate> createState() => _QuoteUpdateState();
}

class _QuoteUpdateState extends State<QuoteUpdate> {
  String urlHead = '';
  String key = '';

  int quoteid = 0;
  dynamic _quotedata = [];
  dynamic _hall = [];

  bool _isLoading = true;

  List<String> _listhall = [];

  final _guestQtycontroller = TextEditingController();
  final _tableQtycontroller = TextEditingController();
  final _depositscontroller = TextEditingController();
  final _hallnamecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    quoteid = Provider.of<DataModel>(context, listen: false).getQuoteId();
    _listhall = Provider.of<DataModel>(context, listen: false).getHallName();
    fetchHall();
    fetchQuoteDetail();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _guestQtycontroller.dispose();
    _tableQtycontroller.dispose();
    _depositscontroller.dispose();
    _hallnamecontroller.dispose();
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

  Future<void> quoteUpdate(int hallId) async {
    try {
      final int guest = int.parse(_guestQtycontroller.text);
      final int table = int.parse(_tableQtycontroller.text);
      final int depos = int.parse(_depositscontroller.text);
      String url = "$urlHead/quotes/update";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "id": quoteid,
          "hallId": hallId,
          "guestQty": guest,
          "tableQty": table,
          "deposits": depos
        }),
        headers: headers,
      );
      if (response.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Cập nhật Quote thành công.'))));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const QuoteDetail()));
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchQuoteDetail() async {
    try {
      String url = "$urlHead/quotes/detail";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'quotesId': quoteid,
        }),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var data1 = decodedResponse["Data"];
        setState(() {
          _quotedata = data1[0];
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchHall() async {
    try {
      String url = "$urlHead/hall";
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
        var data1 = decodedResponse["Data"];
        setState(() {
          _hall = data1;
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
          : Stack(children: [
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
                                    child: Text('${_quotedata['QuotesTitle']}',
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
                                      '${_quotedata['QuotesStatusName']}',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                          color: _quotedata['QuotesStatus'] == 3
                                              ? Colors.red
                                              : _quotedata['QuotesStatus'] == 5
                                                  ? Colors.grey
                                                  : _quotedata[
                                                              'QuotesStatus'] ==
                                                          2
                                                      ? Colors.green
                                                      : _quotedata[
                                                                  'QuotesStatus'] ==
                                                              4
                                                          ? Colors.blue
                                                          : _quotedata[
                                                                      'QuotesStatus'] ==
                                                                  6
                                                              ? Colors
                                                                  .orange[600]
                                                              : _quotedata[
                                                                          'QuotesStatus'] ==
                                                                      1
                                                                  ? Colors
                                                                      .pink[300]
                                                                  : Colors.amber[
                                                                      600],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Ngày nhập:', style: secondaryB),
                                  SizedBox(width: screenWidth * 0.05),
                                  Expanded(
                                    child: Text(
                                        DateFormat('yyyy-MM-dd').format(
                                            DateTime.parse(
                                                '${_quotedata['QuotesDate']}')),
                                        style: secondary),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Nơi tổ chức:', style: secondaryB),
                                  SizedBox(width: screenWidth * 0.05),
                                  Text('${_quotedata['HallName']}',
                                      style: secondary),
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
                      height: screenHeight * 0.25,
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
                                Text('Nơi tổ chức:', style: secondaryB),
                                SizedBox(width: screenWidth * 0.05),
                                SizedBox(
                                  width: screenWidth * 0.43,
                                  child: TextField(
                                    controller: _hallnamecontroller,
                                    decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white))),
                                    style: secondary,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => SimpleDialog(
                                          title: const Text('Chọn nơi tổ chức'),
                                          children: _listhall
                                              .map((hall) => InkWell(
                                                    onTap: () {
                                                      _hallnamecontroller.text =
                                                          hall;
                                                      for (int i = 0;
                                                          i < _hall.length;
                                                          i++) {
                                                        if (hall ==
                                                            _hall[i][
                                                                'RET_DEFINEID']) {
                                                          Provider.of<DataModel>(
                                                                  context,
                                                                  listen: false)
                                                              .hallId(_hall[i][
                                                                  'RET_AUTOID']);
                                                        }
                                                      }

                                                      Navigator.pop(context);
                                                    },
                                                    child: ListTile(
                                                      title: Text(hall),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.3,
                                  child: TextField(
                                    controller: _guestQtycontroller,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Colors.white.withOpacity(0.3),
                                        border: const OutlineInputBorder(),
                                        labelText: 'Số khách',
                                        labelStyle: secondary),
                                    style: secondary,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.1),
                                SizedBox(
                                  width: screenWidth * 0.3,
                                  child: TextField(
                                    controller: _tableQtycontroller,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Colors.white.withOpacity(0.3),
                                        border: const OutlineInputBorder(),
                                        labelText: 'Số bàn',
                                        labelStyle: secondary),
                                    style: secondary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: screenWidth * 0.7,
                              child: TextField(
                                controller: _depositscontroller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.3),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Thanh toán trước',
                                    labelStyle: secondary),
                                style: secondary,
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
                        'Cập nhật Quote',
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
                              quoteUpdate(
                                  Provider.of<DataModel>(context, listen: false)
                                      .getHallId());
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
            ]),
    );
  }
}
