import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/features/search/widgets/custom_check_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/category_controller.dart';

class FilterCatWidget extends StatelessWidget {
  final double? maxValue;
  final bool isStore;
  const FilterCatWidget({super.key, required this.maxValue, required this.isStore});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: GetBuilder<CategoryController>(builder: (controller) {
          return SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Icon(Icons.close, color: Theme.of(context).disabledColor),
                  ),
                ),
                Text('filter'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                CustomButton(
                  onPressed: () {
                    if(isStore) {
                      controller.resetStoreFilter();
                    } else {
                      controller.resetFilter();
                    }
                  },
                  buttonText: 'reset'.tr, transparent: true, width: 65,
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('sort_by'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              GridView.builder(
                itemCount: controller.sortList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 3 : 2,
                  childAspectRatio: 3, crossAxisSpacing: 10, mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if(isStore) {
                        controller.setStoreSortIndex(index);
                      } else {
                        controller.setSortIndex(index);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: (isStore ? controller.storeSortIndex == index : controller.sortIndex == index) ? Colors.transparent
                            : Theme.of(context).disabledColor),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        color: (isStore ? controller.storeSortIndex == index : controller.sortIndex == index) ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor.withOpacity(0.1),
                      ),
                      child: Text(
                        controller.sortList[index],
                        textAlign: TextAlign.center,
                        style: robotoMedium.copyWith(
                          color: (isStore ? controller.storeSortIndex == index : controller.sortIndex == index) ? Colors.white : Theme.of(context).hintColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('filter_by'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              (Get.find<SplashController>().configModel!.toggleVegNonVeg!
              && Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg!) ? CustomCheckBoxWidget(
                title: 'veg'.tr,
                value: isStore ? controller.storeVeg : controller.veg,
                onClick: () => isStore ? controller.toggleStoreVeg() : controller.toggleVeg(),
              ) : const SizedBox(),

              (Get.find<SplashController>().configModel!.toggleVegNonVeg!
              && Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg!) ? CustomCheckBoxWidget(
                title: 'non_veg'.tr,
                value: isStore ? controller.storeNonVeg : controller.nonVeg,
                onClick: () => isStore ? controller.toggleStoreNonVeg() : controller.toggleNonVeg(),
              ) : const SizedBox(),

              CustomCheckBoxWidget(
                title: isStore ? Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                    ? 'currently_opened_restaurants'.tr : 'currently_opened_stores'.tr : 'currently_available_items'.tr,
                value: isStore ? controller.isAvailableStore : controller.isAvailableItems,
                onClick: () {
                  if(isStore) {
                    controller.toggleAvailableStore();
                  } else {
                    controller.toggleAvailableItems();
                  }
                },
              ),

              CustomCheckBoxWidget(
                title: isStore ? Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                    ? 'discounted_restaurants'.tr : 'discounted_stores'.tr : 'discounted_items'.tr,
                value: isStore ? controller.isDiscountedStore : controller.isDiscountedItems,
                onClick: () {
                  if(isStore) {
                    controller.toggleDiscountedStore();
                  } else {
                    controller.toggleDiscountedItems();
                  }
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              isStore ? const SizedBox() : Column(children: [
                Text('price'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                RangeSlider(
                  values: RangeValues(controller.lowerValue, controller.upperValue),
                  max: maxValue!.toInt().toDouble(),
                  min: 0,
                  divisions: maxValue!.toInt(),
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  labels: RangeLabels(controller.lowerValue.toString(), controller.upperValue.toString()),
                  onChanged: (RangeValues rangeValues) {
                    controller.setLowerAndUpperValue(rangeValues.start, rangeValues.end);
                  },
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ]),

              Text('rating'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

              Container(
                height: 30, alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => isStore ? controller.setStoreRating(index + 1) : controller.setRating(index + 1),
                      child: Icon(
                        (isStore ? controller.storeRating < (index + 1) : controller.rating < (index + 1)) ? Icons.star_border : Icons.star,
                        size: 30,
                        color: (isStore ? controller.storeRating < (index + 1) : controller.rating < (index + 1)) ? Theme.of(context).disabledColor
                            : Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              CustomButton(
                buttonText: 'apply_filters'.tr,
                onPressed: () {
                  if(isStore) {
                    controller.sortStoreSearchList();
                  }else {
                    controller.sortItemSearchList();
                  }
                  Get.back();
                },
              ),

            ]),
          );
        }),
      ),
    );
  }
}
