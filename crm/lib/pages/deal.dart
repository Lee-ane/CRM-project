// ignore_for_file: avoid_print

import 'package:crm/components/buttons.dart';
import 'package:crm/components/textfields.dart';
import 'package:crm/detail/deal_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:crm/Models/data_model.dart';
import 'package:crm/style/style.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../create/add_deal.dart';

class Deal extends StatefulWidget {
  const Deal({super.key});

  @override
  State<Deal> createState() => _DealState();
}

class _DealState extends State<Deal> {
  String urlHead = '';
  String key = '';
  String role = '';

  dynamic sumdata = [];
  dynamic roledealsdata = [];
  dynamic dealsdata = [];

  dynamic _hall = [];
  List<String> hallName = [];
  List<String> statusData = [];

  Map<String, int> status = {};

  DateTime selectedDate = DateTime.now();
  String startDate = '';
  String endDate = '';

  bool _isLoading = true;
  int page = 1;

  final _startDate = TextEditingController();
  final _endDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    role = Provider.of<DataModel>(context, listen: false).getRole();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    startDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    endDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    _startDate.text = startDate;
    _endDate.text = endDate;
    role == 'admin' ? fetchAdDeal() : fetchUserDeal();
    fetchHall();
    _loadData();
  }

//Lấy dữ liệu về các sảnh tổ chức tiệc
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
        var data = decodedResponse["Data"];
        setState(() {
          _hall = data;
          for (int l = 0; l < _hall.length; l++) {
            hallName.add(_hall[l]['RET_DEFINEID'].toString());
          }
          Provider.of<DataModel>(context, listen: false).hallName(hallName);
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

// Lấy dữ liệu về deal
  Future<void> fetchDeal() async {
    try {
      String url = "$urlHead/deal/user";
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
          dealsdata = [...dealsdata, ...data];
          // Lấy tổng deal
          for (dynamic map in dealsdata) {
            if (!sumdata.contains(map)) {
              sumdata.add(map);
            }
          }
          // Check deal trùng
          for (dynamic map in roledealsdata) {
            bool isDuplicate = false;
            for (dynamic existingMap in sumdata) {
              if (existingMap['Id'] == map['Id']) {
                isDuplicate = true;
                break;
              }
            }
            if (!isDuplicate) {
              sumdata.add(map);
            }
          }
          for (int i = 0; i < sumdata.length; i++) {
            statusData.add(sumdata[i]['StatusName'].toString());
          }
          for (String element in statusData) {
            status[element] = (status[element] ?? 0) + 1;
          }
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

// Lấy dữ liệu về tổng deal
  Future<void> fetchAdDeal() async {
    try {
      String url = "$urlHead/admin/deals";
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
          roledealsdata = [...roledealsdata, ...data];
          fetchDeal();
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

//Lấy dữ liệu về deal của nhân viên
  Future<void> fetchUserDeal() async {
    try {
      String url = "$urlHead/deal/assign/user";
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
          roledealsdata = [...roledealsdata, ...data];
          fetchDeal();
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
    _endDate.dispose();
    _startDate.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<Data> statusData =
        status.entries.map((entry) => Data(entry.key, entry.value)).toList();
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
                ))
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
                          padding: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.5,
                            child: sumdata.isEmpty
                                ? Empty(screenWidth: screenWidth)
                                : GridView.builder(
                                    itemCount: sumdata.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: GestureDetector(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: const Color(0xff343a40)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  DealStatus(
                                                      screenHeight:
                                                          screenHeight,
                                                      screenWidth: screenWidth,
                                                      status: sumdata[index]
                                                          ['Status']),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              screenWidth * 0.6,
                                                          child: Text(
                                                            '${sumdata[index]['Title']}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: primary,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Khách hàng: ${sumdata[index]['CustName']}',
                                                          style: secondary,
                                                        ),
                                                        Text(
                                                          'Ngày Nhập: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(sumdata[index]['DealDate']))}',
                                                          style: secondary,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            int dealid = sumdata[index]['Id'];
                                            Provider.of<DataModel>(context,
                                                    listen: false)
                                                .dealId(dealid);
                                            if (sumdata[index]['QuotesId']
                                                is int) {
                                              int quoteid =
                                                  sumdata[index]['QuotesId'];
                                              Provider.of<DataModel>(context,
                                                      listen: false)
                                                  .quoteId(quoteid);
                                            }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const DealDetail()));
                                          },
                                        ),
                                      );
                                    },
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            mainAxisExtent:
                                                screenHeight * 0.17)),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                  style: BorderStyle.solid),
                              color: Colors.white),
                          child: sumdata.isEmpty
                              ? Center(
                                  child:
                                      Text('No data to display.', style: empty))
                              : SfCircularChart(
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  legend: Legend(isVisible: true),
                                  series: <CircularSeries>[
                                    PieSeries<Data, String>(
                                        dataSource: statusData,
                                        xValueMapper: (Data data, _) =>
                                            data.status,
                                        yValueMapper: (Data data, _) =>
                                            data.value,
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                                isVisible: true)),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
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
                                sumdata = [];
                                statusData.clear();
                                if (role == 'admin') {
                                  fetchAdDeal();
                                } else {
                                  fetchUserDeal();
                                }
                                _loadData();
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddDeal()));
                            },
                            icon: const Icon(FontAwesomeIcons.plus,
                                color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(startDate))} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(endDate))}',
                              style: dashboard,
                            ),
                          )
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
