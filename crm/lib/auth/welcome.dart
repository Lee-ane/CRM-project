import 'package:crm/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color(0xFF003566),
                  Color(0xFF001d3d),
                  Color(0xFF000814),
                ])),
            width: double.infinity,
            height: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth * 0.5,
                    child: const Image(
                      image: AssetImage('assets/logo.jpg'),
                    ),
                  ),
                  Center(
                      child: Text(
                    'Golden Lotus',
                    style: GoogleFonts.lobster(
                      textStyle: const TextStyle(
                          fontSize: 50,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
                  Center(
                      child: Text(
                    'Technology Solutions',
                    style: GoogleFonts.lobster(
                        textStyle: const TextStyle(
                      fontSize: 30,
                      color: Colors.orange,
                    )),
                  )),
                  SizedBox(height: screenHeight * 0.1),
                  const SpinKitWave(color: Colors.amber)
                ])));
  }
}
