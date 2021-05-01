import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PublicCodes extends StatefulWidget {
  @override
  _PublicCodesState createState() => _PublicCodesState();
}

class _PublicCodesState extends State<PublicCodes> {
  final DateTime now = DateTime.now();
  var stream = FirebaseFirestore.instance.collection('public_betslip');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ChatBox'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _addPublicBet();
              },
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: stream.orderBy('timestamp').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.isEmpty) {
                        return Center(
                          child: Text('No bet codes from the public right now'),
                        );
                      }
                      return _listView(snapshot.data.docs);
                    }
                    return Center(
                      child: Text('loading'),
                    );
                  }),
            ), Container()
          ],
        ),
      ),
    );
  }

  _listView(List<QueryDocumentSnapshot> publicbets) {
    final String currentDate = DateFormat('yyyy-MM-dd').format(now);
    return ListView.builder(
      itemCount: publicbets.length,
      itemBuilder: (context, index) {
        final data = publicbets[index].data();
        // if (data['date'].toString() == currentDate) {
          return Card(
                      child: ListTile(
              title: Text('${data['author']}'),
              subtitle: Column(),
              onTap: (){},
            ),
          );
        // }
        // return Container();
      },
    );
  }

  _addPublicBet() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Post Slip'),
            content: Column(
              children: [],
            ),
          );
        });
  }
}
