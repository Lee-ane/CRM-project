// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/components/buttons.dart';
import 'package:gallery_app/pages/dashboard.dart';
import 'package:gallery_app/components/text_fields.dart';
import 'package:gallery_app/style.dart/style.dart';
import 'package:provider/provider.dart';
import '../style.dart/model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref();
  String name = '';
  String address = '';
  String phone = '';
  String gender = '';
  late User user;

  @override
  void initState() {
    super.initState();
  }

  //Đăng nhập
  Future<void> login() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      Provider.of<DataModel>(context, listen: false).addEmail(email.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              'Đăng nhập thành công.',
            ),
          ),
        ),
      );
      user = _auth.currentUser!;
      Provider.of<DataModel>(context, listen: false).addUID(user.uid);
      fetchData();
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => const Gallery())));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'The email address is badly formatted.') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Email không hợp lệ.',
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Tài khoản hoặc mật khẩu không đúng.',
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // Lấy dữ liệu người dùng
  void fetchData() async {
    final snapshot = await ref.child('user').child(user.uid).get();
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
          gender = data['gender'];
          Provider.of<DataModel>(context, listen: false).addAddress(address);
          Provider.of<DataModel>(context, listen: false).addPhone(phone);
          Provider.of<DataModel>(context, listen: false).addGender(gender);
        }
      }
    } else {
      print('no data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/loginBG.png',
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 120),
                child: Stack(
                  children: [
                    Text('Gallery', style: loginLogo),
                    Padding(
                      padding: const EdgeInsets.only(top: 75, left: 35),
                      child: Text('Social media', style: loginTitle),
                    ),
                  ],
                ),
              ),
              //email
              Padding(
                  padding: const EdgeInsets.fromLTRB(50, 180, 50, 0),
                  child: LoginTF(
                    censor: false,
                    screenHeight: screenHeight,
                    text: 'Email',
                    controller: email,
                    icon: const Icon(Icons.camera_alt),
                  )),
              //Pasword
              Padding(
                  padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                  child: LoginTF(
                    censor: true,
                    screenHeight: screenHeight,
                    text: 'Password',
                    controller: password,
                    icon: const Icon(Icons.key),
                  )),
              LoginBT(
                  screenWidth: screenWidth,
                  function: () {
                    setState(() {
                      login();
                    });
                  }),
              RegistryBT(screenWidth: screenWidth, screenHeight: screenHeight),
              Padding(
                padding: const EdgeInsets.only(top: 65, left: 310),
                child: Image.asset(
                  'assets/signature.jpg',
                  width: screenWidth * 0.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
