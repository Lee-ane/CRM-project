import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:crm/auth/login.dart';
import 'package:crm/style/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:crm/Models/data_model.dart';
import 'package:quickalert/quickalert.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  String urlHead = '';
  String key = '';
  String name = '';
  String role = '';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    name = Provider.of<DataModel>(context, listen: false).getUser();
    role = Provider.of<DataModel>(context, listen: false).getRole();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
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
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Họ tên: $name', style: info),
                          Text('Vai trò: $role', style: info),
                        ],
                      ),
                    ),
                  ]),
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
                          'Thông tin cá nhân',
                          style: userInfo,
                        ),
                      )),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, left: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(FontAwesomeIcons.arrowLeft,
                        color: Colors.white),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, right: 10),
                  child: IconButton(
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          title: 'Trở về màn hình đăng nhập',
                          titleColor: Colors.white,
                          text: 'Chắc chắn muốn đăng xuất chứ?',
                          textColor: Colors.white,
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
                            Provider.of<DataModel>(context, listen: false)
                                .removeAll();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                        );
                      },
                      icon: const Icon(FontAwesomeIcons.arrowRightFromBracket),
                      color: Colors.white),
                ),
              ),
            ]),
    );
  }
}
