import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../cart/controllers/cart_controller.dart';

class BottomNavItemWidget extends StatelessWidget {
  final String selectedIcon;
  final String unSelectedIcon;
  final String title;
  final Function? onTap;
  final bool isSelected;
  final bool showBadge;
  const BottomNavItemWidget(
      {super.key,
      this.onTap,
      this.isSelected = false,
      required this.title,
      required this.selectedIcon,
      this.showBadge = false,
      required this.unSelectedIcon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                isSelected ? selectedIcon : unSelectedIcon,
                height: 25,
                width: 25,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodyMedium!.color!,
              ),
              if(showBadge)
                Positioned(
                  top: -5, right: -5,
                  child: GetBuilder<CartController>(
                    builder: (cartController) {
                      if(cartController.cartList.isEmpty) return const SizedBox();
                      return Container(
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                        child: Text(
                          cartController.cartList.length.toString(),
                          style: robotoMedium.copyWith(color: Colors.black, fontSize: 8),
                        ),
                      );
                    }
                  ),
                )
            ],
          ),
          SizedBox(
              height: isSelected
                  ? Dimensions.paddingSizeExtraSmall
                  : Dimensions.paddingSizeSmall),
          Text(
            title,
            style: robotoRegular.copyWith(
                color: Theme.of(context).textTheme.bodyMedium!.color!,
                fontSize: 12),
          ),
        ]),
      ),
    );
  }
}
