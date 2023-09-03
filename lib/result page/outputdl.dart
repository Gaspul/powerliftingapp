import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';


class DeadliftOutput extends StatefulWidget {
  final Uint8List videoBytes;

  DeadliftOutput({required this.videoBytes});

  @override
  State<DeadliftOutput> createState() => _DeadliftOutputState();
}

class _DeadliftOutputState extends State<DeadliftOutput> {
  
  late VideoPlayerController _controller;
  late File _videoFile;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    // Create a temporary video file to play the video
    _videoFile = await _createTemporaryVideoFile();

    // Create the VideoPlayerController and load the video from the temporary file
    _controller = VideoPlayerController.file(_videoFile);

    // Initialize the controller and load the video
    await _controller.initialize();
    _controller.play(); // Play the video automatically
  }

  Future<File> _createTemporaryVideoFile() async {
    // Create a temporary directory
    Directory tempDir = await Directory.systemTemp.createTemp();
    String tempPath = tempDir.path;
    // Generate a unique filename for the temporary video file
    String tempVideoPath = '$tempPath/${DateTime.now().millisecondsSinceEpoch}.mp4';
    // Write the Uint8List data to the temporary video file
    await File(tempVideoPath).writeAsBytes(widget.videoBytes);
    return File(tempVideoPath);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the page is disposed
    _videoFile.deleteSync(); // Delete the temporary file when the page is disposed
    super.dispose();
  }

  Future<void> _downloadVideo() async {
    try {
      // Get the app's documents directory
      var appDocumentsDirectory = await getApplicationDocumentsDirectory();

      // Save the video to a file in the app's documents directory
      File videoFile = File('${appDocumentsDirectory.path}/processed_video.mp4');
      await videoFile.writeAsBytes(widget.videoBytes);

      // Show a download success message or navigate to a success page
      print('Video downloaded successfully!');
    } catch (e) {
      // Handle errors during download
      print('Error downloading video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PowerAssistant by Angga Syfa Kurniawan'),
        elevation: 15.0,
      ),
      backgroundColor:  Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<void>(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Display the video player once it's initialized
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                // Show a loading spinner while the video player is initializing
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Play the video when the floating action button is pressed
          _controller.play();
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}