import 'package:flutter/material.dart';
import '../pages/pages.dart';

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
  DashboardPage dash = const DashboardPage();
  @override
  Widget build(BuildContext context) {
    if (widget.title.contains('SUCCESS')) {
      widget.dialogColor = Colors.green[700];
      widget.dialogColor2 = Colors.green[400];
      widget.dialogIcon = Icons.check_outlined;
    } else {
      widget.dialogColor = Colors.red[700];
      widget.dialogColor2 = Colors.red[400];
      widget.dialogIcon = Icons.cancel_outlined;
    }
    return Dialog(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: widget.dialogColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0))),
            height: 150.0,
            width: double.infinity,
            child: Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.dialogColor2,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    widget.dialogIcon,
                    size: 70.0,
                    color: Colors.white,
                  ),
                )),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            widget.title,
            style:Theme.of(context).textTheme.headline1!.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            widget.description,
            style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(
            height: 60.0,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: widget.dialogColor,
                  minimumSize: const Size(130, 45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                if (widget.title.contains('SUCCESS')) {
                  Navigator.popUntil(context, ModalRoute.withName('/homepage'));
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Okay',
              )),
          const SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
