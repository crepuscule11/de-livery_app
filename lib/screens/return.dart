import 'dart:convert';

import 'package:delivery_app/models/return.dart';
import 'package:delivery_app/screens/deliverydetails_screen.dart';
import 'package:delivery_app/screens/detailsscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Return extends StatefulWidget {
  const Return({Key? key}) : super(key: key);

  @override
  State<Return> createState() => _ReturnState();
}

class _ReturnState extends State<Return> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Datum> datum = [];
  String? returnId;
  late Future<List<Balik>> returnFuture;

  Future<List<Balik>> returnDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? jsonData = prefs.getInt('jsonData');
      if (jsonData != null) {
        Map<String, String> headers = {'Content-Type': 'application/json'};

        final response = await http.get(
          Uri.parse(
              'http://gorder.website/API/rider/return-requests.php?rider_id=$jsonData'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final Map<String, dynamic> responseMap = json.decode(response.body);
          Balik user = Balik.fromMap(responseMap);
          final responseData = json.encode(response.body);
          String? returnId = jsonData['data'][0]['return_id'];
          print("return: ${returnId}");
          setState(() {
            datum = user.data;
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

  @override
  void initState() {
    super.initState();
    returnFuture = returnDetails();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: datum.length,
                itemBuilder: (contextm, index) {
                  final l = datum[index];
                  return Card(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: ((context) =>
                                ReturnDetails(returnId: l.returnId)),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text("Transaction ID: ${l.transactionId}"),
                        trailing: Icon(Icons.arrow_right),
                        subtitle: Text("Reason: ${l.returnReason}"),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
