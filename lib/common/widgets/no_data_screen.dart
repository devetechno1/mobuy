import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';

class ButtonDataEntity{
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  const ButtonDataEntity({required this.text, required this.onTap, this.backgroundColor, this.textColor});
}

class NoDataScreen extends StatelessWidget {
  final bool showFooter;
  final String? text;
  final bool fromAddress;
  final String? image;
  final String? description;
  final ButtonDataEntity? button;
  const NoDataScreen({super.key, required this.text, this.showFooter = false, this.fromAddress = false, this.image, this.description, this.button});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FooterView(
        visibility: showFooter,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [

          Center(
            child: Image.asset(
              image ?? (fromAddress ? Images.address : Images.noDataFound),
              width: MediaQuery.of(context).size.height*0.15, height: MediaQuery.of(context).size.height*0.15,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.03),

          Text(
            text!,
            style: robotoMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0275, color: fromAddress ? Theme.of(context).textTheme.bodyMedium!.color : image == null? Theme.of(context).disabledColor : null , fontWeight: image == null? null : FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.03),

          fromAddress ? Text(
            'please_add_your_address_for_your_better_experience'.tr,
            style: robotoMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
            textAlign: TextAlign.center,
          ) : description != null 
          ? Text(
            description!,
            style: robotoMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175),
            textAlign: TextAlign.center,
          ): const SizedBox(),
          SizedBox(height: MediaQuery.of(context).size.height*0.05),

          fromAddress ? InkWell(
            onTap: () => Get.toNamed(RouteHelper.getAddAddressRoute(false, false, 0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_circle_outline_sharp, size: 18.0, color: Theme.of(context).cardColor),
                  Text('add_address'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor)),
                ],
              ),
            ),
          ) : button != null 
          ? InkWell(
            onTap: button!.onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: button!.backgroundColor ?? Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(button!.text, style: robotoMedium.copyWith(color: button!.textColor ?? Theme.of(context).cardColor)),
            ),
          )
          : const SizedBox(),

        ]),
      ),
    );
  }
}
