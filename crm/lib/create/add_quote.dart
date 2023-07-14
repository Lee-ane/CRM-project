// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:crm/dash_board.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:crm/Models/data_model.dart';
import 'package:crm/style/style.dart';

import '../dash_board_user.dart';

class AddQuote extends StatefulWidget {
  const AddQuote({super.key});

  @override
  State<AddQuote> createState() => _AddQuoteState();
}

class _AddQuoteState extends State<AddQuote> {
  String urlHead = '';
  String key = '';
  String role = '';
  dynamic _hall = [];
  int dealid = 0;

  String nowDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  List<String> _listhall = [];

  final _guestQtycontroller = TextEditingController();
  final _tableQtycontroller = TextEditingController();
  final _depositscontroller = TextEditingController();
  final hallname = TextEditingController();

  @override
  void initState() {
    super.initState();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    dealid = Provider.of<DataModel>(context, listen: false).getDealId();
    _listhall = Provider.of<DataModel>(context, listen: false).getHallName();
    role = Provider.of<DataModel>(context, listen: false).getRole();
    fetchHall();
  }

  @override
  void dispose() {
    super.dispose();
    _depositscontroller.dispose();
    _tableQtycontroller.dispose();
    _guestQtycontroller.dispose();
    hallname.dispose();
  }

// Lấy dữ liệu về nơi tổ chức
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

// Tạo quotation
  Future<void> createQuote(int hallId) async {
    try {
      final int guest = int.parse(_guestQtycontroller.text);
      final int table = int.parse(_tableQtycontroller.text);
      final int depos = int.parse(_depositscontroller.text);
      String url = "$urlHead/quotes/create";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "dealId": dealid,
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
              content: Center(child: Text('Tạo Quote thành công.'))));
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
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(children: [
          Column(
            children: [
              Container(
                height: formHeight * 0.1,
                color: const Color(0xff343442),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  height: formHeight * 0.9,
                  width: formWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text('Số khách dự tiệc', style: detailMainB),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                            controller: _guestQtycontroller,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            style: detailMainB),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 15),
                        child: Text('Số bàn', style: detailMainB),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                            controller: _tableQtycontroller,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            style: detailMain),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 15),
                        child: Text('Thanh toán trước', style: detailMainB),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                            controller: _depositscontroller,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            style: detailMain),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 15),
                        child: Text('Thể loại:', style: detailMainB),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: hallname,
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                          style: detailMain,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => SimpleDialog(
                                title: const Text('Chọn nơi tổ chức'),
                                children: _listhall
                                    .map((hall) => InkWell(
                                          onTap: () {
                                            hallname.text = hall;
                                            for (int i = 0;
                                                i < _hall.length;
                                                i++) {
                                              if (hall ==
                                                  _hall[i]['RET_DEFINEID']) {
                                                Provider.of<DataModel>(context,
                                                        listen: false)
                                                    .hallId(
                                                        _hall[i]['RET_AUTOID']);
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
                      Padding(
                        padding: const EdgeInsets.only(top: 99),
                        child: Container(
                          width: formWidth,
                          height: formHeight * 0.3,
                          color: const Color(0xff515167),
                        ),
                      )
                    ],
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
                    'Thêm Quote',
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
                    icon: const Icon(FontAwesomeIcons.arrowLeftLong,
                        color: Colors.white)),
                IconButton(
                  onPressed: () {
                    setState(() {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        title: 'Chắc chắn muốn tạo quote chứ?',
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
                          createQuote(
                              Provider.of<DataModel>(context, listen: false)
                                  .getHallId());
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
