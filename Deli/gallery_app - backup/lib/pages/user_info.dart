// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/components/buttons.dart';
import 'package:gallery_app/components/text_fields.dart';
import 'package:gallery_app/pages/login.dart';
import 'package:gallery_app/style.dart/style.dart';
import 'package:provider/provider.dart';
import '../style.dart/model.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  String email = '';
  String name = '';
  String uid = '';
  String phone = '';
  String address = '';
  String genderString = '';
  bool editable = false;
  bool gender = false;
  int genderIndex = 0;
  TextEditingController newName = TextEditingController();
  TextEditingController newPhone = TextEditingController();
  TextEditingController newAddress = TextEditingController();
  final ref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    email = Provider.of<DataModel>(context, listen: false).getEmail();
    name = Provider.of<DataModel>(context, listen: false).getUsername();
    uid = Provider.of<DataModel>(context, listen: false).getUID();
    phone = Provider.of<DataModel>(context, listen: false).getPhone();
    address = Provider.of<DataModel>(context, listen: false).getAddress();
    genderString = Provider.of<DataModel>(context, listen: false).getGender();
    genderString == 'female' ? genderIndex = 0 : genderIndex = 1;
  }

  void edit() {
    setState(() {
      editable = !editable;
      newName.text = name;
      newAddress.text = address;
      newPhone.text = phone;
    });
  }

  void switchGender() {
    setState(() {
      gender = !gender;
      if (gender == true) {
        genderIndex = 1;
      } else {
        genderIndex = 0;
      }
    });
  }

  void updateInfo() {
    setState(() {
      if (newAddress.text.isNotEmpty && newPhone.text.isNotEmpty) {
        ref.child('user').child(uid).update({
          'phone': newPhone.text,
          'address': newAddress.text,
          'gender': genderIndex == 0 ? 'female' : 'male'
        });
        if (newName.text.isNotEmpty) {
          ref.child('user').child(uid).update({'name': newName.text});
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Cập nhật thông tin cá nhân thành công',
              ),
            ),
          ),
        );
        fetchData();
        editable = !editable;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Vui lòng nhập thông tin cập nhật',
              ),
            ),
          ),
        );
      }
    });
  }

  void fetchData() async {
    final snapshot = await ref.child('user').child(uid).get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        name = data['name'];
        Provider.of<DataModel>(context, listen: false).addUserName(name);
        if (data['address'] != null &&
            data['phone'] != null &&
            data['gender'] != null) {
          address = data['address'];
          phone = data['phone'];
          genderString = data['gender'];
          Provider.of<DataModel>(context, listen: false).addAddress(address);
          Provider.of<DataModel>(context, listen: false).addPhone(phone);
          Provider.of<DataModel>(context, listen: false)
              .addGender(genderString);
          setState(() {
            name = Provider.of<DataModel>(context, listen: false).getUsername();
            phone = Provider.of<DataModel>(context, listen: false).getPhone();
            address =
                Provider.of<DataModel>(context, listen: false).getAddress();
            genderString =
                Provider.of<DataModel>(context, listen: false).getGender();
          });
        }
      }
    } else {
      print('no data');
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Provider.of<DataModel>(context, listen: false).logout();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            decoration: const BoxDecoration(
              gradient: SweepGradient(
                colors: [Color(0xf0edf2fb), Color(0xf0abc4ff)],
              ),
            ),
            child: Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  color: Colors.black.withOpacity(0.05),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 10),
                  child: RegisterBackBT(),
                ),
                EditInfo(function: () {
                  edit();
                }),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text('Infomation', style: infoLogo),
                      ),
                    ),
                    ConfirmUpdate(
                        editable: editable,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        function1: () {},
                        function2: () {
                          updateInfo();
                        }),
                    Padding(
                      padding: EdgeInsets.only(
                          top: editable ? 20 : 59, left: 60, right: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InfoTF(
                            controller: newName,
                            screenWidth: screenWidth * 0.55,
                            screenHeight: screenHeight,
                            text: name,
                            editable: editable,
                          ),
                          GenderSwitch(
                            screenHeight: screenHeight,
                            editable: editable,
                            gender: gender,
                            function: () {
                              switchGender();
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: InfoEmail(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth * 0.7,
                        text: email,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: InfoTF(
                        controller: newPhone,
                        screenWidth: screenWidth * 0.7,
                        screenHeight: screenHeight,
                        text: phone.isNotEmpty ? phone : 'Phone number',
                        editable: editable,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: InfoTF(
                        controller: newAddress,
                        screenWidth: screenWidth * 0.7,
                        screenHeight: screenHeight,
                        text: address.isNotEmpty ? address : 'Address',
                        editable: editable,
                      ),
                    ),
                    LogoutBT(
                      screenWidth: screenWidth,
                      function: () {
                        logout();
                      },
                    ),
                  ],
                ),
                Positioned(
                  bottom: 30,
                  right: 10,
                  child: Image.asset(
                    'assets/info.jpg',
                    width: screenWidth * 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
