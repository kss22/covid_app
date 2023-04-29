import 'package:covid_app/assets/assets.dart';
import 'package:covid_app/assets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<Map<dynamic, dynamic>> userList = [];
  List<Map<dynamic, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  bool showSearchBar = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    databaseReference.child('users').onValue.listen((event) {
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
          .where((user) => user['phone'].toString().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('User List'),
        automaticallyImplyLeading: false,
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
        ],
        leading: IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.exit_to_app)),
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
                      hintText: 'Search by phone number',
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetails(
                          user: filteredList[index],
                        ),
                      ),
                    );
                  },
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
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class UserDetails extends StatelessWidget {
  final Map<dynamic, dynamic> user;

  const UserDetails({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseReference timeSlotsRef =
    FirebaseDatabase.instance.reference().child('time_slots');
    String _startTimeString = "";

    void setAppointment() {
      timeSlotsRef
          .orderByChild('available')
          .equalTo(true)
          .limitToFirst(1)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          // Get the key of the first available time slot
          String key = snapshot.value.keys.first;
          // Use the key to update the availability of the time slot to false
          timeSlotsRef.child(key).update({'available': false});
          // Use the key to perform other operations on the time slot
          _startTimeString = snapshot.value[key]['start_time'];
        } else {
          // Handle the case when no available time slots are found
        }
      }).catchError((error) {
        // Handle the error
        print(error);
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(user['name']),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 26.0,
            ),
            Container(
              width: double.infinity,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patient Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      UserInfoRow(title: 'Email', value: user['email']),
                      UserInfoRow(title: 'Name', value: user['name']),
                      UserInfoRow(title: 'Phone Number', value: user['phone']),
                      UserInfoRow(
                          title: 'Medical conditions', value: user['meds']),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 26.0,
            ),
            Container(
              width: double.infinity,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dose Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      UserInfoRow(
                          title: 'First Dose', value: user['first_dose']),
                      UserInfoRow(
                          title: 'Second Dose', value: user['second_dose']),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 26.0,
            ),
            Container(
              width: double.infinity,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Appointments' History",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      UserInfoRow(title: 'First Dose', value: user['first_appointment']),
                      UserInfoRow(title: 'Second Dose', value: user['second_appointment'])
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            if (user['first_dose']=='none' && user['first_appointment']!='-')
            RoundedButton(
                text: "Confirm Dose",
                press: () {
                  final DatabaseReference ref = FirebaseDatabase.instance.reference().child('users').child(user['uid']);

                  ref.update({
                    'first_dose': 'Done'
                  }).then((value) {
                    print("Value updated successfully");
                  }).catchError((error) {
                    print("Failed to update value: $error");
                  });

                }),
            if (user['second_dose']=='none' && user['first_dose']!='none' && user['second_appointment']!='-')
              RoundedButton(
                  text: "Confirm Dose",
                  press: () {
                    final DatabaseReference ref = FirebaseDatabase.instance.reference().child('users').child(user['uid']);

                    ref.update({
                      'second_dose': 'Done'
                    }).then((value) {
                      print("Value updated successfully");
                    }).catchError((error) {
                      print("Failed to update value: $error");
                    });
                  }),
            if(user['second_dose']=='none' && user['first_dose']!='none' && user['second_appointment']=='-')
              RoundedButton(
                  text: "Book appointment",
                  press: () {
                    setAppointment();
                    final DatabaseReference ref = FirebaseDatabase.instance.reference().child('users').child(user['uid']);

                    ref.update({
                      'second_appointment': _startTimeString
                    }).then((value) {
                      print("Value updated successfully");
                    }).catchError((error) {
                      print("Failed to update value: $error");
                    });
                  }),
          ],
        ),
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final String title;
  final String value;

  UserInfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
