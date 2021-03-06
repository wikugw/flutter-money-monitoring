class UserModel {
  String? name;
  String? email;
  String? photoUrl;
  String? createdAt;
  String? updatedAt;
  int? totalEntireSpent;
  List<MoneyHistory>? moneyHistory;

  UserModel(
      {this.name,
      this.email,
      this.photoUrl,
      this.createdAt,
      this.updatedAt,
      this.totalEntireSpent,
      this.moneyHistory});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    photoUrl = json['photoUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    totalEntireSpent = json['totalEntireSpent'];
    if (json['moneyHistory'] != null) {
      moneyHistory = <MoneyHistory>[];
      json['moneyHistory'].forEach((v) {
        moneyHistory!.add(MoneyHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['photoUrl'] = photoUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['totalEntireSpent'] = totalEntireSpent;
    if (moneyHistory != null) {
      data['moneyHistory'] = moneyHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MoneyHistory {
  String? year;
  String? month;
  String? monthName;
  int? totalInMonth;
  List<Dates>? dates;
  String? id;

  MoneyHistory(
      {this.id,
      this.year,
      this.month,
      this.monthName,
      this.totalInMonth,
      this.dates});

  MoneyHistory.fromJson(Map<String, dynamic> json) {
    id = json[''];
    year = json['year'];
    month = json['month'];
    monthName = json['monthName'];
    totalInMonth = json['totalInMonth'];
    if (json['dates'] != null) {
      dates = <Dates>[];
      json['dates'].forEach((v) {
        dates!.add(Dates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['year'] = year;
    data['month'] = month;
    data['monthName'] = monthName;
    data['totalInMonth'] = totalInMonth;
    if (dates != null) {
      data['dates'] = dates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dates {
  String? id;
  String? date;
  List<Records>? records;
  int? totalInDay;

  Dates({this.id, this.date, this.records, this.totalInDay});

  set Record(List<Records> records) {
    records = records;
  }

  Dates.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(Records.fromJson(v));
      });
    }
    totalInDay = json['totalInDay'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['date'] = date;
    if (records != null) {
      data['records'] = records!.map((v) => v.toJson()).toList();
    }
    data['totalInDay'] = totalInDay;
    return data;
  }
}

class Records {
  String? id;
  String? spentName;
  String? spentType;
  int? total;
  String? attachment;
  String? createdAt;
  String? updatedAt;

  Records(
      {this.id,
      this.spentName,
      this.spentType,
      this.total,
      this.attachment,
      this.createdAt,
      this.updatedAt});

  Records.fromJson(Map<String, dynamic> json) {
    spentName = json['spentName'];
    spentType = json['spentType'];
    total = json['total'];
    attachment = json['attachment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['spentName'] = spentName;
    data['spentType'] = spentType;
    data['total'] = total;
    data['attachment'] = attachment;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
