import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinaluma_admin/services/api_service.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SideMenu({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1B4B),
      child: Column(
        children: [
          // Logo
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF4338CA)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('V', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(width: 12),
                const Text('Vinaluma', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _MenuSection(title: 'GENEL'),
                _MenuItem(icon: Icons.dashboard_rounded, title: 'Panel', index: 0, selected: selectedIndex, onTap: onItemSelected),

                const SizedBox(height: 8),
                _MenuSection(title: 'ÜRÜN YÖNETİMİ'),
                _MenuItem(icon: Icons.inventory_2_rounded, title: 'Ürünler', index: 1, selected: selectedIndex, onTap: onItemSelected),
                _MenuItem(icon: Icons.category_rounded, title: 'Kategoriler', index: 2, selected: selectedIndex, onTap: onItemSelected),

                const SizedBox(height: 8),
                _MenuSection(title: 'SİPARİŞ & CRM'),
                _MenuItem(icon: Icons.shopping_bag_rounded, title: 'Siparişler', index: 3, selected: selectedIndex, onTap: onItemSelected),
                _MenuItem(icon: Icons.people_rounded, title: 'Müşteriler', index: 4, selected: selectedIndex, onTap: onItemSelected),

                const SizedBox(height: 8),
                _MenuSection(title: 'PAZARLAMA'),
                _MenuItem(icon: Icons.campaign_rounded, title: 'Kampanyalar', index: 5, selected: selectedIndex, onTap: onItemSelected),
                _MenuItem(icon: Icons.confirmation_number_rounded, title: 'Kupon Kodları', index: 6, selected: selectedIndex, onTap: onItemSelected),

                const SizedBox(height: 8),
                _MenuSection(title: 'SİSTEM'),
                _MenuItem(icon: Icons.settings_rounded, title: 'Ayarlar', index: 7, selected: selectedIndex, onTap: onItemSelected),
              ],
            ),
          ),

          // Logout
          const Divider(color: Colors.white12, height: 1),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            title: const Text('Çıkış Yap', style: TextStyle(color: Colors.redAccent, fontSize: 14)),
            onTap: () async {
              await ApiService.logout();
              if (context.mounted) Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  const _MenuSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(title, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int index;
  final int selected;
  final Function(int) onTap;

  const _MenuItem({required this.icon, required this.title, required this.index, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        onTap: () => onTap(index),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: isSelected ? const Color(0xFF6366F1).withOpacity(0.2) : null,
        leading: Icon(icon, color: isSelected ? const Color(0xFF818CF8) : Colors.white54, size: 20),
        title: Text(title, style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        )),
        dense: true,
        visualDensity: const VisualDensity(vertical: -1),
      ),
    );
  }
}
