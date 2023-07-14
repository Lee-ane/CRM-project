import 'dart:io';

import 'package:flutter/material.dart';

class DataModel extends ChangeNotifier {
  void logout() {
    userName = '';
    email = '';
    uid = '';
    address = '';
    phone = '';
    gender = '';
  }

  List<String> content = [];
  void addContent(String contentChild) {
    content.add(contentChild);
  }

  List<String> getContent() => content;

  List<List<File>> images = [];
  void addImages(List<File> imgs) {
    images.add(List.from(imgs));
  }

  List<List<File>> getImages() => images;
//
  List<DateTime> date = [];
  void addDate(DateTime current) {
    date.add(current);
  }

  List<DateTime> getDate() => date;
//
  List<File> selectedImages = [];
  void addSelectedImg(List<File> selectedImg) {
    selectedImages = selectedImg;
  }

  List<File> getSelectedImg() => selectedImages;
//
  List<File> sliderScreen = [];
  void sliderScreenImages(List<File> sliderImages) {
    sliderScreen = sliderImages;
    notifyListeners();
  }

  List<File> getSliderScreen() => sliderScreen;
//
  int sliderindex = 0;
  void sliderIndex(int index) {
    sliderindex = index;
    notifyListeners();
  }

  int getSliderIndex() => sliderindex;
//
  List<String> usernames = [];
  void addUserNameList(String name) {
    usernames.add(name);
  }

  List<String> getUsernames() => usernames;
//
  String userName = '';
  void addUserName(String user) {
    userName = user;
  }

  String getUsername() => userName;
//
  String email = '';
  void addEmail(String text) {
    email = text;
  }

  String getEmail() => email;
//
  String uid = '';
  void addUID(String id) {
    uid = id;
  }

  String getUID() => uid;
//
  String address = '';
  void addAddress(String ads) {
    address = ads;
  }

  String getAddress() => address;
//
  String phone = '';
  void addPhone(String num) {
    phone = num;
  }

  String getPhone() => phone;
//
  String gender = '';
  void addGender(String gen) {
    gender = gen;
  }

  String getGender() => gender;
//
  int postLength = 0;
  void addPostLength(int lenght) {
    postLength = lenght;
  }

  int getPostLength() => postLength;
//
  int userIndex = 0;
  void addUserIndex(int usid) {
    userIndex = usid;
    notifyListeners();
  }

  int getUserIndex() => userIndex;
}

class Post {
  final String username;
  final String date;
  final String content;
  final String file;

  Post(this.username, this.date, this.content, this.file);
}
