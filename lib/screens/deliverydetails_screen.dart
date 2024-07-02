import 'dart:async';
import 'dart:convert';

import 'package:delivery_app/models/details2_model.dart';
import 'package:delivery_app/models/return.dart';
import 'package:delivery_app/screens/detailsscreen.dart';
import 'package:delivery_app/screens/orderdetails.dart';
import 'package:delivery_app/screens/qr_scanner_screen.dart';
import 'package:delivery_app/screens/return.dart';
import 'package:delivery_app/screens/riderProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/details3.dart';
import '../models/details_model.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Order> orders = [];
  List<Shipped> shipped = [];
  List<Done> done = [];
  List<Datum> datum = [];
  late Timer _timer;
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
    _tabController = TabController(length: 4, vsync: this);
    _fetchData(); // Fetch initial data
    _timer = Timer.periodic(Duration(seconds: 3), (_) {
      _fetchData(); // Fetch data every 3 seconds
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    await fetchOrder();
    await fetchShipped();
    await fetchDelivered();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchData(); // Manually fetch data
        },
        child: Icon(Icons.refresh),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 25, 24, 24),
        title: Text('Orders'),
        leading: IconButton(
          icon: Icon(Icons.account_circle), // You can use any icon you like
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: ((context) => const Profile()),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Material(
            child: Container(
              height: 55,
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                physics: const ClampingScrollPhysics(),
                unselectedLabelColor: Colors.amber,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.amber,
                ),
                tabs: [
                  Tab(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "For Delivery",
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Shipped"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Delivered"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Return"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrderTab(),
                  _buildShippedTab(),
                  _buildDoneTab(),
                  Return()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTab() {
    if (orders.isEmpty) {
      return Center(
        child: Text("Please wait for your Delivery"),
      );
    } else if (orders.isNotEmpty) {
      return ListView.separated(
        itemCount: orders.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (context, index) {
          final e = orders[index];
          return Card(
            child: ListTile(
              onTap: () {
                _tabController.animateTo(1);
              },
              title: Text(
                e.custName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(e.address),
              trailing: const Icon(Icons.arrow_right),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text('No orders available.'),
      );
    }
  }

  Widget _buildShippedTab() {
    if (shipped.isEmpty) {
      return Center(
        child: Text("Please wait for your Delivery"),
      );
    } else if (shipped.isNotEmpty) {
      return ListView.separated(
        itemCount: shipped.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (context, index) {
          final l = shipped[index];
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: ((context) => const QrScreen()),
                  ),
                );
              },
              title: Text(l.custName),
              subtitle: Text(l.address),
              trailing: const Icon(Icons.arrow_right),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text('No shipped orders available.'),
      );
    }
  }

  Widget _buildDoneTab() {
    if (done.isEmpty) {
      return Center(
        child: Text("Please wait for your delivery"),
      );
    } else if (done.isNotEmpty) {
      return ListView.separated(
        itemCount: done.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (context, index) {
          final f = done[index];
          return Card(
            child: ListTile(
              onTap: () {},
              title: Text(f.custName),
              subtitle: Text(f.address),
              trailing: Text(f.orderStatus),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text('No shipped orders available.'),
      );
    }
  }

  Widget _returnTab() {
    if (datum.isEmpty) {
      return Center(
        child: Text("Please wait for your Delivery"),
      );
    } else if (datum.isNotEmpty) {
      return ListView.separated(
        itemCount: orders.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (context, index) {
          final e = datum[index];
          return Card(
            child: ListTile(
              title: Text("Transaction ID: ${e.transactionId}"),
              trailing: Icon(Icons.arrow_right),
              subtitle: Text("Reason: ${e.returnReason}"),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text('No orders available.'),
      );
    }
  }

  Future<void> fetchOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? jsonData = prefs.getInt('jsonData');

    if (jsonData != null) {
      final url =
          'http://gorder.website/API/rider/to-deliver.php?id=$jsonData&status=For-Delivery';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final body = response.body;
      final json = jsonDecode(body);
      final ordersData = json['orders'];

      if (ordersData != null && ordersData is List) {
        final transformed = ordersData.map<Order>((l) {
          return Order(
            transactionId: l["transaction_id"],
            orderStatus: l["order_status"],
            custId: l["cust_id"],
            custName: l["cust_name"],
            paymentType: l["payment_type"],
            address: l["address"],
            total: l["total"]?.toDouble(),
          );
        }).toList();

        setState(() {
          orders = transformed;
        });
      } else {
        print('Invalid data format for orders');
        setState(() {
          orders = [];
        });
      }
    } else {
      print('jsonData is null');
      setState(() {
        orders = [];
      });
    }
  }

  String? storedTransactionId;
  Future<void> fetchShipped() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? jsonData = prefs.getInt('jsonData');

    if (jsonData != null) {
      final url =
          'http://gorder.website/API/rider/to-deliver.php?id=$jsonData&status=Shipped';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final body = response.body;
      final json = jsonDecode(body);
      final shippedData = json['orders'];

      if (shippedData != null && shippedData is List) {
        final transformed = shippedData.map<Shipped>((e) {
          final transactionId = e["transaction_id"];
          storedTransactionId = transactionId;
          return Shipped(
            transactionId: e["transaction_id"],
            orderStatus: e["order_status"],
            custId: e["cust_id"],
            custName: e["cust_name"],
            paymentType: e["payment_type"],
            address: e["address"],
            total: e["total"]?.toDouble(),
          );
        }).toList();

        setState(() {
          shipped = transformed;
        });
      } else {
        print('Invalid data format for shipped orders');
        setState(() {
          shipped = [];
        });
      }
    } else {
      print('jsonData is null');
      setState(() {
        shipped = [];
      });
    }
  }

  Future<void> fetchDelivered() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? jsonData = prefs.getInt('jsonData');

    if (jsonData != null) {
      final url =
          'http://gorder.website/API/rider/to-deliver.php?id=$jsonData&status=Delivered';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final body = response.body;
      final json = jsonDecode(body);
      final shippedData = json['orders'];

      if (shippedData != null && shippedData is List) {
        final transformed = shippedData.map<Done>((c) {
          return Done(
            transactionId: c["transaction_id"],
            orderStatus: c["order_status"],
            custId: c["cust_id"],
            custName: c["cust_name"],
            paymentType: c["payment_type"],
            address: c["address"],
            total: c["total"]?.toDouble(),
          );
        }).toList();

        setState(() {
          done = transformed;
        });
      } else {
        print('Invalid data format for shipped orders');
        setState(() {
          done = [];
        });
      }
    } else {
      print('jsonData is null');
      setState(() {
        shipped = [];
      });
    }
  }
}
