import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../../../libs.dart';

class WaterIntakeScreen extends StatelessWidget {
  const WaterIntakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);
    final vm = Provider.of<WaterIntakeViewModel>(context);
    final habit = vm.waterHabit;

    if (habit == null) return const Scaffold();

    return CommonScreen(
      showBannerAd: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: "Hydration".blackTextStyle(
          color: theme.getTextColor,
          fw: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: theme.getTextColor),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // 1. TOP: Goal Setter
            _buildGoalSetter(context, vm, theme),

            const SizedBox(height: 40),

            // 2. CENTER: Wave Animation
            _buildWaveCup(context, vm, theme),

            const SizedBox(height: 40),

            // 3. BOTTOM: Presets
            _buildPresets(context, vm, theme),

            const SizedBox(height: 40),

            // 4. REMINDER SETTINGS
            SafeArea(
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: _buildReminderSettings(context, vm, theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalSetter(
    BuildContext context,
    WaterIntakeViewModel vm,
    ThemeChangerViewModel theme,
  ) {
    final habit = vm.waterHabit!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.getCardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.getPrimaryColor.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              BootstrapIcons.dash_circle_fill,
              color: theme.getPrimaryColor,
              size: 30,
            ),
            onPressed: () {
              if (habit.targetCount > 2000) {
                vm.updateTarget(habit.targetCount - 250, context);
              }
            },
          ),
          Column(
            children: [
              "🎯 Daily Target".greyTextStyle(
                color: theme.getSecondaryTextColor,
                fw: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              "${habit.targetCount} ml".customTextStyle(
                color: theme.getTextColor,
                fontSize: 24,
                fw: FontWeight.bold,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              BootstrapIcons.plus_circle_fill,
              color: theme.getPrimaryColor,
              size: 30,
            ),
            onPressed: () {
              if (habit.targetCount < 6000) {
                vm.updateTarget(habit.targetCount + 250, context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWaveCup(
    BuildContext context,
    WaterIntakeViewModel vm,
    ThemeChangerViewModel theme,
  ) {
    final habit = vm.waterHabit!;
    double percentage = habit.completedCount / habit.targetCount;
    if (percentage > 1.0) percentage = 1.0;

    return Column(
      children: [
        "${habit.completedCount} / ${habit.targetCount} ml".customTextStyle(
          color: const Color(0xFF00D2FF),
          fontSize: 32,
          fw: FontWeight.bold,
        ),
        const SizedBox(height: 20),
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF00D2FF).withValues(alpha: 0.3),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00D2FF).withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: ClipOval(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(color: theme.getScaffoldColor),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  height: 250 * percentage,
                  width: 250,
                  child: WaveWidget(
                    config: CustomConfig(
                      colors: [
                        const Color(0xFF00D2FF).withValues(alpha: 0.4),
                        const Color(0xFF00D2FF).withValues(alpha: 0.6),
                        const Color(0xFF00D2FF),
                      ],
                      durations: [5000, 4000, 3000],
                      heightPercentages: [0.05, 0.08, 0.1],
                    ),
                    size: const Size(250, double.infinity),
                    waveAmplitude: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPresets(
    BuildContext context,
    WaterIntakeViewModel vm,
    ThemeChangerViewModel theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "QUICK LOG".greyTextStyle(
          color: theme.getSecondaryTextColor,
          fw: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _presetButton(context, vm, "🥛", "250 ml", 250, theme),
            _presetButton(context, vm, "🍾", "500 ml", 500, theme),
            _presetButton(context, vm, "🥤", "750 ml", 750, theme),
          ],
        ),
      ],
    );
  }

  Widget _presetButton(
    BuildContext context,
    WaterIntakeViewModel vm,
    String icon,
    String label,
    int amount,
    ThemeChangerViewModel theme,
  ) {
    return GestureDetector(
      onTap: () {
        vm.logWater(amount, context);
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: theme.getCardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.getPrimaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            icon.customTextStyle(fontSize: 28),
            const SizedBox(height: 8),
            label.customTextStyle(
              color: theme.getTextColor,
              fontSize: 14,
              fw: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderSettings(
    BuildContext context,
    WaterIntakeViewModel vm,
    ThemeChangerViewModel theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.getCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.getPrimaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(BootstrapIcons.bell_fill, color: theme.getPrimaryColor),
              const SizedBox(width: 8),
              "Reminder Settings".customTextStyle(
                color: theme.getTextColor,
                fontSize: 18,
                fw: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Mode Toggle
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => vm.setReminderMode('interval'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: vm.reminderMode == 'interval'
                          ? theme.getPrimaryColor
                          : theme.getScaffoldColor,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(8),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: "Smart Interval".blackTextStyle(
                      color: vm.reminderMode == 'interval'
                          ? Colors.white
                          : theme.getSecondaryTextColor,
                      fw: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => vm.setReminderMode('specific'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: vm.reminderMode == 'specific'
                          ? theme.getPrimaryColor
                          : theme.getScaffoldColor,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(8),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: "Fixed Times".blackTextStyle(
                      color: vm.reminderMode == 'specific'
                          ? Colors.white
                          : theme.getSecondaryTextColor,
                      fw: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (vm.reminderMode == 'specific') ...[
            "Specific Alarm Times".greyTextStyle(
              color: theme.getSecondaryTextColor,
              fw: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...vm.specificTimes.map(
                  (time) => Chip(
                    label: time.customTextStyle(color: theme.getTextColor),
                    backgroundColor: theme.getScaffoldColor,
                    deleteIcon: Icon(
                      Icons.close,
                      size: 16,
                      color: theme.getTextColor,
                    ),
                    onDeleted: () => vm.removeSpecificTime(time),
                  ),
                ),
                ActionChip(
                  label: "+ Add Alarm".customTextStyle(
                    color: const Color(0xFF00D2FF),
                  ),
                  backgroundColor: theme.getScaffoldColor,
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      final timeStr =
                          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                      vm.addSpecificTime(timeStr);
                    }
                  },
                ),
              ],
            ),
          ] else ...[
            "Remind me every:".greyTextStyle(
              color: theme.getSecondaryTextColor,
              fw: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            "${vm.intervalMinutes} Minutes".customTextStyle(
              color: theme.getTextColor,
              fontSize: 16,
            ),
            const SizedBox(height: 8),
            "Active between 08:00 AM to 08:00 PM".greyTextStyle(
              color: theme.getSecondaryTextColor,
              enumFontSize: EnumFontSize.small,
            ),
          ],

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676), // Neon Mint Green
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                vm.saveAndScheduleReminders();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reminders saved & scheduled! ⏰'),
                    backgroundColor: Color(0xFF00E676),
                  ),
                );
              },
              child: "Save & Activate Reminders".blackTextStyle(
                color: Colors.black,
                fw: FontWeight.bold,
                enumFontSize: EnumFontSize.large,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
