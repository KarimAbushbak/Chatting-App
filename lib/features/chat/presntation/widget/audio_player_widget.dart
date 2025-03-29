import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Uint8List audioData;
  const AudioPlayerWidget({super.key, required this.audioData});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  FlutterSoundPlayer? _player;

  @override
  void initState() {
    super.initState();
    _player = FlutterSoundPlayer()..openPlayer();
  }

  @override
  void dispose() {
    _player?.closePlayer();
    super.dispose();
  }

  void _playAudio() async {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/temp_play.aac';
    await File(filePath).writeAsBytes(widget.audioData);

    await _player!.startPlayer(
      fromURI: filePath,
      codec: Codec.aacADTS,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.play_arrow),
      onPressed: _playAudio,
    );
  }
}
