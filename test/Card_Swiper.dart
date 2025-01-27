import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class MySwiperPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String a = "assets/a.png";
    String b = "assets/b.png";
    List<String> c = [a, b];
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Swiper Example'),
      ),
      body: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(c[index]);
        },
        itemCount: 2,
        viewportFraction: 0.8,
        scale: 0.9,
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: MySwiperPage()));
