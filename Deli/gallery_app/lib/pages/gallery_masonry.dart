import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_app/components/indicators.dart';

class GalleyMasonry extends StatefulWidget {
  const GalleyMasonry({super.key});

  @override
  State<GalleyMasonry> createState() => _GalleyMasonryState();
}

class _GalleyMasonryState extends State<GalleyMasonry> {
  List<Image> urls = [
    Image.network(
        'https://images.wallpapersden.com/image/download/beautiful-mountain-scenery_a2tnZWWUmZqaraWkpJRqZWWtamVl.jpg'),
    Image.network(
        'https://www.bing.com/th/id/OGC.3848ab6fdd544b0b251b51d3f3cf2a47?pid=1.7&rurl=https%3a%2f%2fmedia.giphy.com%2fmedia%2fiTD9NcQhGj6co%2fgiphy.gif&ehk=AUit0XO9CHimeMvWXhevWw4P4iRnlwbEz3qlykSs08s%3d'),
    Image.network(
        'https://wallpapers.com/images/hd/natural-scenery-pictures-500-x-1000-xjhdk19irwa39ent.jpg'),
    Image.network(
        'https://i.pinimg.com/564x/8d/54/2d/8d542db2bf43fd638bfa96006248b7fd.jpg'),
    Image.network(
        'https://i.pinimg.com/474x/8b/a7/84/8ba78428cc8cf6c347265499ca347aa0.jpg'),
    Image.network('https://jooinn.com/images/beautiful-scenery-7.jpg'),
    Image.network(
        'https://th.bing.com/th/id/OIP.skUqJKmycC-hjQUedA_dcgHaHa?pid=ImgDet&rs=1'),
    Image.network(
        'https://th.bing.com/th/id/OIP.VaiwDiYUk4Zy_QGX90a2ygHaHa?pid=ImgDet&rs=1'),
    Image.network(
        'https://th.bing.com/th/id/R.4d6a8f5e2c637f38def7520a4211afde?rik=g95XwAD0RGAyZA&pid=ImgRaw&r=0'),
    Image.network(
        'https://th.bing.com/th/id/OIP.e74k2ORNvfeaL-F2DCpoUAHaF3?pid=ImgDet&rs=1'),
  ];

  late int _currentIndex = 0;
  final int maxImages = 5;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          child: Stack(
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Gallery',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Better to see something once',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'than to hear about it a thousand times.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    child: MasonryGridView.builder(
                      shrinkWrap: true,
                      itemCount: maxImages,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        if (urls.length > maxImages && index == maxImages - 1) {
                          int remainCount = urls.length - maxImages + 1;
                          return Padding(
                            padding: const EdgeInsets.all(2),
                            child: GestureDetector(
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: urls[index],
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+$remainCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  _currentIndex = index;
                                });
                                slider(
                                    context, screenWidth, screenHeight, index);
                              },
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(2),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentIndex = index;
                                });
                                slider(
                                    context, screenWidth, screenHeight, index);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: urls[index],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> slider(BuildContext context, double screenWidth,
      double screenHeight, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStatedialog) {
            return Center(
              child: Container(
                color: Colors.transparent,
                width: screenWidth,
                height: screenHeight * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        initialPage: index,
                        onPageChanged: (index, reason) {
                          setStatedialog(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      items: urls.map(
                        (image) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: screenWidth * 0.5,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: image,
                                ),
                              );
                            },
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(height: 20),
                    SlideIndicators(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      currentIndex: _currentIndex,
                      itemCount: urls.length,
                      activeColor: Colors.amber,
                      inactiveColor: Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
