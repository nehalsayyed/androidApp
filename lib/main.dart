import 'package:flutter/material.dart';
import 'package:flashlight/flashlight.dart';

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
  bool isOn = false;
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void toggleTorch() async {
    if (isOn) {
      await Flashlight.lightOff();
      _controller.stop();
    } else {
      await Flashlight.lightOn();
      _controller.repeat(reverse: true);
    }
    setState(() => isOn = !isOn);
  }

  @override
  void dispose() {
    _controller.dispose();
    Flashlight.lightOff();
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
            animation: _glowAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isOn ? _glowAnimation.value : 1.0,
                child: Container(
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOn ? Colors.yellowAccent : Colors.grey[800],
                    boxShadow: isOn
                        ? [
                            BoxShadow(
                              color: Colors.yellowAccent.withOpacity(0.6),
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
