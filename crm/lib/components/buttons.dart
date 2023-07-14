import 'package:crm/style/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickalert/quickalert.dart';

class LoginButton extends StatelessWidget {
  final bool option;
  final void Function()? function;
  const LoginButton({super.key, required this.option, required this.function});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: option == false ? function : null,
      child: Text('Login', style: loginBT),
    );
  }
}

class TaskPercent extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final int progress;
  const TaskPercent(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: screenWidth * 0.4,
        height: screenHeight * 0.01,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      Container(
        width: (progress / 100) * (screenWidth * 0.4),
        height: screenHeight * 0.01,
        decoration: BoxDecoration(
          color: (progress == 100) ? Colors.green : Colors.blue,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ]);
  }
}

class Empty extends StatelessWidget {
  final double screenWidth;
  const Empty({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              image: const AssetImage('assets/empty.jpg'),
              width: screenWidth * 0.5),
          Text('Today data is empty.', style: empty),
        ],
      ),
    );
  }
}

class DealStatus extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final dynamic status;
  const DealStatus(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.2,
      width: screenWidth * 0.02,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: status == 2
            ? Colors.amber[400]
            : status == 3
                ? const Color(0xffccff00)
                : status == 5
                    ? Colors.blue
                    : status == 6
                        ? Colors.green
                        : status == 12
                            ? Colors.orange[600]
                            : Colors.red,
      ),
    );
  }
}

class CalendarBT extends StatelessWidget {
  final double screenHeight;
  final Widget startDate;
  final Widget endDate;
  final void Function()? function;
  const CalendarBT(
      {super.key,
      required this.screenHeight,
      required this.startDate,
      required this.endDate,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.custom,
          title: 'Chọn ngày hiển thị',
          titleColor: Colors.white,
          backgroundColor: const Color(0xff343442),
          barrierDismissible: true,
          customAsset: 'assets/calenda.gif',
          widget: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              startDate,
              SizedBox(height: screenHeight * 0.025),
              endDate
            ],
          ),
          confirmBtnText: 'Xác nhận',
          confirmBtnTextStyle: quickalertconf,
          cancelBtnText: 'Hủy',
          cancelBtnTextStyle: quickalertcancel,
          showCancelBtn: true,
          confirmBtnColor: Colors.amber,
          onCancelBtnTap: () {
            Navigator.of(context).pop();
          },
          onConfirmBtnTap: function,
        );
      },
      icon: const Icon(
        FontAwesomeIcons.calendar,
        color: Colors.white,
      ),
    );
  }
}
