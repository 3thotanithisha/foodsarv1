// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:foodsarv01/models/donation.dart';
import 'package:uuid/uuid.dart';

class DBMethods {
  Future<String> addDonationToDB(
      {required String name,
      required String foodName,
      required int quantity,
      required String location,
      required List requests,
      required String url,
      required String uid,
      required String unit,
      required DateTime expiry_time,
      required DateTime pickup_time,
      required String mobile,
      required String imgurl,
      required String status,
      required String coordinates}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String docId = const Uuid().v4();
    try {
      if (name.isNotEmpty &&
          foodName.isNotEmpty &&
          quantity != 0 &&
          unit.isNotEmpty &&
          mobile.isNotEmpty &&
          imgurl.isNotEmpty) {
        await firestore.collection("donations").doc(docId).set({
          "name": name,
          "uid": uid,
          "foodName": foodName,
          "quantity": quantity,
          "unit": unit,
          "requests": requests,
          "expiry_time": expiry_time,
          "pickup_time": pickup_time,
          "location": location,
          "coordinates": coordinates,
          'rid': docId,
          'pickup_otp': (Random().nextInt(900000) + 100000).toString(),
          'delivery_otp': (Random().nextInt(900000) + 100000).toString(),
          'recieverID': '',
          "mobile": mobile,
          "imgUrl": imgurl,
          "status": "pending",
        });
        FirebaseFirestore.instance.collection("users").doc(uid).update({
          "donations": FieldValue.arrayUnion([docId])
        });
        return 'success';
      } else {
        return "Please fill all the fields";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateUserInfoToDB() async {}

  Future<void> getDonations() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // FirebaseAuth auth = FirebaseAuth.instance;
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection("donations").get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        if (kDebugMode) {
          print(Donation.fromMap(querySnapshot.docs[i]));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<String> setRequest({
    required String docId,
    required String requesterId,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection("donations").doc(docId).update({
        "requests": FieldValue.arrayUnion([requesterId])
      });
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<Donation> getDonationDetails({required String docId}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection("donations").doc(docId).get();
      return Donation.fromMap(documentSnapshot);
    } catch (e) {
      rethrow;
    }
  }
}
