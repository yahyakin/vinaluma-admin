import 'package:flutter/material.dart';
import 'package:vinaluma_admin/responsive.dart';
import 'package:vinaluma_admin/screens/dashboard/dashboard_screen.dart';
import 'package:vinaluma_admin/screens/products/products_screen.dart';
import 'package:vinaluma_admin/screens/orders/orders_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _getScreen() {
    switch (_selectedIndex) {
      case 0: return const DashboardScreen();
      case 1: return const ProductsScreen();
      case 3: return const OrdersScreen();
      default: return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction_rounded, size: 64, color: Colors.white38),
            const SizedBox(height: 16),
            Text('Bu modül yakında eklenecek', style: TextStyle(color: Colors.white54, fontSize: 16)),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(
        selectedIndex: _selectedIndex,
        onItemSelected: (i) {
          setState(() => _selectedIndex = i);
          if (!Responsive.isDesktop(context)) Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              SizedBox(
                width: 250,
                child: SideMenu(
                  selectedIndex: _selectedIndex,
                  onItemSelected: (i) => setState(() => _selectedIndex = i),
                ),
              ),
            Expanded(
              child: Column(
                children: [
                  // Top bar
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1A3A),
                      border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
                    ),
                    child: Row(
                      children: [
                        if (!Responsive.isDesktop(context))
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white70),
                            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                          ),
                        const Spacer(),
                        const Icon(Icons.notifications_outlined, color: Colors.white54),
                        const SizedBox(width: 16),
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(child: _getScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
