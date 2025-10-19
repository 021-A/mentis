import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F9),
      appBar: AppBar(
        title: const Text("Analytics"),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= Sales Overview =================
            const Text(
              "Sales Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: true),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: const [
                        FlSpot(0, 3),
                        FlSpot(1, 2),
                        FlSpot(2, 5),
                        FlSpot(3, 4),
                        FlSpot(4, 6),
                        FlSpot(5, 8),
                      ],
                      barWidth: 3,
                      color: Colors.teal,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ================= Top Categories =================
            const Text(
              "Top Categories",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      color: Colors.teal,
                      title: "E-books\n40%",
                      radius: 60,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 30,
                      color: Colors.orange,
                      title: "Templates\n30%",
                      radius: 60,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.blue,
                      title: "Assets\n20%",
                      radius: 60,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 10,
                      color: Colors.purple,
                      title: "Others\n10%",
                      radius: 60,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ================= Recent Activity =================
            const Text(
              "Recent Activity",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.teal),
                title: const Text("New order placed"),
                subtitle: const Text("2 hours ago"),
                trailing: const Text("\$49.99"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_add, color: Colors.orange),
                title: const Text("New user registered"),
                subtitle: const Text("5 hours ago"),
                trailing: const Text("User ID: 123"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.download, color: Colors.blue),
                title: const Text("Digital product downloaded"),
                subtitle: const Text("1 day ago"),
                trailing: const Text("23 times"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
