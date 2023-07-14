// ignore_for_file: avoid_print, use_build_context_synchronously, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/components/buttons.dart';
import 'package:gallery_app/components/text_fields.dart';
import 'package:gallery_app/style.dart/style.dart';
import 'package:provider/provider.dart';

import '../style.dart/model.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

//Đăng ký
  Future<void> register() async {
    try {
      if (password.text == confirmPassword.text) {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        await _auth.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        user = _auth.currentUser!;
        Provider.of<DataModel>(context, listen: false).addUID(user.uid);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                'Đã đăng ký thành công. ${email.text}',
              ),
            ),
          ),
        );
        FirebaseDatabase.instance.ref().child('user').child(user.uid).set({
          'email': email.text,
          'name': name.text,
          'password': password.text
        });
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Mật khẩu không trùng khớp.',
              ),
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Mật khẩu không hợp lệ.',
              ),
            ),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Tài khoản này đã tồn tại.',
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight,
                decoration: const BoxDecoration(
                  color: Color(0xf0fdf0d5),
                ),
              ),
              Image(
                image: const AssetImage('assets/register.png'),
                width: screenWidth,
              ),
              const RegisterBackBT(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 260),
                  child: Column(
                    children: [
                      Text('Register', style: registerLogo),
                      RegisterTF(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        censor: false,
                        controller: name,
                        text: 'Full name',
                      ),
                      RegisterTF(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        censor: false,
                        controller: email,
                        text: 'Email',
                      ),
                      RegisterTF(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        censor: true,
                        controller: password,
                        text: 'Password',
                      ),
                      RegisterTF(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        censor: true,
                        controller: confirmPassword,
                        text: 'Confirm password',
                      ),
                      RegisterConfirm(
                          screenWidth: screenWidth,
                          function: () {
                            setState(() {
                              register();
                            });
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
