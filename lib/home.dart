import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_user/auth/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedFilter = "All";
  List<String> _filterOptions = ["All", "Confirmed", "Not Confirmed"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              DropdownButton<String>(
                value: _selectedFilter,
                onChanged: (String? selectedItem) {
                  if (selectedItem != null) {
                    setState(() {
                      _selectedFilter = selectedItem;
                    });
                  }
                },
                items: _filterOptions.map((String filter) {
                  return DropdownMenuItem<String>(
                    value: filter,
                    child: Text(filter),
                  );
                }).toList(),
              ),
              Expanded(
                child: _buildUserList(),
              ),
              ElevatedButton(onPressed:() {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }, child: const Text('Logout')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }


        final documents = snapshot.data?.docs;

        if (documents == null || documents.isEmpty) {
          return const Text('No users found.');
        }


        final filteredUsers = _filterUsers(documents);

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      filteredUsers[index]["name"],
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      filteredUsers[index]["email"],
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Stream<QuerySnapshot> _getUserStream() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;


    switch (_selectedFilter) {
      case "All":
        return _firestore.collection('users').snapshots();
      case "Confirmed":
        return _firestore.collection('users').where('isEmailConfirmed', isEqualTo: true).snapshots();
      case "Not Confirmed":
        return _firestore.collection('users').where('isEmailConfirmed', isEqualTo: false).snapshots();
      default:
        return _firestore.collection('users').snapshots();
    }
  }

  List<DocumentSnapshot> _filterUsers(List<DocumentSnapshot>? documents) {

    switch (_selectedFilter) {
      case "All":
        return documents ?? [];
      case "Confirmed":
        return documents?.where((doc) => doc["isEmailConfirmed"] == true).toList() ?? [];
      case "Not Confirmed":
        return documents?.where((doc) => doc["isEmailConfirmed"] == false).toList() ?? [];
      default:
        return [];
    }
  }
}
