// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/components/buttons.dart';
import 'package:gallery_app/components/text_fields.dart';
import 'package:gallery_app/pages/dashboard.dart';
import 'package:gallery_app/style.dart/style.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../style.dart/model.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  List<File> selectedImages = [];
  List<File> validSelectedImages = [];
  final ref = FirebaseDatabase.instance.ref();
  final storage = FirebaseStorage.instance;
  int postcount = 0;
  String username = '';
  TextEditingController contentController = TextEditingController();
  //Lấy file ảnh
  Future<void> pickImages() async {
    try {
      FilePickerResult? results = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);

      if (results != null) {
        selectedImages = results.paths.map((path) => File(path!)).toList();
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  void openImagePicker() async {
    await pickImages();
    setState(() {});
  }

  //Hủy chọn ảnh
  void removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  //Đăng bài
  void post() async {
    try {
      if (contentController.text != '') {
        Provider.of<DataModel>(context, listen: false)
            .addContent(contentController.text);
        if (selectedImages.isNotEmpty) {
          Provider.of<DataModel>(context, listen: false)
              .addImages(selectedImages);
        } else {
          Provider.of<DataModel>(context, listen: false).addImages([]);
        }
        Provider.of<DataModel>(context, listen: false)
            .addUserNameList(username);
        Provider.of<DataModel>(context, listen: false).addDate(DateTime.now());
        await ref.update({'postcount': (postcount + 1)});
        await ref.child('post').child((postcount + 1).toString()).set({
          'username': username,
          'date': DateTime.now().toString(),
          'content': contentController.text,
          'file': selectedImages.toString()
        });
        contentController.clear();
        selectedImages.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Đăng bài thành công.',
              ),
            ),
          ),
        );
        const Duration(seconds: 2);
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => const Gallery()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Vui lòng nhập content.',
              ),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  //Lấy số thứ tự của bài Đăng
  void fetchPostIndex() async {
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          postcount = data['postcount'];
          print(postcount);
        }
      } else {
        print('no data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    username = Provider.of<DataModel>(context, listen: false).getUsername();
    fetchPostIndex();
  }

  @override
  void dispose() {
    super.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/createBG.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        width: screenWidth,
        height: screenHeight,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CloseButton(),
                  ),
                  CreateTF(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    contentController: contentController,
                  ),
                  Visibility(
                    visible: selectedImages.isNotEmpty,
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.2,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedImages.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 10),
                                  child: SizedBox(
                                    width: screenWidth * 0.2,
                                    child: Image.file(
                                      selectedImages[index],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 25,
                                  top: -10,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        removeImage(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          FetchPost(function: () {
                            setState(() {
                              openImagePicker();
                            });
                          }),
                          SizedBox(
                            width: screenWidth * 0.25,
                            child: const Text(
                              'Khuyến khích 1920 x 1080 px',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                              maxLines: 3,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                title: 'Tạo bài viết',
                                text: 'Bạn có chắc chắn muốn tạo?',
                                titleColor: Colors.blue,
                                confirmBtnText: 'Xác nhận',
                                confirmBtnColor: Colors.green,
                                cancelBtnText: 'Hủy',
                                confirmBtnTextStyle: quickAlertConfirm,
                                cancelBtnTextStyle: quickAlertCancel,
                                showCancelBtn: true,
                                onConfirmBtnTap: () {
                                  setState(() {
                                    post();
                                  });
                                },
                                onCancelBtnTap: () {
                                  Navigator.pop(context);
                                });
                          });
                        },
                        child: const CreateBT(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
