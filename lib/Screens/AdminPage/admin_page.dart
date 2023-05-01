import 'package:covid_app/Screens/%20MedicalPersonnel/medical_personnel_home.dart';
import 'package:covid_app/assets/assets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Map<dynamic, dynamic>> userList = [];
  List<Map<dynamic, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  bool showSearchBar = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    databaseReference.child('personnel').onValue.listen((event) {
      setState(() {
        _isLoading = false;
        userList = [];
        Map<dynamic, dynamic> values = event.snapshot.value;
        values.forEach((key, value) {
          userList.add(value);
        });
        filteredList = List.from(userList);
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterList(String query) {
    setState(() {
      filteredList = userList
          .where((user) =>
          user['phone'].toString().contains(query) ||
          user['name'].toString().contains(query.toLowerCase())
      )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('Personnel List'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.exit_to_app)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showSearchBar = !showSearchBar;
                if (!showSearchBar) {
                  searchController.clear();
                  filterList('');
                }
              });
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => UserList()));
              },
              icon: Icon(Icons.more_vert))
        ],
        bottom: showSearchBar
            ? PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: filterList,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search by name, or phone number',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        filteredList[index]['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        filteredList[index]['phone'],
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
