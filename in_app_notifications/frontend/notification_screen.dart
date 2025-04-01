
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationScreen extends StatefulWidget {
  final int userId;
  NotificationScreen({required this.userId});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final res = await http.get(Uri.parse('http://10.0.2.2:8000/api/notifications/user/\${widget.userId}'));
    if (res.statusCode == 200) {
      setState(() {
        notifications = json.decode(res.body);
      });
    }
  }

  Widget buildNotificationCard(dynamic note) {
    return Card(
      child: ListTile(
        title: Text(note['message']),
        subtitle: Text("Received: " + note['created_at'].toString().split('T')[0]),
        trailing: Icon(Icons.notifications, color: note['is_read'] ? Colors.grey : Colors.teal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Notifications")),
      body: notifications.isEmpty
          ? Center(child: Text("No notifications found"))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (_, index) => buildNotificationCard(notifications[index]),
            ),
    );
  }
}
