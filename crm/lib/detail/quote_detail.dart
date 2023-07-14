// ignore_for_file: use_build_context_synchronously, duplicate_ignore, avoid_print

import 'dart:convert';

import 'package:crm/components/buttons.dart';
import 'package:crm/detail/task_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import 'package:crm/dash_board.dart';
import 'package:crm/Models/data_model.dart';
import 'package:crm/style/style.dart';

import '../create/add_task.dart';
import '../dash_board_user.dart';
import '../update/update_quote.dart';

class QuoteDetail extends StatefulWidget {
  const QuoteDetail({super.key});

  @override
  State<QuoteDetail> createState() => _QuoteDetailState();
}

class _QuoteDetailState extends State<QuoteDetail> {
  String urlHead = '';
  String key = '';
  String role = '';
  int quoteid = 0;
  int statusId = 0;
  dynamic _quotedata = [];
  dynamic _status = [];
  final List<String> _listStatusName = [];
  dynamic _task = [];
  bool _isLoading = true;
  bool _isVisible = false;

  final guestQty = TextEditingController();
  final tableQty = TextEditingController();
  final deposits = TextEditingController();
  final _statusNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    quoteid = Provider.of<DataModel>(context, listen: false).getQuoteId();
    role = Provider.of<DataModel>(context, listen: false).getRole();
    fetchQuoteDetail();
    fetchStatus();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

// Lấy trạng thái quotation
  Future<void> fetchStatus() async {
    try {
      String url = "$urlHead/status/quotes";
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
        if (decodedResponse is Map) {
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
          throw Exception('Failed to load data');
        }
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

//Cập nhật trạng thái quotation
  Future<void> quoteStatusUpdate() async {
    try {
      String url = "$urlHead/admin/quotes/status";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({"quotesId": quoteid, "statusId": statusId}),
        headers: headers,
      );
      if (response.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Cập nhật trạng thái thành công.'))));
          fetchQuoteDetail();
          _loadData();
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

// Xóa quotation
  Future<void> quoteDelete() async {
    try {
      String url = "$urlHead/quotes/delete";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({"quotesId": quoteid}),
        headers: headers,
      );
      if (response.statusCode == 200) {
        Provider.of<DataModel>(context, listen: false).removeQuote();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('Xóa quote thành công.'))));
        await Future.delayed(const Duration(seconds: 2));
        role == 'admin'
            ? Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DashBoardAd()))
            : Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DashBoardUser()));
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

// Lấy thông tin chi tiết về Quotation
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
        if (decodedResponse is Map) {
          var data1 = decodedResponse["Data"];
          setState(() {
            _quotedata = data1[0];
            fetchTask(_quotedata['DealId']);
          });
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

//Lấy dữ liệu về công việc
  Future<void> fetchTask(int dealid) async {
    try {
      String url = "$urlHead/quotes/task";
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
        if (decodedResponse is Map) {
          var data2 = decodedResponse["Data"];
          setState(() {
            _task = data2;
          });
        } else {
          throw Exception('Failed to load data');
        }
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Center(child: SpinKitDualRing(color: Colors.black))
            : SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: screenHeight * 0.2,
                        color: const Color(0xff343442),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: SizedBox(
                          width: screenWidth,
                          height: screenHeight * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Ngày nhập:', style: detailMainB),
                                  Text('Nơi tổ chức:', style: detailMainB),
                                  Row(
                                    children: [
                                      Text('Số khách: ', style: detailMainB),
                                      Text('${_quotedata['GuestQty']}',
                                          style: detailMain),
                                    ],
                                  ),
                                  Text('Thanh toán trước:', style: detailMainB),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      DateFormat('yyyy-MM-dd').format(
                                          DateTime.parse(
                                              '${_quotedata['QuotesDate']}')),
                                      style: detailMain),
                                  Text('${_quotedata['HallName']}',
                                      style: detailMain),
                                  Row(
                                    children: [
                                      Text('Số bàn: ', style: detailMainB),
                                      Text('${_quotedata['TableQty']}',
                                          style: detailMain),
                                    ],
                                  ),
                                  Text('${_quotedata['Deposits']}',
                                      style: detailMain),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: screenWidth * 0.75,
                            height: screenHeight * 0.1,
                            decoration: const BoxDecoration(
                                color: Color(0xff343442),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15))),
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isVisible = !_isVisible;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Công việc', style: title),
                                    const Icon(FontAwesomeIcons.angleDown,
                                        color: Colors.white)
                                  ],
                                )),
                          ),
                          Visibility(
                            visible: _isVisible &&
                                _quotedata['QuotesStatus'] == 2 &&
                                role == 'admin',
                            child: IconButton(
                                onPressed: () {
                                  Provider.of<DataModel>(context, listen: false)
                                      .quoteId(_quotedata['QuotesId']);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddTask()));
                                },
                                icon: const Icon(FontAwesomeIcons.plus),
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: _isVisible,
                        child: SingleChildScrollView(
                          child: Center(
                            child: SizedBox(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.35,
                              child: ListView.builder(
                                itemCount: _task.length,
                                itemBuilder: (context, index) {
                                  final gridWidth =
                                      MediaQuery.of(context).size.width;
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: GestureDetector(
                                      child: Container(
                                        width: screenWidth * 0.9,
                                        height: screenHeight * 0.15,
                                        color: const Color(0xff515167),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text('Tiêu đề: ',
                                                      style: primary),
                                                  SizedBox(
                                                    width: screenWidth * 0.55,
                                                    child: Text(
                                                        '${_task[index]['TaskName']}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts.lato(
                                                            textStyle: const TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white))),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                  'Ngày nhập: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(_task[index]['CreatedDate']))}',
                                                  style: primary),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      'Nhân viên: ${_task[index]['OBJ_NAME']}',
                                                      style: primary),
                                                  Container(
                                                    width: screenWidth * 0.06,
                                                    height:
                                                        screenHeight * 0.028,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: _task[index]
                                                                  ['Status'] ==
                                                              1
                                                          ? Colors.pink[300]
                                                          : _task[index][
                                                                      'Status'] ==
                                                                  2
                                                              ? Colors.blue
                                                              : _task[index][
                                                                          'Status'] ==
                                                                      3
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              TaskPercent(
                                                  screenHeight: screenHeight,
                                                  screenWidth: gridWidth * 2,
                                                  progress: _task[index]
                                                      ['Progress'])
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Provider.of<DataModel>(context,
                                                listen: false)
                                            .taskId(_task[index]['Id']);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const TaskDetail()));
                                      },
                                    ),
                                  );
                                },
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
                      padding: const EdgeInsets.only(top: 120),
                      child: Container(
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.1,
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
                                children: [
                                  Text('Tiêu đề: ${_quotedata['QuotesTitle']}',
                                      style: detailMainB),
                                  SizedBox(width: screenWidth * 0.05),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Trạng thái:', style: detailMainB),
                                  SizedBox(width: screenWidth * 0.05),
                                  Text(
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
                                                : _quotedata['QuotesStatus'] ==
                                                        2
                                                    ? Colors.green
                                                    : _quotedata[
                                                                'QuotesStatus'] ==
                                                            4
                                                        ? Colors.blue
                                                        : _quotedata[
                                                                    'QuotesStatus'] ==
                                                                6
                                                            ? Colors.orange[600]
                                                            : _quotedata[
                                                                        'QuotesStatus'] ==
                                                                    1
                                                                ? Colors
                                                                    .pink[300]
                                                                : Colors
                                                                    .amber[600],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: role == 'admin',
                                    child: IconButton(
                                        onPressed: () {
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.info,
                                            title: 'Cập nhật trạng thái',
                                            titleColor: Colors.white,
                                            backgroundColor:
                                                const Color(0xff515167),
                                            widget: TextField(
                                              decoration: InputDecoration(
                                                  fillColor:
                                                      const Color(0xFF343442),
                                                  filled: true,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                  hintText: 'Trạng thái quote',
                                                  hintStyle: secondaryB),
                                              controller: _statusNameController,
                                              style: secondary,
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      SimpleDialog(
                                                    title: const Text(
                                                        'Chọn trạng thái'),
                                                    children: _listStatusName
                                                        .map(
                                                            (status) => InkWell(
                                                                  onTap: () {
                                                                    _statusNameController
                                                                            .text =
                                                                        status;
                                                                    for (int i =
                                                                            0;
                                                                        i < _status.length;
                                                                        i++) {
                                                                      if (status ==
                                                                          _status[i]
                                                                              [
                                                                              'Name']) {
                                                                        Provider.of<DataModel>(context,
                                                                                listen: false)
                                                                            .statusId(_status[i]['Id']);
                                                                      }
                                                                    }
                                                                    statusId = Provider.of<DataModel>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getStatusId();

                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      ListTile(
                                                                    title: Text(
                                                                        status),
                                                                  ),
                                                                ))
                                                        .toList(),
                                                  ),
                                                );
                                              },
                                            ),
                                            confirmBtnText: 'Xác nhận',
                                            cancelBtnText: 'Hủy',
                                            cancelBtnTextStyle:
                                                GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.amber[600])),
                                            showCancelBtn: true,
                                            confirmBtnColor: Colors.green,
                                            onCancelBtnTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            onConfirmBtnTap: () {
                                              quoteStatusUpdate();
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                            FontAwesomeIcons.retweet,
                                            color: Colors.black)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text('Chi tiết Quote', style: detail),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Provider.of<DataModel>(context, listen: false)
                                .removeQuote();
                            Navigator.pop(context);
                          },
                          icon: const Icon(FontAwesomeIcons.arrowLeftLong,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: screenWidth * 0.15,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const QuoteUpdate()));
                            },
                            icon: const Icon(FontAwesomeIcons.pencil,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ));
  }
}
