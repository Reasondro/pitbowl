import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UserPortfolio extends StatelessWidget {
  const UserPortfolio({super.key, required this.username});

  final String username;

  //?dummy data  investments
  final List<Investment> investments = const [
    Investment(
      companyName: "Tech Innovators Inc.",
      investmentAmount: 600000,
      currentValue: 750000,
      returnPercentage: 55.6,
    ),
    Investment(
      companyName: "HealthPlus Corp.",
      investmentAmount: 30000,
      currentValue: 450000,
      returnPercentage: 42.1,
    ),
    Investment(
      companyName: "Green Energy LLC",
      investmentAmount: 400000,
      currentValue: 600000,
      returnPercentage: 37.9,
    ),
    Investment(
      companyName: "EduFuture Ltd.",
      investmentAmount: 2000,
      currentValue: 2500,
      returnPercentage: 12.4,
    ),
  ];

  //?dummyy data  portfolio performance
  final List<FlSpot> performanceData = const [
    FlSpot(0, 10000),
    FlSpot(1, 10500),
    FlSpot(2, 10300),
    FlSpot(3, 11000),
    FlSpot(4, 11500),
    FlSpot(5, 12000),
    FlSpot(6, 12500),
  ];

  @override
  Widget build(BuildContext context) {
    double totalInvestment =
        investments.fold(0, (sum, item) => sum + item.investmentAmount);
    double currentTotalValue =
        investments.fold(0, (sum, item) => sum + item.currentValue);
    double totalReturnPercentage =
        ((currentTotalValue - totalInvestment) / totalInvestment) * 100;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Summary
            Card(
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      "Good afternoon, $username",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem(
                            "Total Invested",
                            "Rp${totalInvestment.toStringAsFixed(2)}",
                            Colors.white),
                        _buildSummaryItem(
                            "Current Value",
                            "Rp${currentTotalValue.toStringAsFixed(2)}",
                            Colors.white),
                        _buildSummaryItem(
                            "Return",
                            "${totalReturnPercentage.toStringAsFixed(2)}%",
                            totalReturnPercentage >= 0
                                ? Colors.greenAccent
                                : Colors.redAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Performance Chart
            Text(
              "Portfolio Performance",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1.7,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) => Text(
                              value.toString(),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return const Text('Jan');
                                case 1:
                                  return const Text('Feb');
                                case 2:
                                  return const Text('Mar');
                                case 3:
                                  return const Text('Apr');
                                case 4:
                                  return const Text('May');
                                case 5:
                                  return const Text('Jun');
                                case 6:
                                  return const Text('Jul');
                                default:
                                  return const Text('');
                              }
                            },
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey),
                      ),
                      minX: 0,
                      maxX: 6,
                      minY: 9000,
                      maxY: 13000,
                      lineBarsData: [
                        LineChartBarData(
                          spots: performanceData,
                          isCurved: true,
                          color: Colors.blueAccent,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blueAccent.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Investment List
            Text(
              "Your Investments",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: investments.length,
              itemBuilder: (context, index) {
                final investment = investments[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    child: Row(
                      children: [
                        // Company Logo Placeholder
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.business,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Investment Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                investment.companyName,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Invested: Rp${investment.investmentAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              Text(
                                "Current Value: Rp${investment.currentValue.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        // Return Percentage
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${investment.returnPercentage.toStringAsFixed(2)}%",
                              style: TextStyle(
                                color: investment.returnPercentage >= 0
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Icon(
                              investment.returnPercentage >= 0
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: investment.returnPercentage >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //? helper method buat nge build summary items
  Widget _buildSummaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class Investment {
  //? invement model
  final String companyName;
  final double investmentAmount;
  final double currentValue;
  final double returnPercentage;

  const Investment({
    required this.companyName,
    required this.investmentAmount,
    required this.currentValue,
    required this.returnPercentage,
  });
}
