import 'package:sixam_mart/common/widgets/coustom_toast.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String? message,
    {bool isError = true, bool getXSnackBar = false}) {
  if (message != null && message.isNotEmpty) {
    if (getXSnackBar) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        message: message,
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
      ));
    } else {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.transparent,
        messageText: CustomToast(text: message, isError: isError),
        snackPosition: SnackPosition.TOP,
        maxWidth: Get.width * 0.8,
        duration: const Duration(seconds: 2),
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
      ));
    }
  }
}
