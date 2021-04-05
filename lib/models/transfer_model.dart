import 'dart:convert';

import 'package:flutter/cupertino.dart';

class TransferModel {
  DateTime time;
  String from;
  String to;
  int amount;
  TransferModel({
    @required this.time,
    @required this.from,
    @required this.to,
    @required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time.millisecondsSinceEpoch,
      'from': from,
      'to': to,
      'amount': amount,
    };
  }

  factory TransferModel.fromMap(Map<String, dynamic> map) {
    return TransferModel(
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      from: map['from'],
      to: map['to'],
      amount: map['amount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TransferModel.fromJson(String source) =>
      TransferModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TransferModel(time: $time, from: $from, to: $to, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransferModel &&
        other.time == time &&
        other.from == from &&
        other.to == to &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return time.hashCode ^ from.hashCode ^ to.hashCode ^ amount.hashCode;
  }
}
