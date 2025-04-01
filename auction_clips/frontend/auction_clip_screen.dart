
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class AuctionClipScreen extends StatefulWidget {
  final int userId;
  final bool isSeller;

  AuctionClipScreen({required this.userId, this.isSeller = false});

  @override
  _AuctionClipScreenState createState() => _AuctionClipScreenState();
}

class _AuctionClipScreenState extends State<AuctionClipScreen> {
  List<dynamic> clips = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isSeller) fetchBuyerClips();
  }

  Future<void> fetchBuyerClips() async {
    final res = await http.get(Uri.parse('http://10.0.2.2:8000/api/clips/buyer/\${widget.userId}'));
    if (res.statusCode == 200) {
      setState(() {
        clips = json.decode(res.body);
      });
    }
  }

  Future<void> uploadClip() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null && result.files.single.path != null) {
      final fileBytes = result.files.single.bytes;
      final fileName = result.files.single.name;
      final filePath = result.files.single.path!;
      final uri = Uri.parse("http://10.0.2.2:8000/api/clips/");

      final req = http.MultipartRequest('POST', uri)
        ..fields['auction_id'] = '1'
        ..fields['buyer_id'] = '2'
        ..fields['seller_id'] = widget.userId.toString()
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final response = await req.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Clip uploaded successfully")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload failed")));
      }
    }
  }

  Widget buildClipItem(dynamic clip) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text("Auction ID: \${clip['auction_id']}"),
        subtitle: Text("Uploaded: " + clip['uploaded_at'].toString().split('T')[0]),
        trailing: Icon(Icons.play_circle_outline),
        onTap: () {
          // Could be integrated with video_player package
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Playback coming soon")));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isSeller ? "Upload Auction Clip" : "My Auction Clips")),
      body: widget.isSeller
          ? Center(
              child: ElevatedButton(
                onPressed: uploadClip,
                child: Text("Upload Highlight Clip"),
              ),
            )
          : clips.isEmpty
              ? Center(child: Text("No auction clips available"))
              : ListView.builder(
                  itemCount: clips.length,
                  itemBuilder: (_, index) => buildClipItem(clips[index]),
                ),
    );
  }
}
