import 'dart:ui';

import 'package:flutter/material.dart';

class GlassListTile extends StatelessWidget {
  final Widget title;
  const GlassListTile({required this.title, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: .25),
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.grey.shade200.withOpacity(
              0.15,
            ),
          ),
          child: ListTile(
            title: title,
          ),
        ),
      ),
    );
  }
}
