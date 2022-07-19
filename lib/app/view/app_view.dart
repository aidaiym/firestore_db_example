import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['name'],
              style: TextStyle(color: Colors.red),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.green),
            child: Text(
              document['votes'].toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('loading . . .');
          return ListView.builder(
            itemExtent: 80,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
                _buildListItem(context, snapshot.data!.docs[index]),
          );
        },
        stream:
            FirebaseFirestore.instance.collection('examplename').snapshots(),
      ),
    );
  }
}
