import 'package:flutter/material.dart';

class DataModel extends ChangeNotifier {
  void removeAll() {
    userid = 0;
    custid = 0;

    dealid = 0;
    quoteid = 0;

    startdate = '';
    enddate = '';

    tasktype = [];
    taskid = 0;
    opponame = [];
    oppid = 0;
    priority = [];
    priorid = 0;
    hallname = [];
    hallid = 0;
    employname = [];
    employid = 0;
    statusname = [];
    statusid = 0;
    notifyListeners();
  }

  void removeQuote() {
    quoteid = 0;
    notifyListeners();
  }

  void removeDeal() {
    dealid = 0;
    notifyListeners();
  }

  void removeTask() {
    taskid = 0;
    notifyListeners();
  }

  //Url
  String urlhead = 'http://senvangsolutions.somee.com/api';
  String getUrlHead() => urlhead;

  //Api key
  String apitoken = '';
  void key(String token) {
    apitoken = token;
    notifyListeners();
  }

  String getKey() => apitoken;

  //Name
  String username = '';
  void userName(String name) {
    username = name;
    notifyListeners();
  }

  String getUser() => username;

  //Password
  String password = '';
  void passWord(String passWord) {
    password = passWord;
    notifyListeners();
  }

  String getPassWord() => password;

  //Role
  String userrole = '';
  void userRole(String role) {
    userrole = role;
    notifyListeners();
  }

  String getRole() => userrole;

  //Id
  int userid = 0;
  void userId(int userId) {
    userid = userId;
    notifyListeners();
  }

  int getUserId() => userid;

  //Deal
  int dealid = 0;
  void dealId(int dealId) {
    dealid = dealId;
    notifyListeners();
  }

  int getDealId() => dealid;

  //Quote
  int quoteid = 0;
  void quoteId(int quoteId) {
    quoteid = quoteId;
    notifyListeners();
  }

  int getQuoteId() => quoteid;

  //StartDate
  String startdate = '';
  void startDate(String startDate) {
    startdate = startDate;
    notifyListeners();
  }

  String getStartDate() => startdate;

  //EndDate
  String enddate = '';
  void endDate(String endDate) {
    enddate = endDate;
    notifyListeners();
  }

  String getEndDate() => enddate;

  //Tasktype list
  List<String> tasktype = [];
  void taskType(List<String> taskType) {
    tasktype = taskType;
    notifyListeners();
  }

  List<String> getTaskType() => tasktype;

  //TaskId
  int taskid = 0;
  void taskId(int taskId) {
    taskid = taskId;
    notifyListeners();
  }

  int getTaskId() => taskid;

  //OppoName
  List<String> opponame = [];
  void oppName(List<String> oppoName) {
    opponame = oppoName;
    notifyListeners();
  }

  List<String> getOppName() => opponame;

  //OppId
  int oppid = 0;
  void oppId(int oppId) {
    oppid = oppId;
    notifyListeners();
  }

  int getOppId() => oppid;

  //Priority
  List<String> priority = [];
  void priorityName(List<String> prior) {
    priority = prior;
    notifyListeners();
  }

  List<String> getPriority() => priority;

  //PriorityId
  int priorid = 0;
  void priorityId(int priorId) {
    priorid = priorId;
    notifyListeners();
  }

  int getPriorityId() => priorid;

  //HallName
  List<String> hallname = [];
  void hallName(List<String> hallName) {
    hallname = hallName;
    notifyListeners();
  }

  List<String> getHallName() => hallname;

  //HallId
  int hallid = 0;
  void hallId(int hallId) {
    hallid = hallId;
    notifyListeners();
  }

  int getHallId() => hallid;

  //EmployeesName
  List<String> employname = [];
  void employName(List<String> employName) {
    employname = employName;
    notifyListeners();
  }

  List<String> getEmployName() => employname;

  //EmployId
  int employid = 0;
  void employId(int employId) {
    employid = employId;
    notifyListeners();
  }

  int getEmployId() => employid;

  //CustId
  int custid = 0;
  void custId(int custId) {
    custid = custId;
    notifyListeners();
  }

  int getCustId() => custid;

  //StatusName
  List<String> statusname = [];
  void statusName(List<String> statusName) {
    statusname = statusName;
    notifyListeners();
  }

  List<String> getStatusName() => statusname;

  //StatusId
  int statusid = 0;
  void statusId(int statusId) {
    statusid = statusId;
    notifyListeners();
  }

  int getStatusId() => statusid;
}

class Data {
  Data(this.status, this.value);

  final String status;
  final int value;
}

class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.from, this.to, this.background, this.isAllDay);
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
