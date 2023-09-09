import 'package:flutter/material.dart';

import 'custom_advertisements_card.dart';
import 'custom_category_listview.dart';
import 'custom_product_listview.dart';
import 'custom_search_widget.dart';

// ignore: must_be_immutable
class FirstBody extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const FirstBody({Key? key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          CustomSearchWidget(),
          SizedBox(height: 20),
          CarouselContainer(imageUrls: [
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkBpXijVUC9uaLqxV7Ps8CBbnf--09zyqt9Q&usqp=CAU',
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLPRPv1Ko9oqB7h_IvOWcRVP5AGaotcoROFg&usqp=CAU',
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKpTZcDIHJw977lAspfwFlhEGWbrpIb6_eAg&usqp=CAU'
          ], imageLinks: [
            "https://www.google.com/",
            "https://www.google.com/",
            "https://www.google.com/"
          ]),
          SizedBox(height: 20),
          CustomCategoryListview(),
          SizedBox(height: 20),
          CustomProductListView(maxLenght: 8),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
