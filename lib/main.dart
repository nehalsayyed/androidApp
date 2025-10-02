import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluid Tabs',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FluidTabBar(),
    );
  }
}

class FluidTabBar extends StatefulWidget {
  const FluidTabBar({super.key});
  @override
  State<FluidTabBar> createState() => _FluidTabBarState();
}

class _FluidTabBarState extends State<FluidTabBar> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _messageCount = 3;

  late final AnimationController _controller;
  late final Animation<double> _animation;

  final List<Widget> _screens = const [
    Center(child: Text('🏠 Home Screen')),
    Center(child: Text('👤 Profile Screen')),
    Center(child: Text('⚙️ Settings Screen')),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.reset();
      _controller.forward();
    });
  }

  Alignment _getBlobAlignment(int index) {
    switch (index) {
      case 0:
        return Alignment.centerLeft;
      case 1:
        return Alignment.center;
      case 2:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }

  Widget _buildBadge(Widget icon, int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Text(
                '$count',
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaleTransition(
        scale: _animation,
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              alignment: _getBlobAlignment(_selectedIndex),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  tooltip: 'Home',
                  onPressed: () => _onItemTapped(0),
                  icon: _buildBadge(const Icon(Icons.home), _messageCount),
                ),
                IconButton(
                  tooltip: 'Profile',
                  onPressed: () => _onItemTapped(1),
                  icon: const Icon(Icons.person),
                ),
                IconButton(
                  tooltip: 'Settings',
                  onPressed: () => _onItemTapped(2),
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}    
