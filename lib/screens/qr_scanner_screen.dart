import 'dart:convert';

import 'package:delivery_app/models/ordet_model.dart';
import 'package:delivery_app/models/remit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/details3.dart';
import '../models/orderdetails_model.dart';
import '../models/user_model.dart';
import 'deliverydetails_screen.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  var getResult = 'QR Code Result';
  String _scanBarcode = 'Unknown';

  late TextEditingController scanFieldController;
  List<Redd> pro = [];
  late Future<List<Ordet>> ordetfuture;

  Future<List<Ordet>> orderT() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? jsonData = prefs.getInt('jsonData');
      if (jsonData != null) {
        Map<String, String> headers = {'Content-Type': 'application/json'};

        final response = await http.get(
          Uri.parse(
              'http://gorder.website/API/rider/deliver-details.php?rider_id=33333&order_id=ORD-22083069'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonData = json.decode(response.body);
          Ordet user = Ordet.fromMap(jsonData);

          setState(() {
            pro = [user.orderDetails];
          });

          return [user];
        } else {
          setState(() {
            Map<String, dynamic> jsonMap = jsonDecode(response.body);
            String mess = jsonMap['message'];

            print(mess);
            print("failed");
          });
          return []; // Return an empty list to indicate failure
        }
      } else {
        print('jsonData is null'); // Updated log message
        return []; // Return an empty list to indicate failure
      }
    } catch (e) {
      print('Error: $e');
      return []; // Return an empty list to indicate failure
    }
  }

  // Future<List<Ordet>> ordetDetails() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     int? jsonData = prefs.getInt('jsonData');
  //     if (jsonData != null) {
  //       Map<String, String> headers = {'Content-Type': 'application/json'};

  //       final response = await http.get(
  //         Uri.parse(
  //             'http://gorder.website/API/rider/deliver-details.php?rider_id=33333&order_id=ORD-82152192'),
  //         headers: headers,
  //       );
  //       print(
  //           'http://gorder.website/API/rider/deliver-details.php?rider_id=33333&order_id=ORD-82152192');

  //       if (response.statusCode == 200) {
  //         final jsonData = json.decode(response.body);
  //         final Map<String, dynamic> responseMap = json.decode(response.body);
  //         Ordet user = Ordet.fromMap(jsonData);
  //         final responseData = json.encode(response.body);

  //         setState(() {
  //           orgy = [user.orderDetails];
  //         });

  //         return [user];
  //       } else {
  //         setState(() {
  //           Map<String, dynamic> jsonMap = jsonDecode(response.body);
  //           String mess = jsonMap['message'];

  //           print("failed");
  //         });
  //         throw Exception('anatawa');
  //       }
  //     } else {
  //       print('userId is null');
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Failed to load data');
  //   }
  // }

  Future<bool> scan(String string) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? jsonData = prefs.getInt('jsonData');
      Map<String, String> headers = {'Content-Type': 'application/json'};
      final msg = jsonEncode({
        "transaction_id": scanFieldController.text.trim(),
        "rider_id": jsonData,
      });

      http.Response response = await http.post(
        Uri.parse('https://gorder.website/API/rider/scan-qr.php'),
        headers: headers,
        body: msg,
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        UserId userId = UserId.fromJson(responseData);
        showDialog1();
        return false;
      } else {
        showAlertDialog();
        print('failed');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
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
                    builder: ((context) => const DetailsScreen()),
                  ),
                );
              },
              child: const Text('Back'))
        ],
      ),
    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancellation Unsuccessful"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ordetfuture = orderT();
    scanFieldController = TextEditingController(text: _scanBarcode);
  }

  Future<void> _fetchData() async {
    await fetchDetails();
  }

  @override
  void dispose() {
    scanFieldController.dispose();
    super.dispose();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);

      if (barcodeScanRes != null && barcodeScanRes.isNotEmpty) {
        setState(() {
          _scanBarcode = barcodeScanRes;
          scanFieldController.text = _scanBarcode; // Update the controller
        });
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  bool _isTransactionSuccessful = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('QR Scanner')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: ((context) => const DetailsScreen())));
          },
        ),
      ),
     
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: pro.length,
              itemBuilder: (context, index) {
                final e = pro[index];
                return Card(
                  child: ListTile(
                    leading: Text(e.address ?? ""),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile();
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    scanBarcodeNormal();
                    setState(() {
                      _scanBarcode =
                          '$_scanBarcode'; // Replace with your actual scanned value
                      scanFieldController.text = _scanBarcode;
                    });
                  },
                  child: Text('Scan Barcode'),
                ),
                SizedBox(height: 20.0),
                Text('Scan Result : $_scanBarcode'),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    autofocus: false,
                    controller: scanFieldController, // Set your controller here

                    decoration: InputDecoration(
                      hintText: 'Enter TransactionId',
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50.0,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {
                        await scan(scanFieldController.text.toString());
                        _scanBarcode = scanFieldController.text;

                        setState(() {
                          AlertDialog(
                            title: const Text("Cancellation Unsuccessful"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Back'))
                            ],
                          );
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: ((context) => const DetailsScreen()),
                            ),
                          );
                        });
                      },
                      child: const Center(child: Text("Enter")),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? jsonData = prefs.getInt('jsonData');

    if (jsonData != null) {
      const url =
          'http://gorder.website/API/rider/deliver-details.php?rider_id=33333&order_id=ORD-22083069';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final body = response.body;
      final json = jsonDecode(body);
      final shippedData = json['order_details'];

      if (shippedData != null && shippedData is List) {
        final transformed = shippedData.map<Redd>((e) {
          final transactionId = e["transaction_id"];

          return Redd(
            transactionId: e["transaction_id"],
            orderStatus: e["order_status"],
            custId: e["cust_id"],
            custName: e["cust_name"],
            paymentType: e["payment_type"],
            address: e["address"],
            total: e["total"],
            products: e["products"],
          );
        }).toList();

        setState(() {
          pro = transformed;
        });
      } else {
        print('Invalid data format for shipped orders');
        setState(() {
          pro = [];
        });
      }
    } else {
      print('jsonData is null');
      setState(() {
        pro = [];
      });
    }
  }
}
