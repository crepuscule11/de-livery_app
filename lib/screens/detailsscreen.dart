import 'dart:convert';

import 'package:delivery_app/models/red2.dart';
import 'package:delivery_app/models/rtn_model.dart';
import 'package:delivery_app/screens/deliverydetails_screen.dart';
import 'package:delivery_app/screens/return.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/remit_model.dart';
import 'package:http/http.dart' as http;

class ReturnDetails extends StatefulWidget {
  final String? returnId;
  const ReturnDetails({Key? key, this.returnId}) : super(key: key);

  @override
  State<ReturnDetails> createState() => _ReturnDetailsState();
}

class _ReturnDetailsState extends State<ReturnDetails> {
  TextEditingController rtn = TextEditingController(text: "RTN");
  List<Items> rej = [];
  late Future<List<RemitDetails>> rejectedFuture;
  Future<List<RemitDetails>> ToReject() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? jsonData = prefs.getInt('jsonData');

      if (jsonData != null) {
        Map<String, String> headers = {'Content-Type': 'application/json'};
        final response = await http.get(
          Uri.parse(
              'http://gorder.website/API/rider/return-details.php?rider_id=53461&return_id=${widget.returnId}'),
          headers: headers,
        );
        print(jsonData);
        if (response.statusCode == 405) {
          final jsonData = json.decode(response.body);
          RemitDetails product = RemitDetails.fromJson(jsonData);

          setState(() {
            rej = product.items!;
          });

          return [product];
        } else {
          setState(() {
            Map<String, dynamic> jsonMap = jsonDecode(response.body);
            String mess = jsonMap['message'];
            print(mess);
            print("failed");
          });
          throw Exception(
              'API request failed with status code ${response.statusCode}');
        }
      } else {
        print('userId is null');
        throw Exception('UserId is null');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch data: $e');
    }
  }

  // List<Item2> ret2 = [];

  // late Future<List<Remitdetails2>> red2Future;

  // Future<List<Remitdetails2>> red2Details() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     int? jsonData = prefs.getInt('jsonData');
  //     if (jsonData != null) {
  //       Map<String, String> headers = {'Content-Type': 'application/json'};

  //       final response = await http.get(
  //         Uri.parse(
  //             'http://gorder.website/API/rider/return-details.php?rider_id=33333&return_id=${widget.returnId}'),
  //         headers: headers,
  //       );
  //       print(
  //           'http://gorder.website/API/rider/return-details.php?rider_id=33333&return_id=${widget.returnId}');

  //       if (response.statusCode == 200) {
  //         final Map<String, dynamic> jsonData = json.decode(response.body);
  //         Remitdetails2 user2 = Remitdetails2.fromMap(jsonData);

  //         print("return: ${widget.returnId}");
  //         setState(() {
  //           ret = [user2.items];
  //         });

  //         return [user2];
  //       } else {
  //         setState(() {
  //           Map<String, dynamic> jsonMap = jsonDecode(response.body);
  //           String mess = jsonMap['message'];

  //           print(mess);
  //           print("failed");
  //         });
  //         throw Exception('Failed to load data');
  //       }
  //     } else {
  //       print('jsonData is null'); // Updated log message
  //       throw Exception('jsonData is null'); // Updated error message
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Failed to load data');
  //   }
  // }

  Future scan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? jsonData = prefs.getInt('jsonData');
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final body =
        jsonEncode({'rider_id': jsonData, 'return_id': rtn.text.trim()});

    http.Response response = await http.post(
      Uri.parse('https://gorder.website/API/rider/accept-return.php'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      showDialog1();
    } else {
      // TODO: showAlertDialog
      showAlertDialog();
    }
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancellation Unsuccessful"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: ((context) => const ReturnDetails()),
                  ),
                );
              },
              child: const Text('Back'))
        ],
      ),
    );
  }

  void showDialog1() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Successful"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: ((context) => const ReturnDetails()),
                  ),
                );
              },
              child: const Text('Back'))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    rejectedFuture = ToReject();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Return"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // You can use any icon you like
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: ((context) => const DetailsScreen()),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await ToReject();
          },
        ),
        body: Column(
          children: [
            // Other widgets before your ListView.builder if needed
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: rej.length,
                itemBuilder: (context, index) {
                  final l = rej[index];
                  return Card(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: ((context) => const Return()),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(l.productName ?? ""),
                        // subtitle: Text("+63${l.contactNo}"),
                      ),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: rej.length,
                itemBuilder: (context, index) {
                  final l = rej[index];
                  return Card(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: ((context) => const Return()),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(l.expirationDate ?? ""),
                        // trailing: Text("₱${l.returnAmount}"),
                        // subtitle: Text(l.address ?? ""),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(child: Text("")),
            ),
            Expanded(
              flex: 1,
              child: Container(child: Text("")),
            ),
            Expanded(
              flex: 1,
              child: Container(child: Text("")),
            ),
            Expanded(
              flex: 1,
              child: Container(child: Text("")),
            ),
            Expanded(child: Container(child: Center(child: Text("")))),
            TextField(
              controller: rtn,
              decoration: InputDecoration(
                  hintText: "Type the Transaction Id Here",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: (() {
                      rtn.clear();
                    }),
                    icon: Icon(Icons.clear),
                  )),
            ),
            MaterialButton(
              onPressed: () async {
                await scan();
              },
              color: Colors.blue,
              child: Text("send"),
            )

            // Other widgets after your ListView.builder if needed
          ],
        ));
  }
}
