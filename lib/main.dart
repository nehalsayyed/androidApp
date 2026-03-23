import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(const DeviceInfoApp());
}

class DeviceInfoApp extends StatelessWidget {
  const DeviceInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const DeviceInfoScreen(),
    );
  }
}

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _initDeviceData();
  }

  Future<void> _initDeviceData() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else {
        deviceData = {'Error': 'This script is optimized for Android.'};
      }
    } catch (e) {
      deviceData = {'Error': 'Failed to get platform version.'};
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'Brand': build.brand,
      'Model': build.model,
      'Manufacturer': build.manufacturer,
      'Android Version': build.version.release,
      'SDK Int': build.version.sdkInt,
      'Hardware': build.hardware,
      'Board': build.board,
      'Device': build.device,
      'Product': build.product,
      'Display': build.display,
      'Host': build.host,
      'ID': build.id,
      'Fingerprint': build.fingerprint,
      'Supported ABIs': build.supportedAbis,
      'Is Physical Device': build.isPhysicalDevice,
      'Security Patch': build.version.securityPatch,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Android Device Info'),
        elevation: 4,
      ),
      body: _deviceData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: _deviceData.keys.map((String property) {
                return Card(
                  child: ListTile(
                    title: Text(property, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${_deviceData[property]}'),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
