import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class BmiDatModel {
  final String name;
  final String address;
  final String gender;
  final String bmi;
  final String bmiComment;

  BmiDatModel({
    required this.name,
    required this.address,
    required this.gender,
    required this.bmi,
    required this.bmiComment,
  });

  factory BmiDatModel.fromRawJson(String str) =>
      BmiDatModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BmiDatModel.fromJson(Map<String, dynamic> json) => BmiDatModel(
        name: json["name"],
        address: json["address"],
        gender: json["gender"],
        bmi: json["bmi"],
        bmiComment: json["bmiComment"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "gender": gender,
        "bmi": bmi,
        "bmiComment": bmiComment,
      };
}
