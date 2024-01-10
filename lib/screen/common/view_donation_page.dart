import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodsarv01/models/donation.dart';
import 'package:foodsarv01/screen/donor/view_requests.dart';

class ViewAcceptScreen extends StatefulWidget {
  final DocumentSnapshot snap;
  final bool isMine;

  const ViewAcceptScreen({Key? key, required this.snap, required this.isMine})
      : super(key: key);

  @override
  State<ViewAcceptScreen> createState() => _ViewAcceptScreenState();
}

class _ViewAcceptScreenState extends State<ViewAcceptScreen> {
  TextEditingController phone = TextEditingController();
  TextEditingController location = TextEditingController();

  @override
  void initState() {
    if (kDebugMode) {
      print(FirebaseAuth.instance.currentUser!.uid == widget.snap['uid']);
    }
    super.initState();
  }

  _getData() async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Enter your details'),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: location,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Location',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () async {
                          if (phone.text.isNotEmpty &&
                              location.text.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              'status': 'transport',
                              'phone': phone.text,
                              'location': location.text
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Details Updated and Request Sent'),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all the details'),
                              ),
                            );
                          }
                        },
                        child: const Text('Confirm')),
                  ],
                ),
              ),
            ],
          );
        });
  }

  _showOTP(
    String otp,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('PickUp OTP'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 10.0),
                child: Text(
                  otp,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: const Text('Confirm')),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Donation donation = Donation.fromMap(widget.snap);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Details'),
      ),
      body: Padding(
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
                const SizedBox(height: 10.0),
                Text(
                  "Donator: ${donation.name}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.black),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Food Donated : ${donation.foodName}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.black),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Quantity : ${donation.quantity} ${donation.unit}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.black),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Location : ${donation.location}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.black),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Mobile : ${donation.mobile}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.black),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Expiry Time : ${donation.expiry_time.toString().substring(0, 16)}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.black),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15.0)),
                        onPressed: () {
                          if (FirebaseAuth.instance.currentUser!.uid ==
                                  donation.uid &&
                              donation.status == 'pending') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewRequests(
                                          donation: donation,
                                        )));
                          } else {
                            _showOTP(donation.pickup_otp);
                          }
                        },
                        child: Text(FirebaseAuth.instance.currentUser!.uid ==
                                    donation.uid &&
                                donation.status == 'pending'
                            ? "View Requests"
                            : 'PickUp OTP'),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15.0),
                        ),
                        onPressed: () async {
                          _getData();
                          if (FirebaseAuth.instance.currentUser!.uid ==
                              donation.uid) {
                            FirebaseFirestore.instance
                                .collection('donations')
                                .doc(widget.snap.id)
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Donation Deleted'),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            _getData();
                            FirebaseFirestore.instance
                                .collection('donations')
                                .doc(widget.snap.id)
                                .update({
                              'requests': FieldValue.arrayUnion(
                                  [FirebaseAuth.instance.currentUser!.uid])
                            });
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              'requests':
                                  FieldValue.arrayUnion([widget.snap.id])
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Request Sent'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text(FirebaseAuth.instance.currentUser!.uid ==
                                donation.uid
                            ? "Delete Donation"
                            : "Request"),
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
