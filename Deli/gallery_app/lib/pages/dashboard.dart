// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_app/components/buttons.dart';
import 'package:gallery_app/components/text_fields.dart';
import 'package:gallery_app/pages/slider.dart';
import 'package:gallery_app/style.dart/style.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../components/list_view.dart';
import '../style.dart/model.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  String uid = '';
  List<String> users = [];
  List<String> words = [];
  List<String> content = [];
  List<String> hashtags = [];
  List<DateTime> postDate = [];
  List<File> selectedImages = [];
  List<List<File>> postImages = [];

  TextEditingController contentController = TextEditingController();

  final ref = FirebaseDatabase.instance.ref('post');

  bool search = false;
  bool options = false;
  bool editable = false;
  bool removePost = false;

  int editableIndex = 0;
  int _currentIndex = 0;
  int maxImages = 5;

  late String imgURL;
  final storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    uid = Provider.of<DataModel>(context, listen: false).getUID();
    postDate = Provider.of<DataModel>(context, listen: false).getDate();
    content = Provider.of<DataModel>(context, listen: false).getContent();
    users = Provider.of<DataModel>(context, listen: false).getUsernames();
    postImages = Provider.of<DataModel>(context, listen: false).getImages();
    imgURL = '';
  }

  //Hỗ trợ lấy file hình ảnh từ thư mục của thiết bị
  Future<void> pickImages() async {
    try {
      FilePickerResult? results = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);

      if (results != null) {
        setState(() {
          selectedImages =
              results.files.map((file) => File(file.path!)).toList();
        });
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  //Tìm kiếm hashtag
  List<String> filterStrings(String searchItem) {
    try {
      if (searchItem.isEmpty) {
        setState(() {
          search = false;
          hashtags = [];
        });
      } else {
        setState(() {
          search = true;
          hashtags.clear();
          for (String items in content) {
            List<String> text = items.split(' ');
            for (String word in text) {
              if (word.startsWith('#') &&
                  word.substring(1).contains(searchItem)) {
                hashtags.add(word);
              }
            }
          }
        });
      }
    } catch (e) {
      print(e);
    }
    return hashtags;
  }

  void openSettings() {
    setState(() {
      options = !options;
    });
  }

  void removable() {
    setState(() {
      removePost = !removePost;
    });
  }

  void edit(int index) {
    setState(() {
      editable = !editable;
      editableIndex = index;
      contentController.text = content[index];
    });
  }

  void openImagePicker() async {
    await pickImages();
  }

  //cập nhật thông tin bài viết
  void updatePost(int index) async {
    setState(() {
      if (contentController.text.isNotEmpty) {
        content[index] = contentController.text;
        postImages[index] = postImages[index];
        editable = false;
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Vui lòng thay đổi nội dung.',
              ),
            ),
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  //cập nhật hình ảnh vào bài viết (phải nhấn lần 2 mới xuất hiện hình đã add lần thứ nhất)
  void updatePostImage(int index) {
    setState(() {
      openImagePicker();
      postImages[index].addAll(selectedImages);
      selectedImages.clear();
    });
  }

  //xóa bài viết
  void deletePost(int index) {
    setState(() {
      content.removeAt(index);
      postImages.removeAt(index);
      Navigator.pop(context);
    });
  }

  //Xóa hình ảnh đã thêm
  void removeImages(int index, int index1) {
    setState(() {
      postImages[index].removeAt(index1);
    });
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: screenWidth,
                height: screenHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/dashboardBG.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: content.isEmpty
                    ? EmptyLogo(screenHeight: screenHeight)
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(30, 100, 30, 30),
                        child: FirebaseAnimatedList(
                            defaultChild: const Text("loading"),
                            query: ref,
                            itemBuilder: (context, snapshot, animation, index) {
                              words = snapshot
                                  .child('content')
                                  .value
                                  .toString()
                                  .split(' ');
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 15),
                                child: Container(
                                    width: screenWidth * 0.5,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.blue[800]!
                                                  .withOpacity(0.8),
                                              offset: const Offset(0, 2),
                                              blurRadius: 4,
                                              spreadRadius: 1)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 10, 0, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .child('username')
                                                        .value
                                                        .toString(),
                                                    style: userName,
                                                  ),
                                                  RemoveOrUpdate(
                                                    screenHeight: screenHeight,
                                                    removePost: removePost,
                                                    function1: () {
                                                      deletePost(index);
                                                    },
                                                    function2: () {
                                                      edit(index);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25),
                                              child: Text(
                                                DateFormat('HH:mm | dd-MM-yyyy')
                                                    .format(DateTime.parse(
                                                        snapshot
                                                            .child('date')
                                                            .value
                                                            .toString())),
                                                style: postDates,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                              child: editable &&
                                                      index == editableIndex &&
                                                      removePost == false
                                                  ? PostUpdateTF(
                                                      contentController:
                                                          contentController,
                                                      content: content,
                                                      function: (String text) {
                                                        setState(() {
                                                          contentController
                                                              .text = text;
                                                        });
                                                      },
                                                      index: index)
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Text.rich(
                                                        TextSpan(
                                                          children: words
                                                              .map(
                                                                (word) => TextSpan(
                                                                    text:
                                                                        '$word ',
                                                                    style: word.startsWith(
                                                                            '#')
                                                                        ? hashtagsText
                                                                        : contentText),
                                                              )
                                                              .toList(),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: editable &&
                                                editableIndex == index &&
                                                removePost == false,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                UpdatePostImg(function: () {
                                                  updatePostImage(index);
                                                }),
                                                UpdatePost(
                                                    screenHeight: screenHeight,
                                                    function: () {
                                                      updatePost(index);
                                                    })
                                              ],
                                            ),
                                          ),
                                          // if (postImages[index].isNotEmpty)
                                          //   SizedBox(
                                          //     width: screenWidth * 0.7,
                                          //     child: MasonryGridView.builder(
                                          //       physics:
                                          //           const NeverScrollableScrollPhysics(),
                                          //       shrinkWrap: true,
                                          //       gridDelegate:
                                          //           SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                          //         crossAxisCount:
                                          //             postImages[index].length %
                                          //                         4 ==
                                          //                     0
                                          //                 ? 3
                                          //                 : 2,
                                          //       ),
                                          //       itemCount: 5,
                                          //       itemBuilder: (context, index1) {
                                          //         if (postImages[index].length >
                                          //                 maxImages &&
                                          //             index1 == maxImages - 1) {
                                          //           int remainCount =
                                          //               postImages[index]
                                          //                       .length -
                                          //                   maxImages;
                                          //           return Padding(
                                          //             padding:
                                          //                 const EdgeInsets.all(
                                          //                     2),
                                          //             child: GestureDetector(
                                          //               child: Stack(
                                          //                 children: [
                                          //                   ClipRRect(
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 10),
                                          //                     child: Image.file(
                                          //                       postImages[
                                          //                               index]
                                          //                           [index1],
                                          //                       fit: BoxFit
                                          //                           .cover,
                                          //                     ),
                                          //                   ),
                                          //                   Positioned.fill(
                                          //                     child: Container(
                                          //                       alignment:
                                          //                           Alignment
                                          //                               .center,
                                          //                       decoration:
                                          //                           BoxDecoration(
                                          //                         color: Colors
                                          //                             .black
                                          //                             .withOpacity(
                                          //                                 0.6),
                                          //                         borderRadius:
                                          //                             BorderRadius
                                          //                                 .circular(
                                          //                                     10),
                                          //                       ),
                                          //                       child: Center(
                                          //                         child: Text(
                                          //                           '+$remainCount',
                                          //                           style:
                                          //                               const TextStyle(
                                          //                             color: Colors
                                          //                                 .white,
                                          //                             fontSize:
                                          //                                 30,
                                          //                             fontWeight:
                                          //                                 FontWeight
                                          //                                     .bold,
                                          //                           ),
                                          //                         ),
                                          //                       ),
                                          //                     ),
                                          //                   )
                                          //                 ],
                                          //               ),
                                          //               onTap: () {
                                          //                 _currentIndex = index;
                                          //                 Provider.of<DataModel>(
                                          //                         context,
                                          //                         listen: false)
                                          //                     .addUserIndex(
                                          //                         index);
                                          //                 Provider.of<DataModel>(
                                          //                         context,
                                          //                         listen: false)
                                          //                     .sliderIndex(
                                          //                         _currentIndex);
                                          //                 Provider.of<DataModel>(
                                          //                         context,
                                          //                         listen: false)
                                          //                     .sliderScreenImages(
                                          //                         postImages[
                                          //                             index]);
                                          //                 Navigator.push(
                                          //                     context,
                                          //                     MaterialPageRoute(
                                          //                         builder:
                                          //                             (context) =>
                                          //                                 const SliderScreen()));
                                          //               },
                                          //             ),
                                          //           );
                                          //         } else {
                                          //           return Padding(
                                          //             padding:
                                          //                 const EdgeInsets.all(
                                          //                     2),
                                          //             child: GestureDetector(
                                          //               onTap: () {
                                          //                 _currentIndex = index;
                                          //                 Provider.of<DataModel>(
                                          //                         context,
                                          //                         listen: false)
                                          //                     .sliderIndex(
                                          //                         _currentIndex);
                                          //                 Provider.of<DataModel>(
                                          //                         context,
                                          //                         listen: false)
                                          //                     .sliderScreenImages(
                                          //                         postImages[
                                          //                             index]);
                                          //                 Navigator.push(
                                          //                     context,
                                          //                     MaterialPageRoute(
                                          //                         builder:
                                          //                             (context) =>
                                          //                                 const SliderScreen()));
                                          //               },
                                          //               child: ClipRRect(
                                          //                 borderRadius:
                                          //                     BorderRadius
                                          //                         .circular(10),
                                          //                 child: Image.file(
                                          //                   postImages[index]
                                          //                       [index1],
                                          //                   fit: BoxFit.cover,
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //           );
                                          //         }
                                          //       },
                                          //     ),
                                          //   )
                                          // else
                                          //   const SizedBox(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons
                                                      .favorite_border_outlined,
                                                  color: Colors.blue,
                                                ),
                                                Container(
                                                  width: screenWidth * 0.25,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border.symmetric(
                                                      vertical: BorderSide(
                                                        color: Colors.blue,
                                                        width: 1,
                                                        style:
                                                            BorderStyle.solid,
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.message,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.arrow_outward,
                                                  color: Colors.blue,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            })),
              ),
            ),
            Visibility(
              visible: options,
              child: OptionBTs(
                screenWidth: screenHeight,
                function: () {
                  removable();
                },
              ),
            ),
            Options(
                screenWidth: screenWidth,
                function: () {
                  openSettings();
                }),
            //search
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Column(
                  children: [
                    Search(
                        function: filterStrings,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth),
                    Visibility(
                      visible: search,
                      child: HashtagList(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          hashtags: hashtags),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
