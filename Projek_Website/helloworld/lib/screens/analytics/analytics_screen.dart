import 'package:flutter/material.dart';
import '../../utils/screen_size.dart';
import '../../widgets/stat_card.dart';

class AnalyticsScreen extends StatelessWidget {
  final bool mobile;
  
  const AnalyticsScreen({
    super.key,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    final screen = ScreenSize.of(context);

    // Data contoh untuk kartu statistik
    final stats = [
      {'title': 'Total Users', 'value': '1,245', 'icon': Icons.people},
      {'title': 'Active Sessions', 'value': '312', 'icon': Icons.bar_chart},
      {'title': 'Revenue', 'value': '\$8,560', 'icon': Icons.attach_money},
      {'title': 'Conversion Rate', 'value': '3.5%', 'icon': Icons.trending_up},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Tentukan jumlah kolom grid secara dinamis berdasarkan ukuran layar
            // Jika parameter mobile true, gunakan 2 kolom, jika tidak gunakan screen.gridColumns
            final crossAxisCount = mobile ? 2 : screen.gridColumns;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: mobile ? 1.2 : (screen.isDesktop ? 1.6 : 1.4),
              ),
              itemCount: stats.length,
              itemBuilder: (context, index) {
                final item = stats[index];
                return StatCard(
                  title: item['title'] as String,
                  value: item['value'] as String,
                  icon: item['icon'] as IconData,
                  color: Colors.blueAccent,
                  // Parameter mobile dihapus karena StatCard sudah responsive otomatis
                );
              },
            );
          },
        ),
      ),
    );
  }
}