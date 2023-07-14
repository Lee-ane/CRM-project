// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:crm/Models/data_model.dart';
import 'package:crm/components/buttons.dart';
import 'package:crm/detail/deal_detail.dart';
import 'package:crm/style/calendar.dart';
import 'package:crm/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

class EventCalendar extends StatefulWidget {
  const EventCalendar({super.key});

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  String urlHead = '';
  String key = '';

  dynamic sumdata = [];
  dynamic roledealsdata = [];
  dynamic dealsdata = [];
  Map<String, dynamic> filteredDate = {};
  dynamic filteredData = [];

  DateTime selectedDate = DateTime.now();
  String startDate = '';
  String endDate = '';
  int page = 1;
  bool _isLoading = true;

  List<Meeting> meetings = <Meeting>[];

  @override
  void initState() {
    super.initState();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    startDate = '2000-01-01';
    endDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    fetchAdDeal();
    _loadData();
  }

// Lấy dữ liệu về tổng deal
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
          for (dynamic map in dealsdata) {
            if (!sumdata.contains(map)) {
              sumdata.add(map);
            }
          }
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
            for (int i = 0; i < sumdata.length; i++) {
              DateTime startDate = DateTime.parse(sumdata[i]['DealDate']);
              DateTime endDate = DateTime.parse(sumdata[i]['CompleteDate']);
              meetings.add(Meeting(startDate, endDate, Colors.blue, false));
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

// Lọc ra deal trong ngày
  void filter(String formattedDate) async {
    try {
      for (int i = 0; i < sumdata.length; i++) {
        if (DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(sumdata[i]['DealDate'])) ==
            formattedDate) {
          filteredData = [];
          filteredDate.addAll({
            'Id': sumdata[i]['Id'],
            'Title': sumdata[i]['Title'],
            'CreatedDate': sumdata[i]['DealDate'],
            'Cust': sumdata[i]['CustName'],
            'Status': sumdata[i]['Status'],
          });
          filteredData.add(filteredDate);
        }
      }
    } catch (e) {
      print(e);
    }
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: SpinKitDualRing(color: Colors.black))
            : SfCalendar(
                view: CalendarView.month,
                todayHighlightColor: const Color(0xff343442),
                dataSource: MeetingDataSource(meetings),
                onTap: (calendarTapDetails) {
                  DateTime? selectedDate = calendarTapDetails.date;
                  String formattedDate = selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(selectedDate)
                      : '';
                  filter(formattedDate);
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (context) {
                          final dialogWidth = MediaQuery.of(context).size.width;
                          final dialogHeight =
                              MediaQuery.of(context).size.height;
                          return AlertDialog(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: dialogHeight * 0.1,
                                  width: dialogWidth,
                                  decoration: const BoxDecoration(
                                      color: Color(0xff343442)),
                                  child: Text(
                                    'List of the $formattedDate',
                                    style: secondaryB,
                                  ),
                                ),
                                Visibility(
                                  visible: filteredDate.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: SizedBox(
                                        height: dialogHeight * 0.5,
                                        width: dialogWidth,
                                        child: ListView.builder(
                                            itemCount: filteredData.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Provider.of<DataModel>(
                                                          context,
                                                          listen: false)
                                                      .dealId(
                                                          filteredData[index]
                                                              ['Id']);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const DealDetail()));
                                                },
                                                child: Container(
                                                  width: dialogWidth * 0.8,
                                                  height: dialogHeight * 0.08,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff343442),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          child: DealStatus(
                                                              screenHeight:
                                                                  dialogHeight,
                                                              screenWidth:
                                                                  dialogWidth,
                                                              status:
                                                                  filteredData[
                                                                          index]
                                                                      [
                                                                      'Status']),
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                'Tiêu đề: ${filteredData[index]['Title']}',
                                                                style:
                                                                    secondary),
                                                            Text(
                                                                'Khách hàng: ${filteredData[index]['Cust']}',
                                                                style:
                                                                    secondary),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            })),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  });
                },
              ),
      ),
    );
  }
}
