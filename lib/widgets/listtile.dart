import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodsarv01/models/donation.dart';
import 'package:foodsarv01/widgets/tile.dart';

// ignore: non_constant_identifier_names
Widget Listtile({required DocumentSnapshot snap}) {
  Donation donation = Donation.fromMap(snap);
  return Container(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(right: 10),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          child: Image.network(
            donation.url,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    Text(donation.foodName,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    tile(
                        title: "Expiry date",
                        subtitle:
                            "${donation.expiry_time.day}/${donation.expiry_time.month}/${donation.expiry_time.year}"),
                    const Spacer(),
                    tile(
                        title: "Quantity",
                        subtitle: "${donation.quantity} ${donation.unit}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
