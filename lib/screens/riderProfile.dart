import 'dart:convert';

import 'package:delivery_app/models/usermodel.dart';
import 'package:delivery_app/screens/deliverydetails_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class Profile extends StatefulWidget {
  static const routeName = "/profile";

  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

// http://gorder.website/API/user-profile.php?id=817622
class _ProfileState extends State<Profile> {
  List<Data> data = [];
  List<Usermodel> userModel = [];
  late Future<List<Usermodel>> userFuture;

  Future<List<Usermodel>> userDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? jsonData = prefs.getInt('jsonData');
      if (jsonData != null) {
        Map<String, String> headers = {'Content-Type': 'application/json'};

        final response = await http.get(
          Uri.parse(
              'http://gorder.website/API/rider/rider-profile.php?id=$jsonData'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final response1 = json.decode(response.body);
          Usermodel user = Usermodel.fromJson(response1);

          setState(() {
            data = [user.data];
          });

          return [user];
        } else {
          setState(() {
            Map<String, dynamic> jsonMap = jsonDecode(response.body);
            String mess = jsonMap['message'];

            print(mess);
            print("failed");
          });
          throw Exception('Failed to load data');
        }
      } else {
        print('userId is null');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<void> printBarangayIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedBarangayId = prefs.getString('barangayId');
  }

  @override
  void initState() {
    super.initState();

    userFuture = userDetails();
    printBarangayIdFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final l = data[index];
          return Column(
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 70,
                child: Image.network(
                  l.picture,
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              itemProfile('Name', l.name, CupertinoIcons.person),
              const SizedBox(height: 10),
              itemProfile('Phone', l.contactNo, CupertinoIcons.phone),
              const SizedBox(height: 10),
              itemProfile('Address', l.address, CupertinoIcons.location),
              const SizedBox(height: 10),
              itemProfile('Email', l.email, CupertinoIcons.mail),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: ((context) => LoginScreen())));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text('log out'),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: ((context) => DetailsScreen())));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text('Back To Delivery App'),
                ),
              ),
            ],
          );
        },
      ),
    ));
  }
}

itemProfile(String title, String subtitle, IconData iconData) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 5),
              color: Colors.deepOrange.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 10)
        ]),
    child: ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(iconData),
      trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
      tileColor: Colors.white,
    ),
  );
}
