import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_application_1/presentation/resources/color_manager.dart';
import 'package:flutter_application_1/services/rewards_services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Cflip extends StatefulWidget with ChangeNotifier {
  String? shopName;
  int? shopid;
  String? details;
  String? imagePath;
  String? distance;
  String? address;
  List? rewardsList;
  Function()? ontap;
  String? idReward;
  String? get _idreward => idReward;

  setrewardid(testtttt) {
    idReward = testtttt;
    notifyListeners();
  }

  Cflip(
      {Key? key,
      this.shopid,
      this.rewardsList,
      this.address,
      this.shopName,
      this.details,
      this.imagePath,
      this.distance,
      this.ontap})
      : super(key: key);

  @override
  State<Cflip> createState() => _CflipState();
}

class _CflipState extends State<Cflip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;
  bool isanycardopen = false;

  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Horizontal Flipping
          GestureDetector(
            onTap: () {
              if (_status == AnimationStatus.dismissed) {
                _controller.forward();
                RewardServices()
                    .setRewards(widget.rewardsList!, widget.shopid!);
                setState(() {});
              } else {
                _controller.reverse();
                widget.rewardsList!.clear();
              }
            },
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..rotateY(math.pi * _animation.value),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: _animation.value <= 0.5
                      ? Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              image: DecorationImage(
                                image: AssetImage("assets/images/aa.png"),
                                fit: BoxFit.fill,
                              )),
                          //    margin: const EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.18,
                                      child: const CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: AssetImage(
                                            'assets/images/logo.png'),
                                      )),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 16, top: 10),
                                    child: Text(
                                      '${widget.shopName} \n ${widget.address}',
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 20,
                                          color: Colors.white),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  widget.details!,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 170, top: 20),
                                child: Text(
                                  widget.distance!,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      : widget.rewardsList!.isNotEmpty
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.18,
                              margin: const EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.8,
                              color: ColorManager.white,
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 1.5,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 20),
                                  itemCount: widget.rewardsList!.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(math.pi),
                                        child: Badge(
                                          position: const BadgePosition(
                                              top: -0.01, end: -0.10),
                                          badgeContent: Text(
                                            '${widget.rewardsList![index].count}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                          badgeColor: Colors.blueAccent,
                                          child: GestureDetector(
                                            onTap: () {
                                              context.read<Cflip>().setrewardid(
                                                  widget.rewardsList?[index].id
                                                      .toString());

                                              widget.ontap!();
                                            },
                                            child: Container(
                                              height: 90,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/gift.png'),
                                                  fit: BoxFit.fill,
                                                ),
                                                color: ColorManager.primary,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ));
                                  }))
                          : Transform(
                              alignment: FractionalOffset.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.0015)
                                ..rotateY(math.pi * _animation.value),
                              child: Center(
                                child: Container(
                                    width: 200,
                                    height: 100,
                                    child: const Center(
                                        child: Text('there is no rewards'))),
                              ),
                            )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
