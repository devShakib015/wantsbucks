import 'dart:convert';

import 'package:flutter/cupertino.dart';

class WithdrawModel {
  String userId;
  String email;
  String phone;
  String accountType;
  String paymentMethod;
  int amount;
  String status;
  DateTime requestTime;
  DateTime completedTime;
  WithdrawModel({
    @required this.userId,
    @required this.email,
    @required this.phone,
    @required this.accountType,
    @required this.paymentMethod,
    @required this.amount,
    @required this.status,
    @required this.requestTime,
    @required this.completedTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'phone': phone,
      'accountType': accountType,
      'paymentMethod': paymentMethod,
      'amount': amount,
      'status': status,
      'requestTime': requestTime.millisecondsSinceEpoch,
      'completedTime': completedTime?.millisecondsSinceEpoch,
    };
  }

  factory WithdrawModel.fromMap(Map<String, dynamic> map) {
    return WithdrawModel(
      userId: map['userId'],
      email: map['email'],
      phone: map['phone'],
      accountType: map['accountType'],
      paymentMethod: map['paymentMethod'],
      amount: map['amount'],
      status: map['status'],
      requestTime: DateTime.fromMillisecondsSinceEpoch(map['requestTime']),
      completedTime: DateTime.fromMillisecondsSinceEpoch(map['completedTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory WithdrawModel.fromJson(String source) =>
      WithdrawModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WithdrawModel(userId: $userId, email: $email, phone: $phone, accountType: $accountType, paymentMethod: $paymentMethod, amount: $amount, status: $status, requestTime: $requestTime, completedTime: $completedTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WithdrawModel &&
        other.userId == userId &&
        other.email == email &&
        other.phone == phone &&
        other.accountType == accountType &&
        other.paymentMethod == paymentMethod &&
        other.amount == amount &&
        other.status == status &&
        other.requestTime == requestTime &&
        other.completedTime == completedTime;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        accountType.hashCode ^
        paymentMethod.hashCode ^
        amount.hashCode ^
        status.hashCode ^
        requestTime.hashCode ^
        completedTime.hashCode;
  }
}
