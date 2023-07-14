import 'package:flutter/material.dart';
import 'package:gallery_app/style.dart/style.dart';

//login
class LoginTF extends StatelessWidget {
  final double screenHeight;
  final String text;
  final bool censor;
  final TextEditingController controller;
  final Icon icon;

  const LoginTF(
      {super.key,
      required this.screenHeight,
      required this.censor,
      required this.text,
      required this.controller,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.07,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          obscureText: censor,
          controller: controller,
          decoration: InputDecoration(
              prefixIcon: icon, border: InputBorder.none, hintText: text),
          style: loginTF,
        ),
      ),
    );
  }
}

//register
class RegisterTF extends StatelessWidget {
  final TextEditingController controller;
  final double screenWidth;
  final double screenHeight;
  final bool censor;
  final String text;
  const RegisterTF(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.controller,
      required this.censor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            obscureText: censor,
            controller: controller,
            decoration: InputDecoration(
              label: Text(text),
              border: InputBorder.none,
            ),
            style: loginTF,
          ),
        ),
      ),
    );
  }
}

//create
class CreateTF extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final TextEditingController contentController;
  const CreateTF(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.contentController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.3),
      ),
      width: screenWidth * 0.8,
      height: screenHeight * 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextField(
          controller: contentController,
          decoration: const InputDecoration(
              hintText: 'Write down something on your mind',
              hintStyle: TextStyle(
                fontSize: 15,
              ),
              border: InputBorder.none),
          maxLines: null,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}

//user
class InfoTF extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String text;
  final bool editable;
  final TextEditingController controller;
  const InfoTF(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.text,
      required this.editable,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return editable
        ? Container(
            width: screenWidth,
            height: screenHeight * 0.05,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: text,
                  hintStyle: loginTF,
                  border: InputBorder.none,
                ),
                style: loginTF,
              ),
            ),
          )
        : Container(
            width: screenWidth,
            height: screenHeight * 0.05,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(text, style: loginTF),
            ),
          );
  }
}

class InfoEmail extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String text;
  const InfoEmail(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.05,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(text, style: loginTF),
      ),
    );
  }
}

//search
class Search extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final void Function(String)? function;
  const Search(
      {super.key,
      required this.function,
      required this.screenHeight,
      required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
          onChanged: function,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
            ),
          ),
        ),
      ),
    );
  }
}

class PostUpdateTF extends StatelessWidget {
  final TextEditingController contentController;
  final List<String> content;
  final int index;
  final void Function(String)? function;
  const PostUpdateTF(
      {super.key,
      required this.contentController,
      required this.content,
      required this.function,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: Colors.black, width: 1, style: BorderStyle.solid),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: contentController,
          decoration: InputDecoration(
            hintText: content[index],
            border: InputBorder.none,
          ),
          onChanged: function,
          cursorColor: Colors.blue,
          maxLines: 3,
        ),
      ),
    );
  }
}

//