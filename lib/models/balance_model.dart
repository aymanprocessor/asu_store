import 'dart:convert';

class BalanceModel {
  String owner;
  int date;
  int balance;
  BalanceModel({
    this.owner,
    this.date,
    this.balance,
  });

  BalanceModel copyWith({
    String owner,
    int date,
    int balance,
  }) {
    return BalanceModel(
      owner: owner ?? this.owner,
      date: date ?? this.date,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'owner': owner,
      'date': date,
      'balance': balance,
    };
  }

  factory BalanceModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return BalanceModel(
      owner: map['owner'],
      date: map['date'],
      balance: map['balance'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BalanceModel.fromJson(String source) =>
      BalanceModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'BalanceModel(owner: $owner, date: $date, balance: $balance)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is BalanceModel &&
        o.owner == owner &&
        o.date == date &&
        o.balance == balance;
  }

  @override
  int get hashCode => owner.hashCode ^ date.hashCode ^ balance.hashCode;
}
