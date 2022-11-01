import 'package:flutter/material.dart';

class NotificatinWidget extends StatelessWidget {
  final String title;
  final String message;
  String? imagePath;
  NotificatinWidget(
      {Key? key, required this.title, required this.message, this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 80,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              spreadRadius: 5,
            )
          ],
        ),
        child: Row(
          children: [
            Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: 40,
                height: 40,
                child: Image.asset(imagePath ?? 'assets/images/logo.png')),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 100, top: 10),
                  child: Text(
                    "$title ",
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 110),
                  child: Text(
                    message,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
