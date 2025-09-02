import 'package:alert_banner/exports.dart';
import 'package:flutter/material.dart';

void Alert({
  required BuildContext context,
  required String message,
  required String type,
}) {
  Color color = Colors.redAccent;

  if (type.toLowerCase() == 'success') {
    color = Colors.green;
  } else if (type.toLowerCase() == 'error') {
    color = Colors.redAccent;
  } else if (type.toLowerCase() == 'warning') {
    color = Colors.amberAccent;
  } else if (type.toLowerCase() == 'info') {
    color = Colors.blue;
  } else if (type.toLowerCase() == 'loading') {
    color = Colors.grey;
  }

  showAlertBanner(
    context,
    () {},
    alertBannerLocation: AlertBannerLocation.top,
    Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Material(
          color: Colors.transparent,
          child: Text(
            message,
            style: TextStyle(
              color: color == Colors.amberAccent ? Colors.black : Colors.white,
              fontSize: 18,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}
