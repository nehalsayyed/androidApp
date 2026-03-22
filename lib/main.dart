import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WebRTCFullTest(),
  ));
}

class WebRTCFullTest extends StatefulWidget {
  const WebRTCFullTest({super.key});

  @override
  State<WebRTCFullTest> createState() => _WebRTCFullTestState();
}

class _WebRTCFullTestState extends State<WebRTCFullTest> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final List<String> _logs = [];

  // Configuration for Google STUN Servers
  final Map<String, dynamic> _configuration = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
    ],
    'sdpSemantics': 'unified-plan',
  };

  void _log(String message) {
    setState(() => _logs.insert(0, "${DateTime.now().minute}:${DateTime.now().second}s - $message"));
  }

  Future<void> _initWebRTC() async {
    // 1. Request Microphone Permission
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      _log("❌ Permission Denied. Check AndroidManifest.xml");
      return;
    }

    try {
      _log("🚀 Starting WebRTC Test...");

      // 2. Get User Media (Audio Only)
      final Map<String, dynamic> mediaConstraints = {
        'audio': true,
        'video': false,
      };
      
      _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _log("✅ Microphone Accessed");

      // 3. Create Peer Connection
      _peerConnection = await createPeerConnection(_configuration);

      // 4. Setup Listeners
      _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        _log("📡 ICE Candidate Found: ${candidate.candidate?.split(' ')[4]}");
      };

      _peerConnection!.onConnectionState = (RTCPeerConnectionState state) {
        _log("🔗 Connection State: ${state.name.toUpperCase()}");
      };

      // 5. Add local stream to connection
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });

      // 6. Create Offer (The handshake start)
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      _log("📝 Offer Created & Set Locally");

      // 7. Loopback: Set Remote Description as the same Offer
      // In a real app, this 'offer' would be sent to another device via a server
      await _peerConnection!.setRemoteDescription(offer);
      
      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      _log("🤝 Loopback Answer Set Successfully");

    } catch (e) {
      _log("⚠️ Error: $e");
    }
  }

  @override
  void dispose() {
    _localStream?.dispose();
    _peerConnection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("WebRTC Voice Test"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: _initWebRTC,
              icon: const Icon(Icons.play_arrow),
              label: const Text("Initialize & Connect"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
          const Divider(height: 40),
          const Text("Event Logs", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(_logs[i], style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
