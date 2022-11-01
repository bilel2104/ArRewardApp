import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/rewards_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardServices with ChangeNotifier {
  List<Rewards> rewards = [];
  Dio dio = Dio();
  String? _idreward;
  get idreward => _idreward;
  Future<List<Reward>?> fetchRewardsbyIdShop(int shopId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response =
          await dio.get("https://dev-reward.groupado.com/reward/api/v1/rewards",
              queryParameters: {"shopId": shopId},
              options: Options(
                headers: {
                  "authorization": prefs.getString('token'),
                },
              ));
      Rewards responseRewards = Rewards.fromJson(response.data);
      print(response.data);

      return responseRewards.data;
    } on DioError catch (e) {
      print(e.response!.data['message']);
      SnackBar(
        content: Text(e.response!.data['message']),
        backgroundColor: Colors.blueAccent,
      );
    }
  }

  Future setRewards(List rewardsList, int idshop) async {
    fetchRewardsbyIdShop(idshop).then((value) {
      if (value != null) {
        for (int i = 0; i < value.length; i++) {
          _idreward = value[i].id.toString();
          rewardsList.add(Reward(
              id: value[i].id,
              count: value[i].count,
              shopId: value[i].shopId,
              createdAt: value[i].createdAt,
              updatedAt: value[i].updatedAt,
              name: value[i].name,
              description: value[i].description,
              image: value[i].image,
              typeId: value[i].typeId));
        }
      }
    });
    notifyListeners();
  }

  void setRewardid() {}
}
