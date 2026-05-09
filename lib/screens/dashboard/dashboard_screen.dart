import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vinaluma_admin/constants.dart';
import 'package:vinaluma_admin/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _homeData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await ApiService.getHome();
      setState(() { _homeData = data; _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text('Hoşgeldiniz, Yönetim paneline genel bakış', style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 24),

          // Stat Cards
          _buildStatCards(),
          const SizedBox(height: 24),

          // Charts Row
          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildRevenueChart()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildCategoryChart()),
                ],
              );
            }
            return Column(
              children: [
                _buildRevenueChart(),
                const SizedBox(height: 16),
                _buildCategoryChart(),
              ],
            );
          }),
          const SizedBox(height: 24),

          // Recent Items
          _buildRecentProducts(),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    final categories = (_homeData?['categories'] as List?)?.length ?? 0;
    final featured = (_homeData?['featured'] as List?)?.length ?? 0;
    final newProds = (_homeData?['newProducts'] as List?)?.length ?? 0;

    final stats = [
      _StatItem(icon: Icons.inventory_2_rounded, title: 'Toplam Ürün', value: '${featured + newProds}', color: const Color(0xFF6366F1)),
      _StatItem(icon: Icons.category_rounded, title: 'Kategoriler', value: '$categories', color: const Color(0xFF10B981)),
      _StatItem(icon: Icons.star_rounded, title: 'Öne Çıkan', value: '$featured', color: const Color(0xFFF59E0B)),
      _StatItem(icon: Icons.new_releases_rounded, title: 'Yeni Ürün', value: '$newProds', color: const Color(0xFFEF4444)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 2.2,
      ),
      itemCount: stats.length,
      itemBuilder: (_, i) => _buildStatCard(stats[i]),
    );
  }

  Widget _buildStatCard(_StatItem stat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: stat.color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Icon(stat.icon, color: stat.color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
          Text(stat.value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(stat.title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gelir Grafiği', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(LineChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: Colors.white10, strokeWidth: 1)),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, _) => Text('${v.toInt()}K', style: const TextStyle(color: Colors.white38, fontSize: 10)))),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) => Text(['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'][v.toInt() % 7], style: const TextStyle(color: Colors.white38, fontSize: 10)))),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: const [FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 3.5), FlSpot(3, 5), FlSpot(4, 4), FlSpot(5, 6), FlSpot(6, 5.5)],
                  isCurved: true,
                  color: primaryColor,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: primaryColor.withOpacity(0.1)),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChart() {
    final categories = _homeData?['categories'] as List? ?? [];
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kategoriler', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Expanded(
            child: categories.isEmpty
                ? const Center(child: Text('Veri yok', style: TextStyle(color: Colors.white38)))
                : ListView.builder(
                    itemCount: categories.length > 6 ? 6 : categories.length,
                    itemBuilder: (_, i) {
                      final cat = categories[i];
                      final colors = [const Color(0xFF6366F1), const Color(0xFF10B981), const Color(0xFFF59E0B), const Color(0xFFEF4444), const Color(0xFF8B5CF6), const Color(0xFF06B6D4)];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(width: 12, height: 12, decoration: BoxDecoration(color: colors[i % colors.length], borderRadius: BorderRadius.circular(3))),
                            const SizedBox(width: 10),
                            Expanded(child: Text(cat['name'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13))),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentProducts() {
    final products = _homeData?['newProducts'] as List? ?? [];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Son Eklenen Ürünler', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          if (_loading)
            const Center(child: CircularProgressIndicator(color: primaryColor))
          else if (products.isEmpty)
            const Padding(padding: EdgeInsets.all(20), child: Center(child: Text('Henüz ürün eklenmemiş', style: TextStyle(color: Colors.white38))))
          else
            DataTable(
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('SKU', style: TextStyle(color: Colors.white54))),
                DataColumn(label: Text('Ürün Adı', style: TextStyle(color: Colors.white54))),
                DataColumn(label: Text('Fiyat', style: TextStyle(color: Colors.white54))),
                DataColumn(label: Text('Stok', style: TextStyle(color: Colors.white54))),
              ],
              rows: products.take(8).map<DataRow>((p) => DataRow(cells: [
                DataCell(Text(p['sku'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13))),
                DataCell(Text(p['name'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis)),
                DataCell(Text('₺${p['price'] ?? '0'}', style: const TextStyle(color: Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.w600))),
                DataCell(Text('${p['stock_quantity'] ?? 0}', style: const TextStyle(color: Colors.white70, fontSize: 13))),
              ])).toList(),
            ),
        ],
      ),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  const _StatItem({required this.icon, required this.title, required this.value, required this.color});
}
