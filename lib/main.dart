import 'package:flutter/material.dart';

// --- Color and Styling Constants ---

const Color kPrimaryYellow = Color(0xFFFFC000); 
const Color kDarkBrown = Color(0xFF332A20); 
const Color kLightGrey = Color(0xFFE0E0E0); 

const TextStyle kTitleStyle = TextStyle(
  color: kDarkBrown,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const TextStyle kLabelStyle = TextStyle(
  color: kDarkBrown,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const TextStyle kPriceStyle = TextStyle(
  color: kDarkBrown,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

// --- Main Application Widget ---

void main() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping UI Clone',
      theme: ThemeData(
        primaryColor: kPrimaryYellow,
        scaffoldBackgroundColor: kPrimaryYellow,
        colorScheme: const ColorScheme.light(
          primary: kPrimaryYellow,
          onPrimary: kDarkBrown,
          secondary: kDarkBrown,
          surface: kPrimaryYellow,
          onSurface: kDarkBrown,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// --- Home Screen Widget (Now Stateful) ---

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State for the selected category
  String _selectedCategory = 'All';
  // State for the active bottom navigation bar index
  int _currentIndex = 0;

  // Function to handle category selection
  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    // Add simple feedback when a category is selected
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected category: $category'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  // Function to handle bottom navigation bar taps
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Add simple feedback for tab change
    List<String> tabs = ['Home', 'Explore', 'Basket', 'Profile'];
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigated to: ${tabs[index]}'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 1. Custom App Bar/Header Section
              const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
                child: CustomAppBar(),
              ),
              
              // 2. Wallet and Coins Summary Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: WalletCoinsSummary(),
              ),

              const SizedBox(height: 15.0),

              // 3. Category Section Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Category', style: kTitleStyle),
                    const Icon(Icons.sort, color: kDarkBrown),
                  ],
                ),
              ),

              // 4. Category Grid (Pass callback and state)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CategoryGrid(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: _selectCategory,
                ),
              ),

              // 5. Recommended Section Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recommended', style: kTitleStyle),
                    const Icon(Icons.sort, color: kDarkBrown),
                  ],
                ),
              ),

              // 6. Recommended Products List (Horizontal Scroll)
              const SizedBox(height: 15.0),
              const RecommendedProductsList(),

              // A tall dark section at the bottom to match the design's footer
              const SizedBox(height: 15.0), 
              Container(
                height: 120, 
                color: kDarkBrown,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
      // 7. Custom Bottom Navigation Bar (Pass callback and state)
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// --- Component: Custom App Bar (Added simple tap functionality) ---

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // Logo tap functionality
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logo tapped!')),
            );
          },
          child: const Icon(
            Icons.flutter_dash, 
            color: kDarkBrown,
            size: 30,
          ),
        ),
        const SizedBox(width: 10),
        
        // Search Bar (Added simple function to search icon)
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: kPrimaryYellow, 
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kDarkBrown.withOpacity(0.5), width: 1.0),
            ),
            child: TextField(
              onTap: () {
                // Simulate focus/search initiation
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Search bar focused...'), duration: Duration(milliseconds: 500)),
                );
              },
              decoration: InputDecoration(
                hintText: 'Search here...',
                hintStyle: const TextStyle(color: kDarkBrown),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                prefixIcon: const Icon(Icons.search, color: kDarkBrown),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic, color: kDarkBrown),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Voice search activated!'), duration: Duration(milliseconds: 500)),
                    );
                  },
                ), 
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Profile Picture Placeholder tap functionality
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile button tapped!')),
            );
          },
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: kDarkBrown,
            child: Icon(Icons.person, color: kLightGrey, size: 20), 
          ),
        ),
      ],
    );
  }
}

// --- Component: Wallet and Coins Summary (Added tap functionality) ---

class WalletCoinsSummary extends StatelessWidget {
  const WalletCoinsSummary({super.key});

  void _showWalletAction(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action tapped!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: kDarkBrown,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // My Wallet Section - Made clickable
          Expanded(
            child: GestureDetector(
              onTap: () => _showWalletAction(context, 'Wallet'),
              child: const SummaryItem(
                icon: Icons.account_balance_wallet,
                label: 'My Wallet',
                value: '\$350',
              ),
            ),
          ),
          
          const SizedBox(
            height: 40,
            child: VerticalDivider(color: Colors.white70, thickness: 1),
          ),

          // My Coins Section - Made clickable
          Expanded(
            child: GestureDetector(
              onTap: () => _showWalletAction(context, 'Coins'),
              child: const SummaryItem(
                icon: Icons.monetization_on,
                label: 'My Coins',
                value: '1234.567',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widget for Wallet/Coins Items (No change needed here)
class SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const SummaryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// --- Component: Category Grid (Functional with state) ---

class CategoryGrid extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryGrid({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<Map<String, dynamic>> categories = const [
    {'label': 'All', 'icon': Icons.track_changes},
    {'label': 'Fashion', 'icon': Icons.checkroom},
    {'label': 'Electronic', 'icon': Icons.tv},
    {'label': 'Game', 'icon': Icons.gamepad},
    {'label': 'Music', 'icon': Icons.headphones},
    {'label': 'Furniture', 'icon': Icons.chair},
    {'label': 'Food', 'icon': Icons.fastfood},
    {'label': 'Other', 'icon': Icons.more_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(), 
      crossAxisCount: 4, 
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      childAspectRatio: 0.8, 
      children: categories.map((category) {
        final label = category['label'] as String;
        return CategoryItem(
          label: label,
          icon: category['icon'],
          isSelected: selectedCategory == label,
          onTap: () => onCategorySelected(label),
        );
      }).toList(),
    );
  }
}

// Helper Widget for Category Items (Updated to handle selection state and tap)
class CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell( // Use InkWell for better visual feedback on tap
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          // The icon background square 
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: isSelected ? kPrimaryYellow : kDarkBrown, // Color changes based on selection
              borderRadius: BorderRadius.circular(10), 
              border: isSelected ? Border.all(color: kDarkBrown, width: 2.0) : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? kDarkBrown : kPrimaryYellow, // Icon color changes
              size: 30,
            ),
          ),
          const SizedBox(height: 5),
          // The category label text
          Text(
            label,
            style: kLabelStyle.copyWith(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// --- Component: Recommended Products List (Added tap functionality) ---

class RecommendedProductsList extends StatelessWidget {
  const RecommendedProductsList({super.key});

  final List<Map<String, dynamic>> products = const [
    {'name': 'T Shirts', 'price': 10, 'color': kDarkBrown},
    {'name': 'Trousers', 'price': 15, 'color': kDarkBrown},
    {'name': 'Bag', 'price': 25, 'color': kDarkBrown},
    {'name': 'Monitor', 'price': 300, 'color': kDarkBrown},
    {'name': 'Table', 'price': 90, 'color': kDarkBrown},
    {'name': 'Dish', 'price': 12, 'color': kDarkBrown},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: index == products.length - 1 ? 16.0 : 0, 
            ),
            child: ProductCard(
              name: products[index]['name'],
              price: products[index]['price'],
              color: products[index]['color'],
              imageIndex: index,
              // Add a simple tap handler
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${products[index]['name']} tapped! Adding to cart...'), duration: const Duration(milliseconds: 700)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Helper Widget for Product Card (Updated to include tap functionality)
class ProductCard extends StatelessWidget {
  final String name;
  final int price;
  final Color color;
  final int imageIndex;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.color,
    required this.imageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Use GestureDetector for the whole card tap
      onTap: onTap,
      child: SizedBox(
        width: 120, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Placeholder for the Product Image
            AspectRatio(
              aspectRatio: 1, 
              child: Container(
                decoration: BoxDecoration(
                  color: kLightGrey, 
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    [Icons.person, Icons.grass, Icons.work, Icons.monitor, Icons.weekend, Icons.restaurant][imageIndex % 6],
                    color: color,
                    size: 50,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            
            // Product Name
            Text(
              name,
              style: kLabelStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Product Price
            Text(
              '\$$price',
              style: kPriceStyle,
            ),
          ],
        ),
      ),
    );
  }
}

// --- Component: Custom Bottom Navigation Bar (Functional with state) ---

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, 
      decoration: const BoxDecoration(
        color: kDarkBrown, 
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Home Item
          NavBarItem(
            icon: Icons.home_filled,
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          // Explore Item
          NavBarItem(
            icon: Icons.explore,
            label: 'Explore',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          // Basket Item
          NavBarItem(
            icon: Icons.shopping_basket,
            label: 'Basket',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          // Profile Item
          NavBarItem(
            icon: Icons.person,
            label: 'Profile',
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

// Helper Widget for Navigation Bar Item (Updated to include tap functionality)
class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color itemColor = isSelected ? kPrimaryYellow : Colors.white70;

    return InkWell( // Use InkWell for better tap response
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: itemColor,
            size: 24,
          ),
          Text(
            label,
            style: TextStyle(
              color: itemColor,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
