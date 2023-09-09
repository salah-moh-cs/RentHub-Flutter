import 'package:flutter/material.dart';

import '../../../global widget/user_and_product_stream_builder.dart';

class FavoriteBody extends StatelessWidget {
  const FavoriteBody({super.key});

  @override
  Widget build(BuildContext context) {
    return UserAndProductStreamBuilder(showFavouritesOnly: true);
  }
}
