
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SellerDashboardScreen extends StatefulWidget {
  final int sellerId;
  SellerDashboardScreen({required this.sellerId});

  @override
  _SellerDashboardScreenState createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/dashboard/seller/\${widget.sellerId}'));

    if (response.statusCode == 200) {
      setState(() {
        dashboardData = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  Widget buildTile(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: TextStyle(fontSize: 16)), Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: Text("Seller Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTile("Active Listings", dashboardData!['active_listings'].toString()),
            buildTile("Sold Listings", dashboardData!['sold_listings'].toString()),
            buildTile("Avg. Item Views", dashboardData!['avg_views'].toString()),
            buildTile("Total Auctions", dashboardData!['auction_stats']['total_auctions'].toString()),
            buildTile("Total Bids Earned", "\$${dashboardData!['auction_stats']['total_bids_earned']}"),
            buildTile("Avg. Rating", dashboardData!['avg_rating'].toString()),
          ],
        ),
      ),
    );
  }
}
