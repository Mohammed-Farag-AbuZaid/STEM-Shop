import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:stem_shop/utils/constants/colors.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
  });
   
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return TCustomCurvedEdges(
      child: Container(
        color: TColors.primary,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 400,
          child: Stack(
            children: [
              Positioned(
                top: -150,
                right: -250,
                child: TCircularContianer(
                  backgroundColor: TColors.textwhite.withValues(
                    alpha: 0.1,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                right: -300,
                child: TCircularContianer(
                  backgroundColor: TColors.textwhite.withValues(
                    alpha: 0.1,
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
