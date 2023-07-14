import 'package:flutter/material.dart';
import 'package:gallery_app/style.dart/style.dart';
import 'package:quickalert/quickalert.dart';
import '../pages/create.dart';
import '../pages/register.dart';
import '../pages/user_info.dart';

//login
class LoginBT extends StatelessWidget {
  final double screenWidth;
  final void Function()? function;
  const LoginBT({super.key, required this.screenWidth, required this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.75,
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        onPressed: function,
        child: Text('Login', style: loginBT),
      ),
    );
  }
}

//register
class RegistryBT extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const RegistryBT(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      height: screenHeight * 0.05,
      child: TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const Register())));
        },
        child: Text('-Regist-', style: registryBT),
      ),
    );
  }
}

class RegisterBackBT extends StatelessWidget {
  const RegisterBackBT({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }
}

class RegisterConfirm extends StatelessWidget {
  final double screenWidth;
  final void Function()? function;
  const RegisterConfirm(
      {super.key, required this.screenWidth, required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: screenWidth * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xf0023047),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextButton(
          onPressed: function,
          child: Text('Confirm', style: registerConfirmBT),
        ),
      ),
    );
  }
}

//create
class FetchPost extends StatelessWidget {
  final void Function()? function;
  const FetchPost({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: function,
      icon: const Icon(
        Icons.photo,
        color: Colors.green,
      ),
    );
  }
}

class CreateBT extends StatelessWidget {
  const CreateBT({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Text('Post', style: title),
      ),
    );
  }
}

//user
class LogoutBT extends StatelessWidget {
  final double screenWidth;
  final void Function()? function;
  const LogoutBT(
      {super.key, required this.screenWidth, required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        width: screenWidth * 0.7,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xf0edf2fb),
            width: 1,
            style: BorderStyle.solid,
          ),
          color: const Color(0xf0abc4ff),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextButton(
          onPressed: () {
            QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: 'Bạn có muốn đăng xuất hay không?',
                titleColor: Colors.blue,
                confirmBtnText: 'Xác nhận',
                confirmBtnColor: Colors.green,
                cancelBtnText: 'Hủy',
                confirmBtnTextStyle: quickAlertConfirm,
                cancelBtnTextStyle: quickAlertCancel,
                showCancelBtn: true,
                onConfirmBtnTap: function,
                onCancelBtnTap: () {
                  Navigator.pop(context);
                });
          },
          child: Text('Logout', style: logoutBT),
        ),
      ),
    );
  }
}

class EditInfo extends StatelessWidget {
  final void Function()? function;
  const EditInfo({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, right: 30),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: function,
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class GenderSwitch extends StatelessWidget {
  final double screenHeight;
  final bool editable;
  final bool gender;
  final void Function()? function;
  const GenderSwitch(
      {super.key,
      required this.screenHeight,
      required this.editable,
      required this.gender,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.05,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: editable == false
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                gender == false ? Icons.female : Icons.male,
                color: gender == false ? Colors.pink[400] : Colors.blue,
              ),
            )
          : IconButton(
              onPressed: function,
              icon: Icon(
                gender == false ? Icons.female : Icons.male,
                color: gender == false ? Colors.pink[400] : Colors.blue,
              ),
            ),
    );
  }
}

class ConfirmUpdate extends StatelessWidget {
  final bool editable;
  final double screenHeight;
  final double screenWidth;
  final void Function()? function1;
  final void Function()? function2;
  const ConfirmUpdate(
      {super.key,
      required this.editable,
      required this.screenHeight,
      required this.screenWidth,
      required this.function1,
      required this.function2});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: editable,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: screenWidth * 0.45,
              height: screenHeight * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.green[100],
              ),
              child: TextButton(
                onPressed: function1,
                child: Text(
                  'Change password',
                  style: infoUpdate,
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.green[100],
              ),
              child: TextButton(
                onPressed: function2,
                child: Text(
                  'Update',
                  style: infoUpdate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//main
class Options extends StatelessWidget {
  final double screenWidth;
  final void Function()? function;
  const Options({super.key, required this.screenWidth, required this.function});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        width: screenWidth * 0.1,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green[400],
        ),
        child: IconButton(
          onPressed: function,
          icon: const Icon(
            Icons.keyboard_arrow_up_outlined,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class OptionBTs extends StatelessWidget {
  final double screenWidth;
  final void Function()? function;
  const OptionBTs(
      {super.key, required this.screenWidth, required this.function});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, bottom: 20),
        child: Column(
          children: [
            Container(
              width: screenWidth * 0.05,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.brown[400]),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const User()),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.person,
                  color: Color(0xffffe6a7),
                ),
              ),
            ),
            Container(
              width: screenWidth * 0.05,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.brown[400]),
              child: IconButton(
                onPressed: function,
                icon: const Icon(
                  Icons.delete,
                  color: Color(0xffffe6a7),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.brown[400], shape: BoxShape.circle),
              width: screenWidth * 0.05,
              child: IconButton(
                icon: const Icon(Icons.add),
                color: const Color(0xffffe6a7),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreatePost(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdatePostImg extends StatelessWidget {
  final void Function()? function;
  const UpdatePostImg({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: function,
      icon: const Icon(Icons.photo),
    );
  }
}

class UpdatePost extends StatelessWidget {
  final double screenHeight;
  final void Function()? function;
  const UpdatePost(
      {super.key, required this.screenHeight, required this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.05,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        child: const Text(
          'Update',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            title: 'Thay đổi nội dung bài viết',
            text: 'Bạn có chắc chắn muốn thay đổi nội dung chứ?',
            titleColor: Colors.blue,
            confirmBtnText: 'Xác nhận',
            confirmBtnColor: Colors.green,
            confirmBtnTextStyle: quickAlertConfirm,
            onConfirmBtnTap: function,
            showCancelBtn: true,
            cancelBtnText: 'Hủy',
            cancelBtnTextStyle: quickAlertCancel,
            onCancelBtnTap: () {
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

class RemoveImages extends StatelessWidget {
  final void Function()? function;
  const RemoveImages({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: function,
        icon: const Icon(
          Icons.cancel,
          color: Colors.green,
        ),
      ),
    );
  }
}

class RemoveOrUpdate extends StatelessWidget {
  final double screenHeight;
  final void Function()? function1;
  final void Function()? function2;
  final bool removePost;
  const RemoveOrUpdate(
      {super.key,
      required this.screenHeight,
      required this.removePost,
      required this.function1,
      required this.function2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.05,
      child: removePost
          ? IconButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  title: 'Xóa bài viết',
                  text: 'Bạn có chắc chắn muốn xóa bài viết này?',
                  titleColor: Colors.blue,
                  confirmBtnText: 'Xác nhận',
                  confirmBtnColor: Colors.green,
                  confirmBtnTextStyle: quickAlertConfirm,
                  onConfirmBtnTap: function1,
                  showCancelBtn: true,
                  cancelBtnText: 'Hủy',
                  cancelBtnTextStyle: quickAlertCancel,
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.blue,
              ),
            )
          : IconButton(
              onPressed: function2,
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ),
    );
  }
}

class EmptyLogo extends StatelessWidget {
  final double screenHeight;
  const EmptyLogo({super.key, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Image.asset(
            'assets/empty.jpg',
            height: screenHeight * 0.4,
          ),
        ),
        Text('Post something for everyone to see!', style: emptyText),
      ],
    );
  }
}
