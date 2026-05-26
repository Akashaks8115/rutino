import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../viewmodel/step_tracker_view_model.dart';
import '../widget/goal_achieved_overlay.dart';

class StepTrackerScreen extends StatefulWidget {
  const StepTrackerScreen({super.key});

  @override
  State<StepTrackerScreen> createState() => _StepTrackerScreenState();
}

class _StepTrackerScreenState extends State<StepTrackerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<StepTrackerViewModel>(context, listen: false);
      provider.initStepTracker();
    });
  }

  void _showTargetModifier(BuildContext context, StepTrackerViewModel provider) {
    int currentGoal = provider.targetGoal;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Set Daily Goal",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "$currentGoal Steps",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF00E676),
                    ),
                  ),
                  Slider(
                    value: currentGoal.toDouble(),
                    min: 2000,
                    max: 25000,
                    divisions: 23,
                    activeColor: const Color(0xFF00E676),
                    inactiveColor: const Color(0xFF0F172A),
                    onChanged: (val) {
                      setState(() {
                        currentGoal = val.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5465FF),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      provider.setTargetGoal(currentGoal);
                      Navigator.pop(context);
                    },
                    child: const Text("Save Goal", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Stride Room", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: Consumer<StepTrackerViewModel>(
        builder: (context, provider, child) {
          if (!provider.isTracking && provider.todaySteps == 0) {
             return const Center(
               child: CircularProgressIndicator(color: Color(0xFF00E676)),
             );
          }
          
          if (provider.isGoalAchieved) {
             WidgetsBinding.instance.addPostFrameCallback((_) {
                 // Trigger overlay if not already shown
                 // Implementation depends on how we want to handle one-time popup
             });
          }

          double percent = provider.todaySteps / provider.targetGoal;
          if (percent > 1.0) percent = 1.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Component: Circular Ring
                CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 18.0,
                  animation: true,
                  percent: percent,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${provider.todaySteps}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 48.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "/ ${provider.targetGoal} Steps",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: const Color(0xFF1E293B),
                  linearGradient: const LinearGradient(
                    colors: [Color(0xFF5465FF), Color(0xFF00E676)],
                  ),
                ),
                const SizedBox(height: 32),

                // Micro Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard("Distance", "${provider.distanceKm.toStringAsFixed(2)} km", "🔥"),
                    _buildStatCard("Calories", "${provider.caloriesBurned.toStringAsFixed(0)} kcal", "🔥"),
                    _buildStatCard("Active Time", "${(provider.todaySteps / 100).toStringAsFixed(0)} mins", "⏱️"), // approx
                  ],
                ),
                const SizedBox(height: 40),

                // Middle Component: Target Modifier
                GestureDetector(
                  onTap: () => _showTargetModifier(context, provider),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF5465FF).withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Modify Daily Target",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.edit, color: Color(0xFF00E676)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Bottom Component: Hourly Bar Chart
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Today's Activity",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: _buildBarChart(provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(StepTrackerViewModel provider) {
    // Simulated bar chart data for aesthetics (Option B/C)
    // In a real scenario, this would use hourly recorded data from the ViewModel.
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 2000,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(color: Color(0xFF94A3B8), fontSize: 10);
                String text = '';
                switch (value.toInt()) {
                  case 0: text = '6 AM'; break;
                  case 1: text = '9 AM'; break;
                  case 2: text = '12 PM'; break;
                  case 3: text = '3 PM'; break;
                  case 4: text = '6 PM'; break;
                  case 5: text = '9 PM'; break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(text, style: style),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          _makeGroupData(0, 500),
          _makeGroupData(1, 1200),
          _makeGroupData(2, 800),
          _makeGroupData(3, provider.todaySteps > 1500 ? 1500 : provider.todaySteps.toDouble()),
          _makeGroupData(4, 0),
          _makeGroupData(5, 0),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFF00E676),
          width: 16,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 2000,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
