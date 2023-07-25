import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title, description;

  var dialogColor = Colors.green[700];
  var dialogColor2 = Colors.green[400];
  var dialogIcon = Icons.check;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
