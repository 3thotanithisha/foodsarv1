import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransporterStatus extends StatefulWidget {
  const TransporterStatus({Key? key}) : super(key: key);

  @override
  State<TransporterStatus> createState() => _TransporterStatusState();
}

class _TransporterStatusState extends State<TransporterStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("donations")
              .where(Filter.or(
                  Filter('status', isEqualTo: 'delivered'),
                  Filter('status', isEqualTo: 'started'),
                  Filter('status', isEqualTo: 'waiting')))
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No delivery started yet",
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        tileColor: Colors.green,
                        onTap: () {
                          // _confirmBook();
                        },
                        title: Text(
                          snapshot.data!.docs[index]['foodName'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          snapshot.data!.docs[index]['name'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          "${snapshot.data!.docs[index]['quantity']} ${snapshot.data!.docs[index]['unit']}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
