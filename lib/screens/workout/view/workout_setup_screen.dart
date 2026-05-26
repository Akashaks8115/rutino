import '../../../../libs.dart';

class WorkoutSetupScreen extends StatefulWidget {
  const WorkoutSetupScreen({super.key});

  @override
  State<WorkoutSetupScreen> createState() => _WorkoutSetupScreenState();
}

class _WorkoutSetupScreenState extends State<WorkoutSetupScreen> {
  final List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<Map<String, String>> _presets = [
    {'title': 'Weight Training', 'icon': '🏋️‍♂️'},
    {'title': 'Cardio / Run', 'icon': '🏃‍♂️'},
    {'title': 'Yoga', 'icon': '🧘‍♂️'},
    {'title': 'Home Workout', 'icon': '🏠'},
  ];

  Future<void> _pickTime(BuildContext context, WorkoutViewModel vm) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: vm.hour, minute: vm.minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: const Color(0xFFFF4500)),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      vm.setTime(picked.hour, picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);
    final vm = Provider.of<WorkoutViewModel>(context);

    // Theme colors
    final neonCrimson = const Color(0xFFFF4500);

    return CommonScreen(
      showBannerAd: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: "Workout Setup".blackTextStyle(
          color: theme.getTextColor,
          fw: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: theme.getTextColor),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Crush Your Goals".blackTextStyle(
                color: neonCrimson,
                fw: FontWeight.bold,
                enumFontSize: EnumFontSize.extraLarge,
              ),
              const SizedBox(height: 8),
              "Build a consistent physical routine.".greyTextStyle(
                color: theme.getSecondaryTextColor,
                height: 1.5,
                fw: FontWeight.w500,
              ),
              const SizedBox(height: 32),

              // Preset Tags
              "Workout Type".greyTextStyle(
                color: theme.getSecondaryTextColor,
                fw: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _presets.map((preset) {
                  final bool isSelected = vm.workoutType == preset['title'];
                  return GestureDetector(
                    onTap: () => vm.setWorkoutType(preset['title']!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? neonCrimson.withValues(alpha: 0.15)
                            : theme.getCardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? neonCrimson : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            preset['icon']!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          preset['title']!.customTextStyle(
                            color: isSelected
                                ? neonCrimson
                                : theme.getTextColor,
                            fw: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                style: TextStyle(color: theme.getTextColor),
                decoration: InputDecoration(
                  labelText: "Custom Type (Optional)",
                  labelStyle: TextStyle(color: theme.getSecondaryTextColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.getPrimaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: neonCrimson),
                  ),
                ),
                onChanged: (val) {
                  if (val.isNotEmpty) vm.setWorkoutType(val);
                },
              ),
              const SizedBox(height: 32),

              // Goal Type Selector
              "Tracking Mode".greyTextStyle(
                color: theme.getSecondaryTextColor,
                fw: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => vm.setGoalType('duration'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: vm.goalType == 'duration'
                              ? neonCrimson.withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: vm.goalType == 'duration'
                                ? neonCrimson
                                : theme.getPrimaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: "⏳ Duration Based".customTextStyle(
                          color: vm.goalType == 'duration'
                              ? neonCrimson
                              : theme.getSecondaryTextColor,
                          fw: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => vm.setGoalType('task'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: vm.goalType == 'task'
                              ? neonCrimson.withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: vm.goalType == 'task'
                                ? neonCrimson
                                : theme.getPrimaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: "✅ Task Based".customTextStyle(
                          color: vm.goalType == 'task'
                              ? neonCrimson
                              : theme.getSecondaryTextColor,
                          fw: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              if (vm.goalType == 'duration') ...[
                // Daily Target
                "Target Duration (Mins)".greyTextStyle(
                  color: theme.getSecondaryTextColor,
                  fw: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () =>
                          vm.setTargetMinutes(vm.targetMinutes - 5),
                      icon: Icon(
                        BootstrapIcons.dash_circle,
                        color: theme.getSecondaryTextColor,
                      ),
                    ),
                    const SizedBox(width: 24),
                    "${vm.targetMinutes}".blackTextStyle(
                      color: theme.getTextColor,
                      enumFontSize: EnumFontSize.extraLarge,
                      fw: FontWeight.bold,
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      onPressed: () =>
                          vm.setTargetMinutes(vm.targetMinutes + 5),
                      icon: Icon(
                        BootstrapIcons.plus_circle_fill,
                        color: neonCrimson,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],

              // Time Picker
              "Reminder Time".greyTextStyle(
                color: theme.getSecondaryTextColor,
                fw: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _pickTime(context, vm),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: theme.getCardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: neonCrimson.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TimeOfDay(hour: vm.hour, minute: vm.minute)
                          .format(context)
                          .blackTextStyle(
                            color: theme.getTextColor,
                            enumFontSize: EnumFontSize.extraLarge,
                            fw: FontWeight.bold,
                          ),
                      Icon(BootstrapIcons.clock, color: neonCrimson),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Days Selector
              "Training Days".greyTextStyle(
                color: theme.getSecondaryTextColor,
                fw: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  int dayValue = index + 1; // 1 = Monday
                  bool isSelected = vm.selectedDays.contains(dayValue);
                  return GestureDetector(
                    onTap: () => vm.toggleDay(dayValue),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? neonCrimson : theme.getCardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? neonCrimson
                              : theme.getPrimaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Center(
                        child: _days[index].customTextStyle(
                          color: isSelected
                              ? Colors.white
                              : theme.getSecondaryTextColor,
                          fw: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: neonCrimson,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    await vm.saveSettings();
                    if (context.mounted) {
                      CustomToast.showSuccess(
                        context,
                        "Saved",
                        "Workout Saved!",
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: "Save Workout".customTextStyle(
                    color: Colors.white,
                    fw: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
