import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/cart_widget.dart';
import 'package:sixam_mart/common/widgets/item_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/veg_filter_widget.dart';
import 'package:sixam_mart/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/custom_image.dart';
import '../../../util/app_constants.dart';

import '../../brands/domain/models/brands_model.dart';
import '../widgets/filter_cat_widget.dart';


class CategoryItemScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  const CategoryItemScreen({super.key, required this.categoryID, required this.categoryName});

  @override
  CategoryItemScreenState createState() => CategoryItemScreenState();
}

class CategoryItemScreenState extends State<CategoryItemScreen> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController storeScrollController = ScrollController();
  TabController? _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<BrandModel> brandsList = [];
  int index_category = -1;
  int index_brand = -1;
  int pageIndex = 0;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    storeScrollController.dispose();
    _tabController?.dispose();
  }
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    getBrandByCategoryList(widget.categoryID);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryItemList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryItemList(
            Get.find<CategoryController>().subCategoryIndex == -1 ? widget.categoryID
                : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
            Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,'${ brandsList.isEmpty ||  index_brand == -1 ? "" :brandsList[index_brand].id}'
          );
        }
      }
    });
    storeScrollController.addListener(() {
      if (storeScrollController.position.pixels == storeScrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryStoreList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().restPageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryStoreList(
            Get.find<CategoryController>().subCategoryIndex == -1 ? widget.categoryID
                : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
            Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
          );
        }
      }
    });
  }

  getBrandByCategoryList(String? categoryID) async {
    final ApiClient api = Get.find<ApiClient>();
    final  response = await api.getData("${AppConstants.brandCategoryUri}/$categoryID");
    if (response.statusCode == 200) {
      if(response.body['brands'] == 0){
        brandsList = [];
      }else{
        setState(() {
          brandsList = [];
          response.body['brands'].forEach((brand) => brandsList.add(BrandModel.fromJson(brand)));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Item>? item;
      List<Store>? stores;
      if(catController.isSearching ? catController.searchItemList != null : catController.categoryItemList != null) {
        item = [];
        if (catController.isSearching) {
          item.addAll(catController.searchItemList!);
        } else {
          item.addAll(catController.categoryItemList!);
        }
      }
      if(catController.isSearching ? catController.searchStoreList != null : catController.categoryStoreList != null) {
        stores = [];
        if (catController.isSearching) {
          stores.addAll(catController.searchStoreList!);
        } else {
          stores.addAll(catController.categoryStoreList!);
        }
      }

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop,_)  => backMethod(catController),
        child: Scaffold(
          appBar: (ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : AppBar(
            title: catController.isSearching ? TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'search_'.tr,
                border: InputBorder.none,
              ),
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
              onSubmitted: (String query) {
                catController.searchData(
                  query, catController.subCategoryIndex == -1 ? widget.categoryID
                    : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                  catController.type,
                );
              }
            ) : Text(widget.categoryName, style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () => backMethod(catController),
            ),
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => catController.toggleSearch(),
                icon: Icon(
                  catController.isSearching ? Icons.close_sharp : Icons.search,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              IconButton(
                onPressed: () {
                  if(!catController.isSearching) catController.toggleSearch();
                  List<double?> prices = [];
                  if(!catController.isStore) {
                    for (var product in catController.categoryItemList!) {
                      prices.add(product.price);
                    }
                    prices.sort();
                  }
                  double? maxValue = prices.isNotEmpty ? prices[prices.length-1] : 1000;
                  Get.dialog(FilterCatWidget(maxValue: maxValue, isStore:catController.isStore));
                },
                icon: const Icon(Icons.filter_list),
              ),
              IconButton(
                onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                icon: CartWidget(color: Theme.of(context).textTheme.bodyLarge!.color, size: 25),
              ),

              VegFilterWidget(type: catController.type, fromAppBar: true, onSelected: (String type) {
                if(catController.isSearching) {
                  catController.searchData(
                    catController.subCategoryIndex == -1 ? widget.categoryID
                        : catController.subCategoryList![catController.subCategoryIndex].id.toString(), '1', type,
                  );
                }else {
                  if(catController.isStore) {
                    catController.getCategoryStoreList(
                      catController.subCategoryIndex == -1 ? widget.categoryID
                          : catController.subCategoryList![catController.subCategoryIndex].id.toString(), 1, type, true,
                    );
                  }else {
                    catController.getCategoryItemList(
                      catController.subCategoryIndex == -1 ? widget.categoryID
                          : catController.subCategoryList![catController.subCategoryIndex].id.toString(), 1, type, true,""
                    );
                  }
                }
              }),
            ],
          )),
          endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
          body: Center(child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(children: [

               Visibility(
                visible: (catController.subCategoryList != null && catController.subCategoryList!.isNotEmpty && !catController.isSearching && AppConstants.subcatimg && pageIndex == 0 ),
                maintainState: true,
                 child: Center(child: Container(
                 height: 120,
                  width: Dimensions.webMaxWidth,
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                  child:
                  ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(width: 15),
                      Align(
                        child: InkWell(
                          onTap: index_category == -1 ? null : (){
                            index_category = -1;
                            catController.setSubCategoryIndex(index_category, widget.categoryID,"");
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(index_category == -1 ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                  border: Border.all(color: index_category == -1 ? Theme.of(context).primaryColor : const Color(0xFF000000)),
                                  borderRadius: const BorderRadius.all(Radius.circular(50))
                              ),
                              width: 80, height: 80,child:  Text( "all".tr,textAlign:TextAlign.center,style: index_category == -1 ? TextStyle(color: Theme.of(context).primaryColor,fontSize: 12 ):const TextStyle(fontSize: 10),)),
                        ),
                      ),
                      ...List.generate(
                        catController.subCategoryList?.length ?? 0,
                        (int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                index_category = index;
                                index_brand = -1;
                                pageIndex = 1;
                              });
                      
                              // if(index == 0){
                              //   brand_category_ids = [];
                              // }
                              print("sub img ========> ${index}");
                              var subcat = catController.GetsetSubCategoryIndex(index, widget.categoryID);
                      
                              print("sub cat id ========> ${subcat}");
                             // Get.toNamed(RouteHelper.getBrandsItemScreenCat(454, "سسس","$subcat"));
                               catController.setSubCategoryIndex(index, widget.categoryID,"");
                              getBrandByCategoryList(subcat);
                               print("catController.setSubCategory ====> ${catController.GetsetSubCategoryIndex(index, widget.categoryID)}");
                      
                      
                            },
                            child:  Container(
                              // width: 150,
                              //height: 100,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                              margin: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: index == catController.subCategoryIndex ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                      
                                    // image
                                    catController.subCategoryList![index].name != "all".tr? Expanded(
                                      flex: 3,
                                      child: CustomImage(
                                        image: '${catController.subCategoryList![index].imageFullUrl}',
                                        //height: 90,
                                         //width: 75,
                                        // fit: BoxFit.cover,
                                      ),
                                    ) : Container(
                      
                                        //child: Image.asset('assets/image/all_products.png'),
                                    ),
                      
                                    catController.subCategoryList![index].name != "all".tr? Flexible(
                                      flex: 1,
                                      child: Text(
                                        catController.subCategoryList![index].name!,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: index == catController.subCategoryIndex
                                            ? robotoMedium.copyWith(fontSize: Dimensions.paddingSizeSmall, color: Theme.of(context).primaryColor)
                                            : robotoRegular.copyWith(fontSize: Dimensions.paddingSizeSmall),
                                      ),
                                    ) : const SizedBox(),
                      
                                  ]),
                            )
                          );
                      
                        },
                      ),
                    ],
                  )
                               )),
               ),

              // brand_category_ids.length ==0 ?  Row(
              //   children: [
              //     const SizedBox(width: 8,),
              //     Container(child: const Text("الشركات"),),
              //   ],
              // ): Container(),

              brandsList.isNotEmpty && (pageIndex == 1  || catController.subCategoryList?.isNotEmpty != true)?  Center(child: Container(
                height: 100,
                width: Dimensions.webMaxWidth,
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                child: ListView(
                  key: scaffoldKey,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(width: 15),
                    Align(
                      child: InkWell(
                        onTap: index_brand == -1 ? null : (){
                          catController.setSubCategoryIndex(index_category, widget.categoryID,"");
                          index_brand = -1;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(index_brand == -1 ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                                border: Border.all(color: index_brand == -1 ? Theme.of(context).primaryColor : const Color(0xFF000000)),
                                borderRadius: const BorderRadius.all(Radius.circular(50))
                            ),
                            width: 80, height: 80,child:  Text( "allCompanies".tr,textAlign:TextAlign.center,style: index_brand == -1 ? TextStyle(color: Theme.of(context).primaryColor,fontSize: 12 ):const TextStyle(fontSize: 10),)),
                      ),
                    ),
                    ...List.generate(
                      brandsList.length,
                      (index) {
                        return InkWell(
                          onTap: index_brand == index ? null : () {
                            catController.setSubCategoryIndex(index_category, widget.categoryID,'${brandsList[index].id}');
                            index_brand = index;
                          }
                          ,child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              color: index == index_brand ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                child: CustomImage(
                                  image: '${brandsList[index].imageFullUrl}',
                                  height: 60, width: 60, fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                '${brandsList[index].name}',
                                style: index == index_brand
                                    ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
                                    : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                              ),
                            ]),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )): Container(),
              (catController.subCategoryList != null && !catController.isSearching && AppConstants.subcatimg == false ) ? Center(child: Container(
                height: 40,
                width: Dimensions.webMaxWidth,
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                child: ListView.builder(
                  key: scaffoldKey,
                  scrollDirection: Axis.horizontal,
                  itemCount: catController.subCategoryList!.length,
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => catController.setSubCategoryIndex(index, widget.categoryID,""),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          color: index == catController.subCategoryIndex ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            catController.subCategoryList![index].name!,
                            style: index == catController.subCategoryIndex
                                ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
                                : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                        ]),
                      ),
                    );
                  },
                ),
              )) : const SizedBox(),
              // Center(child: Container(
              //   width: Dimensions.webMaxWidth,
              //   color: Theme.of(context).cardColor,
              //   child: TabBar(
              //     controller: _tabController,
              //     indicatorColor: Theme.of(context).primaryColor,
              //     indicatorWeight: 3,
              //     labelColor: Theme.of(context).primaryColor,
              //     unselectedLabelColor: Theme.of(context).disabledColor,
              //     unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
              //     labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
              //     tabs: [
              //       Tab(text: 'item'.tr),
              //       Tab(text: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
              //           ? 'restaurants'.tr : 'stores'.tr),
              //     ],
              //   ),
              // )),


              Expanded(child: NotificationListener(
                onNotification: (dynamic scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    if((_tabController!.index == 1 && !catController.isStore) || _tabController!.index == 0 && catController.isStore) {
                      catController.setRestaurant(_tabController!.index == 1);
                      if(catController.isSearching) {
                        catController.searchData(
                          catController.searchText, catController.subCategoryIndex == -1 ? widget.categoryID
                            : catController.subCategoryList![catController.subCategoryIndex].id.toString(), catController.type,
                        );
                      }else {
                        if(_tabController!.index == 1) {
                          catController.getCategoryStoreList(
                            catController.subCategoryIndex == -1 ? widget.categoryID
                                : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                            1, catController.type, false,
                          );
                        }else {
                          catController.getCategoryItemList(
                            catController.subCategoryIndex == -1 ? widget.categoryID
                                : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                            1, catController.type, false,'${brandsList[index_brand].id}'
                          );
                        }
                      }
                    }
                  }
                  return false;
                },
                child: SingleChildScrollView(
                      controller: scrollController,
                      child: ItemsView(
                        isStore: false, items: item, stores: null, noDataText: 'no_category_item_found'.tr,
                      ),
                    ),

                // TabBarView(
                //   controller: _tabController,
                //   children: [
                //     SingleChildScrollView(
                //       controller: scrollController,
                //       child: ItemsView(
                //         isStore: false, items: item, stores: null, noDataText: 'no_category_item_found'.tr,
                //       ),
                //     ),
                //     SingleChildScrollView(
                //       controller: storeScrollController,
                //       child: ItemsView(
                //         isStore: true, items: null, stores: stores,
                //         noDataText: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                //             ? 'no_category_restaurant_found'.tr : 'no_category_store_found'.tr,
                //       ),
                //     ),
                //   ],
                // ),
              )) ,

              catController.isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
              )) : const SizedBox(),

            ]),
          )),
        ),
      );
    });
  }

  void backMethod(CategoryController catController) {
    if(catController.isSearching) {
      catController.toggleSearch();
    }else if(pageIndex == 1){
      catController.setSubCategoryIndex(index_category, widget.categoryID,"");
      setState(() {
        pageIndex = 0;
        brandsList = [];
      });
    }
    else  {
      Get.back();
    }
  }
}
