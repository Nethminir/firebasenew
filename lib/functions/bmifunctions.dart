import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/bmidatamodel.dart';

class Functions {
  addBmiData(BmiDatModel bmiData) async {
    await FirebaseFirestore.instance
        .collection('bmi_data')
        .add(bmiData.toJson());
  }
}
