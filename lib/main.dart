import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('todoBox');
  runApp(const MaterialApp(home: SimpleTodo()));
}

class SimpleTodo extends StatefulWidget {
  const SimpleTodo({super.key});

  @override
  State<SimpleTodo> createState() => _SimpleTodoState();
}

class _SimpleTodoState extends State<SimpleTodo> {
  final myBox = Hive.box('todoBox');
  final controller = TextEditingController();
  
  String stunStatus = "Idle";
  List<String> iceInfo = [];

  // This is the "Magic" function that talks to Google STUN
  Future<void> checkStun() async {
    setState(() {
      stunStatus = "Requesting Google STUN...";
      iceInfo.clear();
    });

    // 1. Define the STUN server (Google's public one)
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    // 2. Create a PeerConnection (this triggers the STUN request)
    RTCPeerConnection pc = await createPeerConnection(configuration);

    // 3. Listen for "ICE Candidates" (The response from STUN)
    pc.onIceCandidate = (RTCIceCandidate candidate) {
      if (candidate.candidate != null) {
        setState(() {
          // This string contains your Public IP and Port!
          iceInfo.add("Type: ${candidate.sdpMid} \nData: ${candidate.candidate}");
          stunStatus = "Response Received ✅";
        });
      }
    };

    // 4. Force the handshake to start
    // We create a "Data Channel" and an "Offer" just to make the STUN request fire
    await pc.createDataChannel("signaling", RTCDataChannelInit());
    RTCSessionDescription offer = await pc.createOffer();
    await pc.setLocalDescription(offer);

    // Wait a bit to collect candidates then close
    await Future.delayed(const Duration(seconds: 5));
    await pc.close();
    if(iceInfo.isEmpty) setState(() => stunStatus = "Failed (Check Internet)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive + STUN Tester')),
      body: Column(
        children: [
          // STUN Control Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blueGrey[50],
            child: Column(
              children: [
                Text("STUN Status: $stunStatus", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: checkStun, 
                  child: const Text("Fetch Public IP via STUN")
                ),
              ],
            ),
          ),
          
          // Show STUN/ICE Response
          if (iceInfo.isNotEmpty)
            Container(
              height: 150,
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: iceInfo.map((info) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(info, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
                  ),
                )).toList(),
              ),
            ),
          
          const Divider(),

          // Your Original Hive UI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Store Task in Hive"),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              myBox.add({'task': controller.text, 'done': false});
              controller.clear();
              setState(() {});
            },
            child: const Text('Add Task'),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: myBox.listenable(),
              builder: (context, Box box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final item = box.getAt(index);
                    return ListTile(title: Text(item['task']));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
