import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vinaluma_admin/constants.dart';
import 'package:vinaluma_admin/services/api_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  @override State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<dynamic> _orders = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final data = await ApiService.getOrders();
      setState(() { _orders = data; _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Color _statusColor(String status) => switch (status) {
    'pending' => Colors.orange,
    'confirmed' => Colors.blue,
    'processing' => const Color(0xFF6366F1),
    'shipped' => Colors.cyan,
    'delivered' => const Color(0xFF10B981),
    'cancelled' => Colors.red,
    _ => Colors.grey,
  };

  String _statusText(String status) => switch (status) {
    'pending' => 'Bekleyen',
    'confirmed' => 'Onaylı',
    'processing' => 'Hazırlanıyor',
    'shipped' => 'Kargoda',
    'delivered' => 'Teslim',
    'cancelled' => 'İptal',
    _ => status,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Siparişler', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
            child: _loading
                ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: primaryColor)))
                : _orders.isEmpty
                    ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('Henüz sipariş yok', style: TextStyle(color: Colors.white38, fontSize: 16))))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 24,
                          columns: const [
                            DataColumn(label: Text('Sipariş No', style: TextStyle(color: Colors.white54))),
                            DataColumn(label: Text('Müşteri', style: TextStyle(color: Colors.white54))),
                            DataColumn(label: Text('Tutar', style: TextStyle(color: Colors.white54))),
                            DataColumn(label: Text('Durum', style: TextStyle(color: Colors.white54))),
                            DataColumn(label: Text('Tarih', style: TextStyle(color: Colors.white54))),
                          ],
                          rows: _orders.map<DataRow>((o) {
                            final status = o['status'] ?? '';
                            final color = _statusColor(status);
                            return DataRow(cells: [
                              DataCell(Text(o['order_number'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13))),
                              DataCell(Text(o['user']?['name'] ?? '-', style: const TextStyle(color: Colors.white70, fontSize: 13))),
                              DataCell(Text('₺${o['total'] ?? '0'}', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w600, fontSize: 13))),
                              DataCell(Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                                child: Text(_statusText(status), style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
                              )),
                              DataCell(Text(o['created_at']?.substring(0, 10) ?? '', style: const TextStyle(color: Colors.white54, fontSize: 13))),
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
