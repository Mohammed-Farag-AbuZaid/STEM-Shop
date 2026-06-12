import 'package:flutter/material.dart';
import 'package:stem_shop/utils/constants/colors.dart';

class TShadowStyle {

  static final verticalProductShadow = BoxShadow(
    color: TColors.darkGrey.withValues(alpha: 0.1),
    spreadRadius: 7,
    blurRadius: 50,
    offset: Offset(0, 2), // changes position of shadow
  );

  static final horizontalProductShadow = BoxShadow(
    color: TColors.darkGrey.withValues(alpha: 0.1),
    spreadRadius: 7,
    blurRadius: 50,
    offset: Offset(0, 2), // changes position of shadow
  );

}

