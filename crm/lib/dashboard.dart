// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:crm/Models/data_model.dart';
import 'package:crm/components/buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:crm/style/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0;
  String urlHead = '';
  String key = '';
  int page = 1;
  String role = '';
  String username = '';
  String startDate = '';
  DateTime selectedDate = DateTime.now();
  String endDate = '';
  dynamic taskdata = [];
  List<String> statusData = [];
  Map<String, double> status = {};
  ScrollController scrollController = ScrollController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    key = Provider.of<DataModel>(context, listen: false).getKey();
    username = Provider.of<DataModel>(context, listen: false).getUser();
    role = Provider.of<DataModel>(context, listen: false).getRole();
    startDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    endDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    fetchTasks();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page++;
        fetchTasks();
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> fetchTasks() async {
    try {
      String url = "$urlHead/task/assign/user";
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
          taskdata = [...taskdata, ...data];
          for (int i = 0; i < taskdata.length; i++) {
            statusData.add(taskdata[i]['StatusName'].toString());
          }
          for (String element in statusData) {
            status[element] = (status[element] ?? 0) + 1;
          }
          _loadData();
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

  void _loadData() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(color: Colors.black),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 20, bottom: 20),
                  child: Text('Xin chào, $username', style: greeting),
                ),
                const Divider(color: Colors.white, thickness: 1),
                Center(
                  child: Text('Danh sách Công việc', style: title),
                ),
                // isLoading
                //     ? const Center(
                //         child: Padding(
                //           padding: EdgeInsets.only(top: 350),
                //           child: SpinKitDualRing(color: Colors.white),
                //         ),
                //       )
                //     : Visibility(
                //         visible: status.isNotEmpty,
                //         child: Center(
                //           child: Padding(
                //             padding: const EdgeInsets.only(top: 30),
                //             child: Container(
                //               width: screenWidth * 0.9,
                //               decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(15),
                //                   color: const Color(0xff4a4e69)),
                //               child: PieChart(
                //                 dataMap: status,
                //                 legendOptions: LegendOptions(
                //                     showLegendsInRow: false,
                //                     legendPosition: LegendPosition.right,
                //                     showLegends: true,
                //                     legendShape: BoxShape.circle,
                //                     legendTextStyle: piechart),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      width: screenWidth,
                      height: screenHeight * 0.18,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: taskdata.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: screenWidth * 0.6,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color(0xff4a4e69),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: screenWidth * 0.5,
                                      child: Text(taskdata[index]['TaskName'],
                                          style: piechart,
                                          overflow: TextOverflow.ellipsis)),
                                  Text(
                                      'Ngày tạo: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(taskdata[index]['CreatedDate']))}',
                                      style: piechart),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TaskPercent(
                                          screenHeight: screenHeight,
                                          screenWidth: screenWidth,
                                          progress: taskdata[index]
                                              ['Progress']),
                                      Text('${taskdata[index]['Progress']}%',
                                          style: piechart),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.fileLines), label: 'Deals'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.fileCircleCheck), label: 'Quotes'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff343442),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
