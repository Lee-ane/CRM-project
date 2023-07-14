// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:crm/components/buttons.dart';
import 'package:crm/components/textfields.dart';
import 'package:crm/dash_board.dart';
import 'package:crm/dash_board_user.dart';
import 'package:crm/style/style.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:crm/Models/data_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String urlHead = '';
  String key = '';

  String username = '';

  late String _selectedCN = '';
  List<dynamic> _cN = [];

  int userId = 0;
  String role = '';
  dynamic data = [];
  dynamic check = [];
  String name = '';
  bool showCN = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  String loginName = '';

  LocalAuthentication auth = LocalAuthentication();
  String autherized = "Not authenrized";
//Đăng nhập bằng sinh trắc học
  Future<void> biometricLogin() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: "Scan your finget to authenticate",
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true, useErrorDialogs: true));
    } on PlatformException catch (e) {
      print(e);
    }
    if (authenticated) {
      loginName = Provider.of<DataModel>(context, listen: false).getUser();
      if (loginName.isNotEmpty) {
        showCN = true;

        key = Provider.of<DataModel>(context, listen: false).getKey();
        _email.text = Provider.of<DataModel>(context, listen: false).getUser();
        _pass.text =
            Provider.of<DataModel>(context, listen: false).getPassWord();
        _fetchCN();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text('Login success. Welcome $loginName'))));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Center(child: Text('Login for the first time is required'))));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Login failed. Please retry'))));
    }
  }

  @override
  void initState() {
    super.initState();
    urlHead = Provider.of<DataModel>(context, listen: false).getUrlHead();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _pass.dispose();
  }

//Đăng nhập
  Future<void> _login() async {
    try {
      final String username = _email.text;
      final String password = _pass.text;
      String url = '$urlHead/auth/login';
      var headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'username': username,
          'password': password,
        }),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var message = decodedResponse["Message"];
        var log = decodedResponse["Data"];
        if (message == "Success") {
          setState(() {
            data = log;
            key = data['AccessToken'];
            role = data['Role'];
            showCN = true;
            Provider.of<DataModel>(context, listen: false).key(key);
            Provider.of<DataModel>(context, listen: false).userName(username);
            Provider.of<DataModel>(context, listen: false).passWord(password);
            Provider.of<DataModel>(context, listen: false).userRole(role);
            _fetchCN();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Center(child: Text('Login failed. Please retry'))));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(
                child: Text(
                    'Cant connect to the server right now. Please try again later'))));
      }
    } catch (e) {
      print(e);
    }
  }

//Lấy dữ liệu chi nhánh
  Future<void> _fetchCN() async {
    try {
      String url = '$urlHead/org/list';

      var headers = {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);

        var data = decodedResponse["Data"];
        setState(() {
          _cN = data.toList();
          _selectedCN = _cN[0]['OBJ_NAME'];
          Provider.of<DataModel>(context, listen: false).userName(_email.text);
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                height: screenHeight,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/background.jpg'),
                        fit: BoxFit.fill)),
                child: Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.2),
                          Center(child: Text('Golden Lotus', style: logo)),
                          Center(
                              child:
                                  Text('Technology Solutions', style: logo2)),
                          SizedBox(height: screenHeight * 0.05),
                          //Branches
                          Visibility(
                              visible: showCN,
                              child: Container(
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.06,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.7),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16))),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: DropdownButton<String>(
                                        value: _selectedCN,
                                        icon: const Icon(
                                            FontAwesomeIcons.angleDown),
                                        isExpanded: true,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedCN = newValue!;
                                            role == 'admin'
                                                ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const DashBoardAd()))
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const DashBoardUser()));
                                          });
                                        },
                                        items: _cN
                                            .map<DropdownMenuItem<String>>(
                                                (item) {
                                          return DropdownMenuItem<String>(
                                              value: item['OBJ_NAME'],
                                              child: Text(item['OBJ_NAME'],
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)));
                                        }).toList()),
                                  )))),
                          SizedBox(height: screenHeight * 0.02),
                          Container(
                              width: screenWidth * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey.withOpacity(0.7)),
                              child: LoginTF(
                                  text: 'Username',
                                  icon: FontAwesomeIcons.circleUser,
                                  controller: _email,
                                  obscure: false)),
                          SizedBox(height: screenHeight * 0.02),
                          Container(
                              width: screenWidth * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey.withOpacity(0.7)),
                              child: LoginTF(
                                  text: 'Password',
                                  icon: FontAwesomeIcons.lock,
                                  controller: _pass,
                                  obscure: true)),
                          SizedBox(height: screenHeight * 0.03),
                          GestureDetector(
                              onTap: biometricLogin,
                              child: SizedBox(
                                  width: screenWidth * 0.25,
                                  child: const Image(
                                      image: AssetImage(
                                          'assets/fingerprint.png')))),
                          SizedBox(height: screenHeight * 0.03),
                          Container(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.06,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.amber[400]),
                              child: LoginButton(
                                  option: showCN,
                                  function: () {
                                    _login();
                                  })),
                        ])))));
  }
}
