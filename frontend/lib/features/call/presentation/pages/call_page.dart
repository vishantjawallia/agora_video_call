import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CallPage extends StatefulWidget {
  final String channelName;
  final String token;
  final bool isIncoming;

  const CallPage({
    super.key,
    required this.channelName,
    required this.token,
    required this.isIncoming,
  });

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _isMuted = false;
  bool _isCameraOff = false;

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    try {
      // Request permissions
      await [Permission.microphone, Permission.camera].request();

      // Create RTC Engine
      _engine = createAgoraRtcEngine();
      await _engine.initialize(const RtcEngineContext(
        appId: "8d22cb493d054b3794615e4e85d70544", // Replace with your Agora App ID
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      // Enable video
      await _engine.enableVideo();
      await _engine.startPreview();
      await _engine.setChannelProfile(
        ChannelProfileType.channelProfileCommunication,
      );

      // Set up event handlers
      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            setState(() {
              _localUserJoined = true;
            });
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            setState(() {
              _remoteUid = remoteUid;
            });
          },
          onUserOffline: (connection, remoteUid, reason) {
            setState(() {
              _remoteUid = null;
            });
          },
          onError: (err, msg) {
            print('Agora error: $err, $msg');
          },
        ),
      );

      // Join channel
      await _engine.joinChannel(
        token: widget.token,
        channelId: widget.channelName,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      print('Error initializing Agora: $e');
      // Handle initialization error appropriately
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize camera: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Stop preview and disable video before leaving channel
    _engine.stopPreview();
    _engine.disableVideo();

    // Leave channel and release engine
    _engine.leaveChannel();
    _engine.release();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Remote video
          Center(
            child: _remoteVideo(),
          ),
          // Local video
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 100,
              height: 150,
              color: const Color.fromARGB(255, 146, 124, 124).withOpacity(0.2),
              margin: const EdgeInsets.all(16),
              child: _localUserJoined
                  ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    )
                  : Center(child: const CircularProgressIndicator()),
            ),
          ),
          // Controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    onPressed: _onToggleMute,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                    fillColor: _isMuted ? Colors.red : Colors.white,
                    child: Icon(
                      _isMuted ? Icons.mic_off : Icons.mic,
                      color: _isMuted ? Colors.white : Colors.black,
                      size: 20,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () => Navigator.pop(context),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                    fillColor: Colors.red,
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: _onToggleCamera,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                    fillColor: _isCameraOff ? Colors.red : Colors.white,
                    child: Icon(
                      _isCameraOff ? Icons.videocam_off : Icons.videocam,
                      color: _isCameraOff ? Colors.white : Colors.black,
                      size: 20,
                    ),
                  ),
                  // 🔄 Switch camera (front/back)
                  RawMaterialButton(
                    onPressed: _switchCamera,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                    fillColor: Colors.white,
                    child: const Icon(
                      Icons.cameraswitch,
                      color: Colors.black,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _switchCamera() async {
    await _engine.switchCamera();
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return const Text(
        'Waiting for remote user to join...',
        textAlign: TextAlign.center,
      );
    }
  }

  void _onToggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine.muteLocalAudioStream(_isMuted);
  }

  void _onToggleCamera() {
    setState(() {
      _isCameraOff = !_isCameraOff;
    });
    _engine.muteLocalVideoStream(_isCameraOff);
  }
}
