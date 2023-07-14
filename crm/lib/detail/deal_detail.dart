// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:crm/dash_board.dart';
import 'package:crm/detail/quote_detail.dart';
import 'package:crm/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:crm/Models/data_model.dart';

import '../create/add_quote.dart';
import '../dash_board_user.dart';
import '../update/update_deal.dart';

class DealDetail extends StatefulWidget {
  const DealDetail({super.key});

  @override
  State<DealDetail> createState() => _DealDetailState();
}

class _DealDetailState extends State<DealDetail> {
  String role = '';
  String urlHead = '';
  String key = '';
  int dealid = 0;
  int quoteid = 0;
  int statusId = 0;
  dynamic _dealdata = [];
  dynamic _status = [];
  bool _isLoading = true;
  bool _canDelete = false;

  List<String> _type = [];
  final List<String> _listStatusName = [];

  final dealtitle = TextEditingController();
  final open = TextEditingController();
  final deploy = TextEditingController();
  final note = TextEditingController();

  final _statusNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    role = Provider.of<DataModel>(context, listen: false).getRole();
    dealid = Provider.of<DataModel>(context, listen: false).getDealId();
    quoteid = Provider.of<DataModel>(context, listen: false).getQuoteId();
    _type = Provider.of<DataModel>(context, listen: false).getOppName();
    fetchDealDetail();
    fetchStatus();
    _loadData();
  }

//Lấy dữ liệu trạng thái của deal
  Future<void> fetchStatus() async {
    try {
      String url = "$urlHead/status/deal";
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

// Lấy thông tin chi tiết về deal
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
          if (_dealdata['Status'] == 2 ||
              _dealdata['Status'] == 6 ||
              _dealdata['Status'] == 8) {
            _canDelete = true;
          }
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

// Xóa deal
  Future<void> dealDelete() async {
    try {
      String url = "$urlHead/deal/delete";
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
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Xóa deal thành công.'))));
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

// Cập nhật trạng thái deal
  Future<void> dealStatusUpdate() async {
    try {
      String url = "$urlHead/admin/deal/status";
      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({"dealId": dealid, "statusId": statusId}),
        headers: headers,
      );
      if (response.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Cập nhật trạng thái thành công.'))));
          fetchDealDetail();
          _loadData();
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

  @override
  void dispose() {
    super.dispose();
    dealtitle.dispose();
    open.dispose();
    deploy.dispose();
    note.dispose();
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
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: screenHeight * 0.2,
                        color: const Color(0xff343442),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: SizedBox(
                          width: screenWidth,
                          height: screenHeight * 0.5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Tiêu đề:', style: detailMainB),
                                    SizedBox(
                                      width: screenWidth * 0.5,
                                      child: Text(
                                        '${_dealdata['Title']}',
                                        style: detailMain,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Trạng thái:', style: detailMainB),
                                    SizedBox(width: screenWidth * 0.05),
                                    Text(
                                      '${_dealdata['StatusName']}',
                                      style: GoogleFonts.aBeeZee(
                                        textStyle: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none,
                                            color: _dealdata['Status'] == 2
                                                ? Colors.amber[400]
                                                : _dealdata['Status'] == 3
                                                    ? const Color(0xffccff00)
                                                    : _dealdata['Status'] == 5
                                                        ? Colors.blue
                                                        : _dealdata['Status'] ==
                                                                6
                                                            ? Colors.green
                                                            : _dealdata['Status'] ==
                                                                    12
                                                                ? Colors
                                                                    .orange[600]
                                                                : Colors.red),
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
                                                    fillColor: Colors.white
                                                        .withOpacity(0.5),
                                                    filled: true,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    hintText: 'Trạng thái deal',
                                                    hintStyle: detailMainB),
                                                controller:
                                                    _statusNameController,
                                                style: detailMain,
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        SimpleDialog(
                                                      title: const Text(
                                                          'Chọn trạng thái'),
                                                      children: _listStatusName
                                                          .map(
                                                              (status) =>
                                                                  InkWell(
                                                                    onTap: () {
                                                                      _statusNameController
                                                                              .text =
                                                                          status;
                                                                      for (int i =
                                                                              0;
                                                                          i < _status.length;
                                                                          i++) {
                                                                        if (status ==
                                                                            _status[i]['Name']) {
                                                                          Provider.of<DataModel>(context, listen: false).statusId(_status[i]
                                                                              [
                                                                              'Id']);
                                                                        }
                                                                      }
                                                                      statusId = Provider.of<DataModel>(
                                                                              context,
                                                                              listen: false)
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
                                                          color: Colors
                                                              .amber[600])),
                                              showCancelBtn: true,
                                              confirmBtnColor: Colors.green,
                                              onCancelBtnTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              onConfirmBtnTap: () {
                                                dealStatusUpdate();
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
                                Row(
                                  children: [
                                    Text('Ngày nhập: ', style: detailMainB),
                                    SizedBox(width: screenWidth * 0.05),
                                    Expanded(
                                        child: Text(
                                            DateFormat('yyyy-MM-dd').format(
                                                DateTime.parse(
                                                    '${_dealdata['DealDate']}')),
                                            style: detailMain))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Ngày hoàn thành: ',
                                        style: detailMainB),
                                    SizedBox(width: screenWidth * 0.05),
                                    Expanded(
                                        child: Text(
                                            DateFormat('yyyy-MM-dd').format(
                                                DateTime.parse(
                                                    '${_dealdata['CompleteDate']}')),
                                            style: detailMain))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Ngày triển khai:',
                                        style: detailMainB),
                                    SizedBox(width: screenWidth * 0.05),
                                    SizedBox(
                                      width: screenWidth * 0.3,
                                      child: Text(
                                          DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(
                                                  '${_dealdata['DeployDate']}')),
                                          style: detailMain),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Ngày mở tiệc:', style: detailMainB),
                                    SizedBox(width: screenWidth * 0.05),
                                    SizedBox(
                                      width: screenWidth * 0.3,
                                      child: Text(
                                          DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(
                                                  '${_dealdata['Openning']}')),
                                          style: detailMain),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Thể loại:', style: detailMainB),
                                    SizedBox(width: screenWidth * 0.05),
                                    Text(_type[_dealdata['OppType'] - 1],
                                        style: detailMain),
                                  ],
                                ),
                                Text('Ghi chú:', style: detailMainB),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey,
                                          width: 0.5,
                                          style: BorderStyle.solid)),
                                  width: screenWidth * 0.7,
                                  height: screenHeight * 0.15,
                                  child: Text(
                                    '${_dealdata['Notes']}',
                                    style: detailMain,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Visibility(
                                  visible: (_canDelete &&
                                      quoteid == 0 &&
                                      role == 'admin'),
                                  child: SizedBox(
                                    width: screenWidth * 0.1,
                                    child: IconButton(
                                      icon: const Icon(FontAwesomeIcons.trash,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.warning,
                                            title:
                                                'Chắc chắn muốn xóa deal chứ?',
                                            titleColor: Colors.white,
                                            confirmBtnText: 'Xác nhận',
                                            confirmBtnColor: Colors.green,
                                            confirmBtnTextStyle:
                                                GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                            cancelBtnTextStyle:
                                                GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.amber[600])),
                                            backgroundColor:
                                                const Color(0xff515167),
                                            cancelBtnText: 'Hủy',
                                            showCancelBtn: true,
                                            onCancelBtnTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            onConfirmBtnTap: () {
                                              dealDelete();
                                            },
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Quote
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.62,
                              height: screenHeight * 0.08,
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xff515167))),
                                child: Text('Quote', style: title),
                                onPressed: () {
                                  if (quoteid != 0) {
                                    Provider.of<DataModel>(context,
                                            listen: false)
                                        .quoteId(quoteid);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const QuoteDetail()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Center(
                                                child: Text(
                                                    'This deal have no quote. Please create quote'))));
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Visibility(
                              visible: quoteid == 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xff515167),
                                    borderRadius: BorderRadius.circular(5)),
                                height: screenHeight * 0.08,
                                width: screenWidth * 0.15,
                                child: IconButton(
                                  onPressed: () {
                                    Provider.of<DataModel>(context,
                                            listen: false)
                                        .dealId(Provider.of<DataModel>(context,
                                                listen: false)
                                            .getDealId());
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AddQuote()));
                                  },
                                  icon: const Icon(FontAwesomeIcons.plus),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text('Chi tiết Deal', style: detail),
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
                              Provider.of<DataModel>(context, listen: false)
                                  .dealId(_dealdata["Id"]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DealUpdate()));
                            },
                            icon: const Icon(FontAwesomeIcons.pencil,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
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
                                  Text('Nhân viên đảm nhiệm: ',
                                      style: detailMainB),
                                  SizedBox(width: screenWidth * 0.05),
                                  Expanded(
                                      child: Text('${_dealdata['SaleMenName']}',
                                          style: detailMain))
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Số điện thoại: ', style: detailMainB),
                                  SizedBox(width: screenWidth * 0.05),
                                  Expanded(
                                      child: Text(
                                          '${_dealdata['SaleMenPhone']}',
                                          style: detailMain))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Card buildButton({
    required onTap,
    required title,
    required text,
    required leadingImage,
  }) {
    return Card(
      shape: const StadiumBorder(),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundImage: AssetImage(
            leadingImage,
          ),
        ),
        title: Text(title ?? ""),
        subtitle: Text(text ?? ""),
        trailing: const Icon(
          Icons.keyboard_arrow_right_rounded,
        ),
      ),
    );
  }
}
