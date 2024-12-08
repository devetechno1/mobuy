import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';

class ItemImageViewWidget extends StatelessWidget {
  final Item? item;
  final bool isCampaign;
  ItemImageViewWidget({super.key, required this.item, this.isCampaign = false});

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {

    List<String?> imageList = [];
    List<String?> imageListForCampaign = [];

    if(isCampaign){
      imageListForCampaign.add(item!.imageFullUrl);
    }else{
      imageList.add(item!.imageFullUrl);
      imageList.addAll(item!.imagesFullUrl!);
    }

    return GetBuilder<ItemController>(builder: (itemController) {
    
      return Column(mainAxisSize: MainAxisSize.min, children: [
    
          InkWell(
            onTap: isCampaign ? null : () {
              if(!isCampaign) {
                Navigator.of(context).pushNamed(RouteHelper.getItemImagesRoute(item!,itemController.imageSliderIndex), arguments: ItemImageViewWidget(item: item));
              }
            },
            child: Stack(children: [
              AspectRatio(
                aspectRatio: 200/128,
                child: SizedBox(
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: isCampaign ? imageListForCampaign.length : imageList.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: AspectRatio(
                          aspectRatio: 200/128,
                          child: CustomImage(
                            image: '${isCampaign ? imageListForCampaign[index] : imageList[index]}',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      itemController.setImageSliderIndex(index);
                    },
                  ),
                ),
              ),
              Positioned(
                left: 0, right: 0, bottom: MediaQuery.sizeOf(context).width * 0.12,
                child: Align(
                  child: Container(
                    // margin: const EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _indicators(context, itemController, isCampaign ? imageListForCampaign : imageList),
                    ),
                  ),
                ),
              ),
              if(item?.id != null)
                PositionedDirectional(
                  top: Dimensions.paddingSizeDefault,
                  end: Dimensions.paddingSizeDefault,
                  child: InkWell(
                    onTap: () => Share.share("${AppConstants.productLink}/${item!.id}",subject: AppConstants.appName),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: const Icon(Icons.share, size: 24,color: Colors.black54),
                    ),
                  ) ,
                ),
    
            ]),
          ),
    
      ]);
    });
  }

  List<Widget> _indicators(BuildContext context, ItemController itemController, List<String?> imageList) {
    List<Widget> indicators = [];
    for (int index = 0; index < imageList.length; index++) {
      indicators.add(TabPageSelectorIndicator(
        backgroundColor: index == itemController.imageSliderIndex ? Theme.of(context).primaryColor : Colors.white,
        borderColor: Colors.white,
        size: 10,
      ));
    }
    return indicators;
  }

}
