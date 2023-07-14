// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gallery_app/style.dart/style.dart';

class HashtagList extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final List<String> hashtags;
  const HashtagList(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.hashtags});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: ListView.builder(
          itemCount: hashtags.length,
          itemBuilder: ((context, index) {
            return ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      hashtags[index],
                      style: hashtagsText
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
