import 'package:flutter/material.dart';
import 'package:trivia_checkin/widgets/color_widgets.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  CustomAppBar({super.key, required this.backgroundColor});
  // ignore: prefer_typing_uninitialized_variables
  var backgroundColor;
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      backgroundColor: darkBlueColor,
    );
  }
}
