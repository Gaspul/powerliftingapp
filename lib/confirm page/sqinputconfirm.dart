import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:powerliftingapp/result%20page/outputsq.dart';

class SQInputConfirm extends StatefulWidget {

  final String videoPath;

  const SQInputConfirm({super.key, required this.videoPath});

  @override
  _SQInputConfirmState createState() => _SQInputConfirmState();
}

class _SQInputConfirmState extends State<SQInputConfirm> {

  late VideoPlayerController _controller;
  bool _isVideoReady = false;
  final String serverUrl = 'http://10.10.202.176:44000/process_squat';

  void _processFrame(File frameFile) async {

    var bytes = await frameFile.readAsBytes();
    var base64Video = base64Encode(bytes);
    
    // Create an http.Client with a custom Timeout setting
    var client = http.Client();
    var timeoutDuration = Duration(seconds: 240);

    try {
      var response = await http.post( 
        Uri.parse(serverUrl),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          "Connection": "Keep-Alive",
          "Keep-Alive": "timeout=5, max=1000",
        }, // Set the content type as JSON
        body: jsonEncode({'frame': base64Video}),
      ).timeout(timeoutDuration);
      // Success case: Print the status code
      print('HTTP Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Print the response body for debugging
        print('Response Body: $data');

        // Check if 'processed_video' key exists and its value is not null
        if (data.containsKey('processed_video') && data['processed_video'] != null) {
          var processedVideoBase64 = data['processed_video'] as String;
          var processedVideoBytes = base64Decode(processedVideoBase64);

          // Display the processed video in a new page (GrayscaleVideoPage)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SquatOutput(videoBytes: processedVideoBytes),
            ),
          );
        }else {
          // Handle the case when 'processed_video' key is not present or its value is null
          print('Error: ${response.statusCode}');
        }
      } else {
        print('Failed to process the frame: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions that may occur during the HTTP request
      print('Error Message: $e');

      if (e is TimeoutException) {
        // If it's a TimeoutException, print the specific error message
        print('Timeout Exception: ${e.message}');
      }

      // Check if the exception is an http.ClientException
      if (e is http.ClientException) {
        // If it's an http.ClientException, print the specific error message
        print('Client Exception: ${e.message}');
      }
    } finally {
      // Close the client to release resources
      client.close();
    }
  }
  
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {
          _isVideoReady = true;
          _controller.setVolume(1.0); // Set the video volume to maximum (1.0)
          _controller.play(); // Start playing the video
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('PowerAssistant by Angga Syfa Kurniawan'),
      elevation: 15.0,
      ),
      backgroundColor:  Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _isVideoReady
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(),
            ),
            SizedBox(height: 10), // Add some spacing between the video and the button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.grey,
              ),
              onPressed: () {
                _processFrame(File(widget.videoPath));
              },
              child: Text(
                'START DETECTION',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ), 
        ],
        ),
      ),
    );
  }
}