import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptoutils/cryptoutils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class VlcPlayerController {
  MethodChannel _channel;
  bool hasClients = false;
  VoidCallback _onInit;
  List<VoidCallback> _eventHandlers;

  VlcPlayerController(
      {

      /// This is a callback that will be executed once the platform view has been initialized.
      /// If you want the media to play as soon as the platform view has initialized, you could just call
      /// [VlcPlayerController.play] in this callback. (see the example)
      VoidCallback onInit}) {
    _onInit = onInit;
    _eventHandlers = new List();
  }

  initView(int id) {
    _channel = MethodChannel("flutter_video_plugin/getVideoView_$id");
    hasClients = true;
  }

  Future<String> setStreamUrl(
      String url, int defaultHeight, int defaultWidth) async {
    var result = await _channel.invokeMethod("playVideo", {
      'url': url,
    });
    print("ASPECT RATIO: ${result['aspectRatio']}");
    return result['aspectRatio'];
  }

  Future<Uint8List> makeSnapshot() async {
    var result = await _channel.invokeMethod("getSnapshot");
    var base64String = result['snapshot'];
    Uint8List imageBytes = CryptoUtils.base64StringToBytes(base64String);
    return imageBytes;
  }

  void dispose() {
    if (Platform.isIOS) {
      _channel.invokeMethod("dispose");
    } else if (Platform.isAndroid) {
      _channel.invokeMethod("dispose");
    }
  }

  void start() {
    if (Platform.isIOS) {
      _channel.invokeMethod("start");
    } else if (Platform.isAndroid) {
      _channel.invokeMethod("start");
    }
  }

  Future<bool> isPlaying() async {
    if (Platform.isIOS) {
      var result = await _channel.invokeMethod("isPlaying");
      return result['isPlaying'];
    } else if (Platform.isAndroid) {
      var result = await _channel.invokeMethod("isPlaying");
      return result['isPlaying'];
    }
  }

  Future<double> position() async {
    var result = await _channel.invokeMethod("position");
    return result['position'];
  }

  void setPosition(double position) {
    _channel.invokeMethod("setPosition", {
      'position': position,
    });
  }

  void pause() {
    if (Platform.isIOS) {
      _channel.invokeMethod("pause");
    } else if (Platform.isAndroid) {
      _channel.invokeMethod("pause");
    }
  }
}
