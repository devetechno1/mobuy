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
  const CustomImage({super.key, required this.image,this.color, this.height, this.width, this.fit = BoxFit.cover, this.isNotification = false, this.placeholder = ''});

  @override
  Widget build(BuildContext context) {

    return CachedNetworkImage(
      imageUrl: image, height: height, width: width, fit: fit,
      placeholder: (context, url) => Image.asset(placeholder.isNotEmpty ? placeholder : isNotification ? Images.notificationPlaceholder : Images.placeholder, height: height ?? 50, width: width ?? 50, fit: fit,color: color,colorBlendMode: color == null? null : BlendMode.srcIn,),
      errorWidget: (context, url, error) => Image.asset(placeholder.isNotEmpty ? placeholder : isNotification ? Images.notificationPlaceholder : Images.placeholder, height: height, width: width, fit: fit,color: color),colorBlendMode: color == null? null : BlendMode.srcIn,
    );
  }
}

