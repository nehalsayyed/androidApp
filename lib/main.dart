import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';

void main() => runApp(TorchApp());

class TorchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torch App',
      theme: ThemeData.dark(),
      home: TorchHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TorchHomePage extends StatefulWidget {
  @override
  _TorchHomePageState createState() => _TorchHomePageState();
}

class _TorchHomePageState extends State<TorchHomePage>
    with SingleTickerProviderStateMixin {
  final controller = TorchController();
  bool isOn = false;
  late AnimationController _animController;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _glow = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  void toggleTorch() {
    if (isOn) {
      controller.turnOff();
      _animController.stop();
    } else {
      controller.turnOn();
      _animController.repeat(reverse: true);
    }
    setState(() => isOn = !isOn);
  }

  @override
  void dispose() {
    _animController.dispose();
    controller.turnOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: toggleTorch,
          child: AnimatedBuilder(
            animation: _glow,
            builder: (context, child) {
              return Transform.scale(
                scale: isOn ? _glow.value : 1.0,
                child: Container(
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOn ? Colors.amber : Colors.grey[800],
                    boxShadow: isOn
                        ? [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.6),
                              blurRadius: 30,
                              spreadRadius: 10,
                            )
                          ]
                        : [],
                  ),
                  child: Icon(
                    isOn ? Icons.flashlight_on : Icons.flashlight_off,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
