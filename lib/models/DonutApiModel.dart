class DonutApiModel {
  String category;
  String amount;
  String percentage;
  String icon;

  DonutApiModel({this.category, this.amount, this.percentage, this.icon});

  DonutApiModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    amount = json['amount'];
    percentage = json['percentage'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['amount'] = this.amount;
    data['percentage'] = this.percentage;
    data['icon'] = this.icon;
    return data;
  }
}