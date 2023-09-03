import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:powerliftingapp/confirm%20page/bpinputconfirm.dart';
import 'package:video_player/video_player.dart';


class BPConfirm extends StatefulWidget {
  const BPConfirm({super.key});

  @override
  State<BPConfirm> createState() => _BPConfirmState();
}

class _BPConfirmState extends State<BPConfirm> {
  bool isVideo = false;

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo(BuildContext context) async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BPInputConfirm(videoPath: pickedFile.path)),
      );
    }
  }

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (kIsWeb) {
        // TODO(gabrielokura): remove the ignore once the following line can migrate to
        // use VideoPlayerController.networkUrl after the issue is resolved.
        // https://github.com/flutter/flutter/issues/121927
        // ignore: deprecated_member_use
        controller = VideoPlayerController.network(file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }
      _controller = controller;
      // In web, most browsers won't honor a programmatic call to .play
      // if the video has a sound track (and is not muted).
      // Mute the video so it auto-plays in web!
      // This is not needed if the call to .play is the result of user
      // interaction (clicking on a "play" button, for example).
      const double volume = kIsWeb ? 0.0 : 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      setState(() {});
    }
  }

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (context.mounted) {
      if (isVideo) {
        final XFile? file = await _picker.pickVideo(
            source: source, maxDuration: const Duration(seconds: 30));
            // Navigator.pushNamed(context, '/videosqconfirm');
            await _playVideo(file);
      }  
    }
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PowerAssistant by Angga Syfa Kurniawan'),
        elevation: 15.0,
      ),
      backgroundColor:  Colors.grey,
      body: Container(
        padding: EdgeInsets.all(30),
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Input your bench press video : ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              'Please, making sure your workout video are met will all conditions below :',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              '1. Only one person in a workout video for better result',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '2. Make sure there is no obstacle or anything that block the person in your workout video',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '3. Make sure the person is 2-4 meters awat from the camera',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '4. It has to be bench press workout video',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.grey,
              ),
              onPressed: () => _pickVideo(context),
              child: Text(
                'INPUT YOUR WORKOUT VIDEO',
                style: TextStyle(
                  color: Colors.white
                ),
                ),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.black,
            //     foregroundColor: Colors.grey,
            //   ),
            //   onPressed: () {},
            //   child: Text(
            //     'Realtime Detection',
            //     style: TextStyle(
            //       color: Colors.white
            //     ),
            //     ),
            // ),
          ],
        ),
      ),
    );
  }
}