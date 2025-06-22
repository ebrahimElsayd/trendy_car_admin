import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardScreenAdmin extends StatefulWidget {
  const DashboardScreenAdmin({super.key});

  @override
  State<DashboardScreenAdmin> createState() => _DashboardScreenAdminState();
}

class _DashboardScreenAdminState extends State<DashboardScreenAdmin> {
  int selectedTab = 0;

  final List<String> drawerItems = [
    'Dashboard',
    'All Products',
    'Order List',
    'Customer Management',
  ];

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      drawer: isMobile ? _buildDrawer() : null,
      appBar:
          isMobile
              ? AppBar(
                title: const Text("Dashboard"),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              )
              : null,
      body: Row(
        children: [
          if (!isMobile) _buildDrawer(),
          Expanded(child: _buildDashboardContent()),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFFF3F2F0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            child: Row(
              children: [
                Icon(Icons.flight, size: 32),
                SizedBox(width: 10),
                Text(
                  'ecommerce',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ],
            ),
          ),
          ...List.generate(drawerItems.length, (index) {
            return ListTile(
              leading: Icon(
                index == 0
                    ? Icons.dashboard
                    : index == 1
                    ? Icons.list
                    : index == 2
                    ? Icons.receipt_long
                    : Icons.group,
              ),
              title: Text(drawerItems[index]),
              selected: index == selectedTab,
              selectedTileColor: Colors.black12,
              onTap: () {
                setState(() => selectedTab = index);
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dashboard",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.calendar_today, size: 18),
              SizedBox(width: 6),
              Text("Oct 1, 2024 - Sep 1, 2024"),
            ],
          ),
          const SizedBox(height: 16),

          // Total Orders Card
          _buildStatCard(
            title: "Total Orders",
            value: "10.565",
            icon: Icons.shopping_bag,
            growth: "+44.7%",
            comparison: "Compared to Oct 2023",
          ),
          const SizedBox(height: 16),

          // Active, Completed, Return Orders Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: "Active Orders",
                  value: "4000",
                  growth: "+34.7%",
                  comparison: "Compared to Oct 2023",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: "Completed Order",
                  value: "6000",
                  growth: "+40.7%",
                  comparison: "Compared to Oct 2023",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: "Return Orders",
                  value: "565",
                  growth: "-60.7%",
                  comparison: "Compared to Oct 2023",
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text(
            "Best Sellers",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _buildBestSellerItem("airpods pro", "\$126.50", "999 sales"),
          _buildBestSellerItem("Nintendo Pro", "\$126.50", "999 sales"),
          _buildBestSellerItem("Bose Headphones", "\$126.50", "999 sales"),

          const SizedBox(height: 24),
          Container(child: Container(child: SalesGraph())),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    IconData? icon,
    String? growth,
    String? comparison,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (growth != null)
            Row(
              children: [
                Icon(
                  growth.contains('-')
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  color: growth.contains('-') ? Colors.red : Colors.green,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  growth,
                  style: TextStyle(
                    color: growth.contains('-') ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          if (comparison != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                comparison,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBestSellerItem(String name, String price, String sales) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 48, height: 48, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(price),
              ],
            ),
          ),
          Column(
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(sales, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class SalesGraph extends StatefulWidget {
  const SalesGraph({super.key});

  @override
  State<SalesGraph> createState() => _SalesGraphState();
}

class _SalesGraphState extends State<SalesGraph> {
  String selectedView = 'Monthly';

  final Map<String, List<FlSpot>> dataMap = {
    'Weekly': [
      FlSpot(0, 50),
      FlSpot(1, 70),
      FlSpot(2, 100),
      FlSpot(3, 90),
      FlSpot(4, 120),
      FlSpot(5, 80),
      FlSpot(6, 150),
    ],
    'Monthly': [
      FlSpot(0, 100),
      FlSpot(1, 110),
      FlSpot(2, 115),
      FlSpot(3, 130),
      FlSpot(4, 125),
      FlSpot(5, 140),
      FlSpot(6, 300),
    ],
    'Yearly': [
      FlSpot(0, 500),
      FlSpot(1, 450),
      FlSpot(2, 600),
      FlSpot(3, 800),
      FlSpot(4, 750),
      FlSpot(5, 900),
      FlSpot(6, 1000),
    ],
  };

  final List<String> labels = ['JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];

  @override
  Widget build(BuildContext context) {
    final spots = dataMap[selectedView]!;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(blurRadius: 8.r, color: Colors.black12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sale Graph",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                Row(
                  children:
                      ['Weekly', 'Monthly', 'Yearly'].map((e) {
                        final isSelected = selectedView == e;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: ChoiceChip(
                            label: Text(e, style: TextStyle(fontSize: 8.h)),
                            selected: isSelected,
                            onSelected: (_) => setState(() => selectedView = e),
                            selectedColor: Colors.black,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            backgroundColor: Colors.grey[200],
                            shape: StadiumBorder(
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade300, Colors.blueAccent],
                      ),
                      barWidth: 4.w,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 100,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade400),
                      left: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < labels.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                labels[index],
                                style: TextStyle(fontSize: 10.sp),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget:
                            (value, meta) => Text(
                              '₹${value.toInt()}',
                              style: TextStyle(fontSize: 10.sp),
                            ),
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
