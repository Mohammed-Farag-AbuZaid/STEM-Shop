import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/curved_edges/curved_widget.dart';

class TCustomCurvedEdges extends StatelessWidget {
  const TCustomCurvedEdges({
    super.key,
    this.child,
  });
  
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TCurvedWidget(),
      child: child,
    );
  }
}
