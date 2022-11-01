import 'dart:async';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/errorDialogHendler/dialog.dart';
import 'package:flutter_application_1/presentation/widgets/shopsFlipCard.dart';
import 'package:flutter_application_1/services/captureRewardServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:provider/provider.dart';

class ArScreenios extends StatefulWidget {
  ArScreenios({Key? key}) : super(key: key);

  @override
  State<ArScreenios> createState() => _ArScreeniosState();
}

class _ArScreeniosState extends State<ArScreenios> {
  //----------- on tap handler to recive the reward ----------------
  void onNodeTapHandler() async {
    Provider.of<Cflip>(context, listen: false)
        .setrewardid(Provider.of<Cflip>(context, listen: false).idReward);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CaptureReward()
        .capture(Provider.of<Cflip>(context, listen: false).idReward)
        .then((val) async {
      print(val);
      if (val != null) {
        ErrorDialog2().showCustomDialog(
          context,
          "congratulations you have recived the reward",
          'assets/json/gift.json',
        );
      } else {
        ErrorDialog2().showCustomDialog(
          context,
          "you have already recived the reward",
          'assets/json/gift.json',
        );
      }
    });
  }

//---------------------------------------------------------------
  late ARKitController arkitController;
  bool anchorWasFound = false; // to check if the anchor was found

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<Cflip>(context, listen: false)
        .setrewardid(Provider.of<Cflip>(context, listen: false).idReward);
    super.initState();
  }

  void onAnchorWasFound(ARKitAnchor anchor) {
    if (anchor is ARKitImageAnchor) {
      setState(() => anchorWasFound = true);

      final giftPosition = anchor.transform.getColumn(3);
      final node = ARKitReferenceNode(
        url: 'models.scnassets/test1.dae',
        scale: vector.Vector3.all(0.02),
        position:
            vector.Vector3(giftPosition.x, giftPosition.y, giftPosition.z),
        eulerAngles: vector.Vector3.zero(),
      );
      arkitController.add(node);
    }
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = onAnchorWasFound;
    this.arkitController.onNodeTap = (nodes) => onNodeTapHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            ARKitSceneView(
              detectionImages: const [
                ARKitReferenceImage(
                  name:
                      'https://henryct.files.wordpress.com/2010/11/gift-for-holidays.jpg', //get the url from api
                  physicalWidth: 0.2,
                ),
              ],
              enableTapRecognizer: true,
              onARKitViewCreated: onARKitViewCreated,
            ),
            anchorWasFound
                ? Container()
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
