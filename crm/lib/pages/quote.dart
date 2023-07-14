// ignore_for_file: avoid_print

import 'package:crm/components/buttons.dart';
import 'package:crm/create/add_quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:crm/Models/data_model.dart';
import 'package:crm/style/style.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../detail/quote_detail.dart';

class Quote extends StatefulWidget {
  const Quote({super.key});

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {
  String urlHead = '';
  String key = '';
  String role = '';
  dynamic rolequotesdata = [];
  dynamic quotesdata = [];
  dynamic sumdata = [];
  DateTime selectedDate = DateTime.now();
  String startDate = '';
  String endDate = '';
  bool _isLoading = true;
  bool isPieChart = true;
  int page = 1;

  List<String> statusData = [];
  List<String> depositData = [];
  List<int> deposits = [];
  Map<String, int> status = {};
  Map<String, int> deposit = {};

  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    role = Provider.of<DataModel>(context, listen: false).getRole();
    startDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    endDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    _startDate.text = startDate;
    _endDate.text = endDate;
    role == 'admin' ? fetchAdQuote() : fetchUserQuote();
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    _loadData();
  }

// Lấy dữ liệu tổng quotation
  Future<void> fetchAdQuote() async {
    try {
      String url = "$urlHead/admin/quotes";
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
          rolequotesdata = [...rolequotesdata, ...data];
          fetchQuote();
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

// Lấy dữ liệu quotation với role admin
  Future<void> fetchQuote() async {
    try {
      String url = "$urlHead/quotes/user";
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
          quotesdata = [...quotesdata, ...data];

          for (dynamic map in rolequotesdata) {
            if (!sumdata.contains(map)) {
              sumdata.add(map);
            }
          }
          for (dynamic map in rolequotesdata) {
            bool isDuplicate = false;
            for (dynamic existingMap in sumdata) {
              if (existingMap['QuotesId'] == map['QuotesId']) {
                isDuplicate = true;
                break;
              }
            }
            if (!isDuplicate) {
              sumdata.add(map);
            }
            for (int i = 0; i < sumdata.length; i++) {
              statusData.add(sumdata[i]['StatusName'].toString());
              depositData.add(DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(sumdata[i]['CreatedDate']))
                  .toString());
              deposits.add(sumdata[i]['Deposits']);
            }
            for (String element in statusData) {
              status[element] = (status[element] ?? 0) + 1;
            }
            for (int i = 0; i < depositData.length; i++) {
              String datetime = depositData[i];
              int depo = deposits[i];
              deposit[datetime] = (deposit[datetime] ?? 0) + depo;
            }
          }
        });
      } else {
        'error:' 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      print(e);
    }
  }

// Lấy dữ liệu quotation với role nhân viên
  Future<void> fetchUserQuote() async {
    try {
      String url = "$urlHead/quotes/assign/user";
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
          rolequotesdata = [...rolequotesdata, ...data];
          fetchQuote();
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
    _startDate.dispose();
    _endDate.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<Data> statusData =
        status.entries.map((entry) => Data(entry.key, entry.value)).toList();
    List<Data> depositsData =
        deposit.entries.map((entry) => Data(entry.key, entry.value)).toList();
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
                                                  Container(
                                                    height: screenHeight * 0.2,
                                                    width: screenWidth * 0.02,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: sumdata[index]
                                                                  ['Status'] ==
                                                              3
                                                          ? Colors.red
                                                          : sumdata[index][
                                                                      'Status'] ==
                                                                  5
                                                              ? Colors.grey
                                                              : sumdata[index][
                                                                          'Status'] ==
                                                                      2
                                                                  ? Colors.green
                                                                  : sumdata[index]
                                                                              [
                                                                              'Status'] ==
                                                                          4
                                                                      ? Colors
                                                                          .blue
                                                                      : sumdata[index]['Status'] ==
                                                                              4
                                                                          ? Colors
                                                                              .orange[600]
                                                                          : sumdata[index]['Status'] == 1
                                                                              ? Colors.pink[300]
                                                                              : Colors.amber[600],
                                                    ),
                                                  ),
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
                                                            '${sumdata[index]['QuotesTitle']}',
                                                            style: primary,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Nhân viên đảm nhiệm: ${sumdata[index]['SaleMenName']}',
                                                          style: secondary,
                                                        ),
                                                        Text(
                                                          'Ngày Nhập: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(sumdata[index]['QuotesDate']))}',
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
                                            int quoteid =
                                                sumdata[index]['QuotesId'];
                                            Provider.of<DataModel>(context,
                                                    listen: false)
                                                .quoteId(quoteid);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const QuoteDetail()));
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
                          width: screenWidth * 0.8,
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
                                      Text('No data to display.', style: empty),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 2,
                                  itemBuilder: ((context, index) {
                                    return index == 0
                                        ? SfCircularChart(
                                            tooltipBehavior:
                                                TooltipBehavior(enable: true),
                                            legend: Legend(isVisible: true),
                                            series: <CircularSeries>[
                                              PieSeries<Data, String>(
                                                  dataSource: statusData,
                                                  xValueMapper:
                                                      (Data data, _) =>
                                                          data.status,
                                                  yValueMapper:
                                                      (Data data, _) =>
                                                          data.value,
                                                  dataLabelSettings:
                                                      const DataLabelSettings(
                                                          isVisible: true)),
                                            ],
                                          )
                                        : SfCartesianChart(
                                            title: ChartTitle(
                                                text: 'Deposits (M)',
                                                textStyle: dashboard),
                                            tooltipBehavior: _tooltipBehavior,
                                            primaryXAxis: CategoryAxis(),
                                            series: <ChartSeries>[
                                              ColumnSeries<Data, String>(
                                                dataSource: depositsData,
                                                xValueMapper: (Data data, _) =>
                                                    data.status,
                                                yValueMapper: (Data data, _) =>
                                                    data.value / 1000000,
                                              ),
                                            ],
                                          );
                                  }),
                                ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: sumdata.isNotEmpty,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(FontAwesomeIcons.ellipsis,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.custom,
                                title: 'Chọn ngày hiển thị',
                                titleColor: Colors.white,
                                backgroundColor: const Color(0xff343442),
                                barrierDismissible: true,
                                customAsset: 'assets/calenda.gif',
                                widget: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextField(
                                      controller: _startDate,
                                      decoration: InputDecoration(
                                          fillColor: const Color(0xff505062),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          hintText: 'yyyy-MM-dd',
                                          hintStyle: secondaryB,
                                          labelText: 'Ngày bắt đầu',
                                          labelStyle: secondaryB,
                                          border: InputBorder.none),
                                      onTap: () async {
                                        DateTime? newDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: selectedDate,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100));
                                        newDate ??= selectedDate;
                                        setState(() {
                                          _startDate.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(newDate!);
                                          startDate = DateFormat('yyyy-MM-dd')
                                              .format(newDate);
                                        });
                                      },
                                      style: primary,
                                    ),
                                    SizedBox(height: screenHeight * 0.025),
                                    TextField(
                                      controller: _endDate,
                                      decoration: InputDecoration(
                                          fillColor: const Color(0xff505062),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          hintText: 'yyyy-MM-dd',
                                          hintStyle: secondaryB,
                                          labelText: 'Ngày kết thúc',
                                          labelStyle: secondaryB,
                                          border: InputBorder.none),
                                      onTap: () async {
                                        DateTime? newDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: selectedDate,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100));
                                        newDate ??= DateTime.now();
                                        setState(() {
                                          _endDate.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(newDate!);
                                          endDate = DateFormat('yyyy-MM-dd')
                                              .format(newDate);
                                        });
                                      },
                                      style: primary,
                                    ),
                                  ],
                                ),
                                confirmBtnText: 'Xác nhận',
                                confirmBtnTextStyle: quickalertconf,
                                cancelBtnText: 'Hủy',
                                cancelBtnTextStyle: quickalertcancel,
                                showCancelBtn: true,
                                confirmBtnColor: Colors.amber,
                                onCancelBtnTap: () {
                                  Navigator.of(context).pop();
                                },
                                onConfirmBtnTap: () {
                                  setState(() {
                                    sumdata = [];
                                    statusData.clear();
                                    if (role == 'admin') {
                                      fetchAdQuote();
                                    } else {
                                      fetchUserQuote();
                                    }
                                    _loadData();
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                            icon: const Icon(
                              FontAwesomeIcons.calendar,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddQuote()));
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
                          ),
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
