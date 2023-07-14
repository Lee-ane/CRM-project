import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gallery_app/components/indicators.dart';

class Detail extends StatefulWidget {
  const Detail(
      {super.key,
      required this.imgs,
      required this.id,
      required this.content,
      required this.nameList});

  final List<File> imgs;

  final int id;

  final List<String> nameList;

  final String content;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<File> urls = [];
  List<String> names = [];
  late int _currentIndex = 0;
  bool isLike = false;
  List<String> words = [];

  @override
  void initState() {
    super.initState();
    urls = widget.imgs;
    names = widget.nameList;
    words = widget.content.split(' ');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: SlideIndicators(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    currentIndex: _currentIndex,
                    itemCount: urls.length,
                    activeColor: Colors.amber,
                    inactiveColor: Colors.grey),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: screenHeight,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  initialPage: _currentIndex,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: urls.map(
                  (image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: screenWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: Center(
                            child: Image.file(image),
                          ),
                        );
                      },
                    );
                  },
                ).toList(),
              ),
              IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 120, left: 30),
                  child: Row(
                    children: [
                      const Icon(Icons.person_4_outlined, color: Colors.white),
                      SizedBox(width: screenWidth * 0.025),
                      Text(
                        names[widget.id],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60, left: 30),
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    child: Text.rich(
                      TextSpan(
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
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isLike = !isLike;
                      });
                    },
                    icon: Icon(
                      isLike ? Icons.favorite : Icons.favorite_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.comment_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
