import 'package:get/get.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function? onTap;
  final String? image;
  const TitleWidget({super.key, required this.title, this.onTap, this.image});

  @override
  Widget build(BuildContext context) {

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Text(title, style: robotoBold.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeLarge : Dimensions.fontSizeLarge)),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        image != null ? Image.asset(image!, height: 20, width: 20) : const SizedBox(),
        ],
      ),
      (onTap != null) ? InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
          color: Colors.black,
          alignment: Alignment.center,
          child: Text(
            'see_all'.tr,
            textAlign: TextAlign.center,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white),
          ),
        ),
      ) : const SizedBox(),
    ]);
  }
}
