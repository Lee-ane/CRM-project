import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/components/indicators.dart';
import 'package:gallery_app/style.dart/model.dart';
import 'package:provider/provider.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  List<File> images = [];
  List<String> userList = [];
  List<String> content = [];
  List<String> words = [];
  int usid = 0;
  int imageIndex = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    images = Provider.of<DataModel>(context, listen: false).getSliderScreen();
    imageIndex =
        Provider.of<DataModel>(context, listen: false).getSliderIndex();
    userList = Provider.of<DataModel>(context, listen: false).getUsernames();
    usid = Provider.of<DataModel>(context, listen: false).getUserIndex();
    content = Provider.of<DataModel>(context, listen: false).getContent();
    words = content[usid].split(' ');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.black.withOpacity(0.8),
        child: SafeArea(
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      SlideIndicators(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          currentIndex: _currentIndex,
                          itemCount: images.length,
                          activeColor: Colors.amber,
                          inactiveColor: Colors.grey),
                      SizedBox(
                        width: screenWidth * 0.15,
                      )
                    ],
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: screenHeight * 0.7,
                    viewportFraction: 0.8,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    initialPage: imageIndex,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: images.map((file) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Image.file(file, fit: BoxFit.cover);
                      },
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                  child: Row(
                    children: [
                      const Icon(Icons.person_4_outlined, color: Colors.white),
                      SizedBox(width: screenWidth * 0.025),
                      Text(
                        userList[usid],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.12,
                    child: Text.rich(TextSpan(
                        children: words
                            .map(
                              (word) => TextSpan(
                                text: '$word ',
                                style: word.startsWith('#')
                                    ? const TextStyle(
                                        color: Colors.blue, fontSize: 14)
                                    : const TextStyle(
                                        color: Colors.white, fontSize: 14),
                              ),
                            )
                            .toList())),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.comment_rounded,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
