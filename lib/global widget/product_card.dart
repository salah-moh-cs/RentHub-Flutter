import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:praduation_project/core/theme/text_theme.dart';
import 'package:praduation_project/core/utils/helpers/custom_dialog.dart';

import '../data/model/product_model.dart';
import '../data/services/chat_db.dart';
import '../data/model/user_account_model.dart';
import '../modules/auth/controller/auth_controller.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final bool isFavorit;
  final bool enableSlidable;
  const ProductCard({
    super.key,
    required this.product,
    this.isFavorit = false,
    this.enableSlidable = true,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final any = AuthController.instance.isUserSignedInAnonymously();

  late bool isFavorit;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    isFavorit = widget.isFavorit;
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRented = widget.product.isRent == true;
    final isNotAccept = widget.product.isacceptadmin == false;

    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: () {
        Get.to(
          () => ProductView(productuuid: widget.product.productUid.toString()),
          binding: ProductBinding(),
        );
      },
      child: Slidable(
        enabled: any ||
                (widget.product.userId == UserAccount.info!.uid &&
                    !UserAccount.info!.isAdmin)
            ? false
            : widget.enableSlidable,
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            UserAccount.info!.isAdmin
                ? SlidableAction(
                    onPressed: (_) {
                      CustomDialog.showYesNoDialog(
                          noButtonText: "no".tr,
                          yesButtonText: "yes".tr,
                          title: "delete".tr,
                          icons: Icons.delete,
                          content: "deletewarning".tr,
                          yesButtonColor: Colors.red,
                          onYesPressed: () {
                            widget.product.delete();
                            setState(() {});
                          });
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    icon: Icons.delete,
                    label: 'delete'.tr,
                  )
                : SlidableAction(
                    onPressed: (_) {
                      isFavorit = !isFavorit;
                      final productuuid = widget.product.productUid!;
                      if (isFavorit == true) {
                        UserAccount.info!.addToFavorites(productuuid);
                      } else {
                        UserAccount.info!.removeFromFavorites(productuuid);
                      }
                    },
                    backgroundColor: Get.theme.colorScheme.background,
                    foregroundColor: isFavorit
                        ? Colors.red
                        : Get.theme.colorScheme.onBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    icon: isFavorit ? Icons.favorite : Icons.favorite_border,
                    label: 'favorites'.tr,
                  ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: UserAccount.info!.isAdmin
              ? [
                  SlidableAction(
                    onPressed: (_) async {
                      if (widget.product.isacceptadmin) {
                        await widget.product.reject;
                      } else {
                        await widget.product.accept;
                      }
                    },
                    backgroundColor: widget.product.isacceptadmin
                        ? Colors.red
                        : const Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: widget.product.isacceptadmin
                        ? Icons.close
                        : Icons.check,
                    label: widget.product.isacceptadmin
                        ? 'reject'.tr
                        : 'accept'.tr,
                  ),
                  SlidableAction(
                    onPressed: (_) {
                      CustomDialog.showRatingDialog(product: widget.product);
                    },
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    icon: Icons.star,
                    label: 'ratethisproduct'.tr,
                  ),
                ]
              : [
                  SlidableAction(
                    onPressed: (_) async {
                      await ChatDatabase.chatChecker(
                          uuid: widget.product.userId!);
                    },
                    backgroundColor: const Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.message,
                    label: 'message'.tr,
                  ),
                  SlidableAction(
                    onPressed: (_) {
                      CustomDialog.showRatingDialog(product: widget.product);
                    },
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    icon: Icons.star,
                    label: 'ratethisproduct'.tr,
                  ),
                ],
        ),
        child: Card(
          child: isRented || isNotAccept
              ? ClipPath(
                  child: Banner(
                    message: isNotAccept ? "pending".tr : "rented".tr,
                    color: isNotAccept ? Colors.yellow : Colors.red,
                    textStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    location: isNotAccept
                        ? BannerLocation.topEnd
                        : BannerLocation.topStart,
                    textDirection: isNotAccept
                        ? TextDirection.rtl
                        : TextDirection
                            .rtl, // Set textDirection to TextDirection.rtl for "under review" banner
                    child: _body(),
                  ),
                )
              : _body(),
        ),
      ),
    );
  }

  Widget _body() {
    final isNotAccept = widget.product.isacceptadmin == false;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: isNotAccept
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.yellow,
              ),
            )
          : widget.product.isRent
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.red,
                  ),
                )
              : null,
      child: Row(
        children: [
          SizedBox(
            width: Get.width * .25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: widget.product.imagesUrl.first,
                height: Get.height * .1,
                errorWidget: (context, url, error) => const SizedBox(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.product.productName,
                        style: AppStyles.headLine6.copyWith(
                          color: Get.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Text(
                      "${widget.product.price} ${"jd".tr}/${widget.product.period.tr}",
                      style: AppStyles.headLine6.copyWith(
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                        ),
                        Text(widget.product.city.tr),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        Text(widget.product.getRates.toStringAsFixed(1)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: Get.height * .05,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics:
                              const BouncingScrollPhysics(), // Add BouncingScrollPhysics for overscroll effect
                          shrinkWrap: true,
                          // direction: Axis.vertical,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.category,
                                  size: 14,
                                ),
                                Text(widget.product.category.tr),
                              ],
                            ),
                            const SizedBox(width: 8.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.apartment,
                                  size: 14,
                                ),
                                Text(widget.product.brandName),
                              ],
                            ),
                            const SizedBox(width: 8.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.class_,
                                  size: 14,
                                ),
                                Text(widget.product.subCategory.tr),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                    widget.product.isRent
                        ? '${'stateOfTheProductAvailableIn'.tr} ${widget.product.getTimeDifference(0)}'
                        : 'available'.tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: widget.product.isRent
                          ? Colors.red
                          : Get.theme.colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
