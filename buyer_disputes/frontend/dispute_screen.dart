
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DisputeScreen extends StatefulWidget {
  final int buyerId;
  final int listingId;
  final int sellerId;

  DisputeScreen({required this.buyerId, required this.sellerId, required this.listingId});

  @override
  _DisputeScreenState createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  final TextEditingController _issueController = TextEditingController();
  bool submitted = false;
  List<dynamic> previousDisputes = [];

  @override
  void initState() {
    super.initState();
    fetchPreviousDisputes();
  }

  Future<void> fetchPreviousDisputes() async {
    final res = await http.get(Uri.parse('http://10.0.2.2:8000/api/disputes/user/\${widget.buyerId}'));
    if (res.statusCode == 200) {
      setState(() {
        previousDisputes = json.decode(res.body);
      });
    }
  }

  Future<void> submitDispute() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/disputes/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'buyer_id': widget.buyerId,
        'seller_id': widget.sellerId,
        'listing_id': widget.listingId,
        'issue': _issueController.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        submitted = true;
      });
      fetchPreviousDisputes();
    }
  }

  Widget buildDisputeCard(dynamic dispute) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text("Listing ID: \${dispute['listing_id']}"),
        subtitle: Text(dispute['issue']),
        trailing: Text(dispute['created_at'].toString().split('T')[0]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dispute Center")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Submit a New Dispute", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _issueController,
              decoration: InputDecoration(labelText: "Describe the issue"),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: submitDispute,
              child: Text("Submit Dispute"),
            ),
            SizedBox(height: 20),
            Text("Your Previous Disputes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: previousDisputes.length,
                itemBuilder: (_, index) => buildDisputeCard(previousDisputes[index]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
