import 'package:flutter/material.dart';
import 'package:vinaluma_admin/constants.dart';
import 'package:vinaluma_admin/services/api_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);
  @override State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<dynamic> _products = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final data = await ApiService.getProducts();
      setState(() { _products = data; _loading = false; });
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
          Row(
            children: [
              Text('Ürünler', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Yeni Ürün'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
            child: _loading
                ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: primaryColor)))
                : _products.isEmpty
                    ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('Henüz ürün yok', style: TextStyle(color: Colors.white38, fontSize: 16))))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 24,
                          columns: const [
                            DataColumn(label: Text('SKU', style: TextStyle(color: Colors.white54))),
                            DataColumn(label: Text('Ürün Adı', style: TextStyle(color: Colors.white54))),
                            DataColumn(label: Text('Kategori', style: TextStyle(color: Colors.white54))),
                            DataColumn(label: Text('Fiyat', style: TextStyle(color: Colors.white54))),
                            DataColumn(label: Text('Stok', style: TextStyle(color: Colors.white54))),
                            DataColumn(label: Text('Durum', style: TextStyle(color: Colors.white54))),
                          ],
                          rows: _products.map<DataRow>((p) {
                            final status = p['status'] ?? '';
                            final statusColor = status == 'active' ? const Color(0xFF10B981) : Colors.orange;
                            return DataRow(cells: [
                              DataCell(Text(p['sku'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13))),
                              DataCell(ConstrainedBox(constraints: const BoxConstraints(maxWidth: 250), child: Text(p['name'] ?? '', style: const TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis))),
                              DataCell(Text(p['category']?['name'] ?? '-', style: const TextStyle(color: Colors.white54, fontSize: 13))),
                              DataCell(Text('₺${p['price'] ?? '0'}', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w600, fontSize: 13))),
                              DataCell(Text('${p['stock_quantity'] ?? 0}', style: const TextStyle(color: Colors.white70, fontSize: 13))),
                              DataCell(Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                                child: Text(status == 'active' ? 'Aktif' : 'Pasif', style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
