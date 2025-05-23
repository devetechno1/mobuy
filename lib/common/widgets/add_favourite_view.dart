import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

class AddFavouriteView extends StatelessWidget {
  final Item item;
  final double? top, right;
  final double? left;
  const AddFavouriteView({super.key, required this.item, this.top = 15, this.right = 15, this.left});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top, right: right, left: left,
      child: GetBuilder<FavouriteController>(builder: (favouriteController) {
        bool isWished = favouriteController.wishItemIdList.contains(item.id);
        return InkWell(
          onTap: () {
            if(AuthHelper.isLoggedIn()) {
              isWished ? favouriteController.removeFromFavouriteList(item.id, false)
                  : favouriteController.addToFavouriteList(item, null, false);
            }else {
              showCustomSnackBar('you_are_not_logged_in'.tr);
            }
          },
          borderRadius: BorderRadius.circular(100),
          child: Container(
            margin: const EdgeInsets.all(1),
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(spreadRadius: 0.1),
              ],
              shape: BoxShape.circle,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: isWished? Icon(Icons.favorite, color: Theme.of(context).primaryColor, size: 20): const Icon(Icons.favorite_border, size: 20),
          ),
        );
      }),
    );
  }
}
