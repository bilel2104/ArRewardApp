class CapRewardModel {
  CapturedReward? capturedReward;

  CapRewardModel({this.capturedReward});

  CapRewardModel.fromJson(Map<String, dynamic> json) {
    capturedReward = json['capturedReward'] != null
        ? CapturedReward.fromJson(json['capturedReward'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (capturedReward != null) {
      data['capturedReward'] = capturedReward!.toJson();
    }
    return data;
  }
}

class CapturedReward {
  int? id;
  int? userId;
  int? rewardId;
  bool? isCancelled;
  String? updatedAt;
  String? createdAt;

  CapturedReward(
      {this.id,
      this.userId,
      this.rewardId,
      this.isCancelled,
      this.updatedAt,
      this.createdAt});

  CapturedReward.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    rewardId = json['rewardId'];
    isCancelled = json['isCancelled'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['rewardId'] = this.rewardId;
    data['isCancelled'] = this.isCancelled;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
