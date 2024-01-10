import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodsarv01/models/donation.dart';

class ViewRequests extends StatefulWidget {
  final Donation donation;
  const ViewRequests({Key? key, required this.donation}) : super(key: key);

  @override
  State<ViewRequests> createState() => _ViewRequestsState();
}

class _ViewRequestsState extends State<ViewRequests> {
  _confirmBook(String uid) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
                'Are You Ready to Accept the Request and Begin Transporting ?'),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("donations")
                          .doc(widget.donation.rid)
                          .update({
                        'status': 'transporting',
                        'recieverID': uid,
                      });
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .update({
                        'confirmed':
                            FieldValue.arrayUnion([widget.donation.rid]),
                        'requests':
                            FieldValue.arrayRemove([widget.donation.rid]),
                      });
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Accept',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Requests"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('requests', arrayContains: widget.donation.rid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No requests made yet",
                    style: TextStyle(fontSize: 20, color: Colors.black)),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      _confirmBook(snapshot.data!.docs[index]['uid']);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side:
                            const BorderSide(color: Colors.purple, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person),
                                const SizedBox(width: 8),
                                Text("${snapshot.data!.docs[index]['name']}"),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on),
                                const SizedBox(width: 8),
                                Text(
                                    "${snapshot.data!.docs[index]['location']}"),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.phone),
                                const SizedBox(width: 8),
                                Text("${snapshot.data!.docs[index]['phone']}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
