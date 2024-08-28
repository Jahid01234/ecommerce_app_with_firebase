import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite Page"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("user-favourite-item")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("items")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Something went wrong: ${snapshot.error}"),
                );
              } else if (!snapshot.hasData) {
                return const Center(child: Text("No data available"));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                    snapshot.data!.docs[index];
                    return Card(
                      color: Colors.teal.shade100,
                      child: ListTile(
                        leading: Text(
                          documentSnapshot["name"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        title: Text(
                          "\$${documentSnapshot["price"].toString()}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection("user-favourite-item")
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .collection("items")
                                .doc(documentSnapshot.id)
                                .delete();
                          },
                          child: const CircleAvatar(
                            child: Icon(Icons.delete),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
