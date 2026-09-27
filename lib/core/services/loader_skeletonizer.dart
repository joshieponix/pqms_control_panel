import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoaderSkeletonizer extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  const LoaderSkeletonizer({
    super.key,
    required this.isLoading,
    required this.child
  });

  @override
  State<LoaderSkeletonizer> createState() => _LoaderSkeletonizerState();
}

class _LoaderSkeletonizerState extends State<LoaderSkeletonizer> {
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(enabled: widget.isLoading, child: widget.child);
  }
}
