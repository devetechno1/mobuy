import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:flutter/cupertino.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isNotification;
  final String placeholder;
  final Color? color;
  final bool cancelMemCache;
  const CustomImage({super.key, required this.image,this.color, this.height, this.width, this.fit = BoxFit.cover, this.isNotification = false, this.placeholder = '', this.cancelMemCache = false});

  @override
  Widget build(BuildContext context) {
    final double devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    return LayoutBuilder(
      builder: (context, constrainedBox) {
        int? memCacheWidth = (constrainedBox.minWidth * devicePixelRatio).toInt();
        int? memCacheHeight = (constrainedBox.minHeight * devicePixelRatio).toInt();
        memCacheWidth = memCacheWidth == 0 || cancelMemCache? null : memCacheWidth + 50;
        memCacheHeight = memCacheHeight == 0 || cancelMemCache? null : memCacheHeight + 50;
        return CachedNetworkImage(
          imageUrl: image, height: height, width: width, fit: fit,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          placeholder: (context, url) => Image.asset(placeholder.isNotEmpty ? placeholder : isNotification ? Images.notificationPlaceholder : Images.placeholder,cacheHeight: memCacheHeight,cacheWidth: memCacheWidth, height: height ?? 50, width: width ?? 50, fit: fit,color: color,colorBlendMode: color == null? null : BlendMode.srcIn,),
          errorWidget: (context, url, error) => Image.asset(placeholder.isNotEmpty ? placeholder : isNotification ? Images.notificationPlaceholder : Images.placeholder,cacheHeight: memCacheHeight,cacheWidth: memCacheWidth, height: height, width: width, fit: fit,color: color),colorBlendMode: color == null? null : BlendMode.srcIn,
        );
      }
    );
  }
}

