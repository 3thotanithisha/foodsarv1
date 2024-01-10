import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodsarv01/models/donation.dart';

class PickUp extends StatefulWidget {
  final String id;
  const PickUp({Key? key, required this.id}) : super(key: key);

  @override
  State<PickUp> createState() => _PickUpState();
}

class _PickUpState extends State<PickUp> {
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = true;
  late Donation donation;

  @override
  void initState() {
    super.initState();
    get();
  }

  void get() {
    FirebaseFirestore.instance
        .collection('donations')
        .doc(widget.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          donation = Donation.fromMap(documentSnapshot);
          isLoading = false;
        });
      }
    });
  }

  void _enterOTP(String otp) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter OTP'),
            content: TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter OTP',
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    if (otp == _otpController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('OTP verified')));
                      await FirebaseFirestore.instance
                          .collection('donations')
                          .doc(widget.id)
                          .update({'status': 'picked'});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('OTP not verified')));
                    }
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PickUp Item Details')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundImage: NetworkImage(donation.url),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Donator: ${donation.name}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Food Donated : ${donation.foodName}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Quantity: ${donation.quantity} ${donation.unit}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Location: ${donation.location}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Mobile: ${donation.mobile}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Expiry Date: ${donation.expiry_time.toString().substring(0, 16)}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(15.0),
                                  textStyle: const TextStyle(fontSize: 20.0)),
                              onPressed: () {
                                log(donation.pickup_otp.toString());
                                _enterOTP(donation.pickup_otp);
                              },
                              child: const Text('PickUp'),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
    );
  }
}
