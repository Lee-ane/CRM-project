import 'package:crm/style/style.dart';
import 'package:flutter/material.dart';

class LoginTF extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextEditingController controller;
  final bool obscure;
  const LoginTF(
      {super.key,
      required this.text,
      required this.icon,
      required this.controller,
      required this.obscure});

  @override
  Widget build(BuildContext context) {
    return TextField(
        obscureText: obscure,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: text,
            prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Icon(icon, color: Colors.white))),
            hintStyle: loginTF),
        style: loginTF,
        controller: controller);
  }
}

class DateTF extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final void Function()? function;
  const DateTF(
      {super.key,
      required this.controller,
      required this.text,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          fillColor: const Color(0xff505062),
          filled: true,
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: 'yyyy-MM-dd',
          hintStyle: secondaryB,
          labelText: text,
          labelStyle: secondaryB,
          border: InputBorder.none),
      onTap: function,
      style: primary,
    );
  }
}
