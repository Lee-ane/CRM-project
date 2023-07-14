import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_app/pages/login.dart';
import 'package:gallery_app/style.dart/style.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/welcomeBG.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100, bottom: 280),
                      child: Stack(
                        children: [
                          Text('Gallery', style: logo),
                          Padding(
                            padding: const EdgeInsets.only(top: 75, left: 40),
                            child: Text('Social Media', style: title),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: screenWidth,
                height: screenHeight,
                color: Colors.grey.withOpacity(0.2),
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 100,
                child: SpinKitSpinningLines(
                    color: Colors.grey, size: 100, lineWidth: 4),
              )
            ],
          ),
        ),
      ),
    );
  }
}
