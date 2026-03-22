import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() => runApp(const MaterialApp(home: WebRTCTestHome()));

class WebRTCTestHome extends StatefulWidget {
  const WebRTCTestHome({super.key});

  @override
  State<WebRTCTestHome> createState() => _WebRTCTestHomeState();
}

class _WebRTCTestHomeState extends State<WebRTCTestHome> {
  RTCPeerConnection? _peerConnection;
  String _status = "Idle";
  final List<String> _logs = [];

  // 1. Define Google STUN Servers
  final Map<String, dynamic> _iceConfig = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
    ]
  };

  void _log(String message) {
    setState(() => _logs.insert(0, "${DateTime.now().second}s: $message"));
    print(message);
  }

  Future<void> _startTest() async {
    try {
      // 2. Setup Local Audio Stream
      final Map<String, dynamic> constraints = {'audio': true, 'video': false};
      MediaStream localStream = await navigator.mediaDevices.getUserMedia(constraints);
      _log("Local microphone captured.");

      // 3. Create Peer Connection
      _peerConnection = await createPeerConnection(_iceConfig);

      // 4. Listen for Connection State Changes
      _peerConnection!.onConnectionState = (state) {
        _log("Connection State: ${state.name}");
      };

      _peerConnection!.onIceCandidate = (candidate) {
        _log("ICE Candidate Found: ${candidate.candidate?.substring(0, 20)}...");
      };

      // 5. Add track to connection
      localStream.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, localStream);
      });

      // 6. Simulate "Self-Connection" (The Handshake)
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      _log("Offer Created & Set.");

      // In a real app, 'offer' would go to a server. Here, we just loop it back.
      await _peerConnection!.setRemoteDescription(offer);
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      _log("Answer Created & Loopback active.");

    } catch (e) {
      _log("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WebRTC Single-Device Test")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _startTest,
              child: const Text("Run STUN & Connection Test"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, i) => ListTile(title: Text(_logs[i])),
            ),
          ),
        ],
      ),
    );
  }
}
