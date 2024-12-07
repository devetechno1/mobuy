import 'package:sixam_mart/common/widgets/no_data_screen.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/images.dart';

import '../../dashboard/screens/dashboard_screen.dart';

class FavItemViewWidget extends StatelessWidget {
  final bool isStore;
  final bool isSearch;
  const FavItemViewWidget(
      {super.key, required this.isStore, this.isSearch = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<FavouriteController>(builder: (favouriteController) {
        return RefreshIndicator(
          onRefresh: () async {
            await favouriteController.getFavouriteList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FooterView(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: ResponsiveHelper.isDesktop(context) ? 0 : 80.0),
                  child: ItemsView(
                    image: Images.onlineShopping,
                    description: "tap_heart_saving_your_favorite_items".tr,
                    isStore: isStore,
                    items: favouriteController.wishItemList,
                    stores: favouriteController.wishStoreList,
                    noDataText: 'no_wish_data_found'.tr,
                    isFeatured: true,
                    button: goToHomeButtonData(context),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

ButtonDataEntity goToHomeButtonData(BuildContext context) => ButtonDataEntity(
  text: "explore_categories".tr,
  backgroundColor: Theme.of(context).primaryColor,
  textColor: Colors.black,
  onTap: () => Get.offAll(() => const DashboardScreen(pageIndex: 0)),
);
