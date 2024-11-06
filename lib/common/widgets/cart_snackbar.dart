import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';

void showCartSnackBar() {
  bool isPressed = false;
  Get.showSnackbar(GetSnackBar(
    backgroundColor: Colors.green,
    message: 'item_added_to_cart'.tr,
    snackPosition: SnackPosition.TOP,
    maxWidth: Get.width * 0.8,
    duration: const Duration(seconds: 3),
    snackStyle: SnackStyle.FLOATING,
    margin: const EdgeInsets.only(
      top: 100,
      left: Dimensions.paddingSizeSmall,
      right: Dimensions.paddingSizeSmall,
      bottom: 100,
    ),
    borderRadius: Dimensions.radiusSmall,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    mainButton: SnackBarAction(
      label: 'view_cart'.tr,
      onPressed: () {
        if (isPressed) return;
        Get.closeCurrentSnackbar();
        Get.toNamed(RouteHelper.getCartRoute());
        isPressed = true;
      },
      textColor: Colors.white,
    ),
  ));
}
