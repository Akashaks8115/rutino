import '../../../../libs.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  Future<void> _pickTime(BuildContext context, MeditationViewModel vm) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: vm.hour, minute: vm.minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: const Color(0xFF5465FF)),
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
    final vm = Provider.of<MeditationViewModel>(context);

    return CommonScreen(
      showBannerAd: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: "Meditation Setup".blackTextStyle(
          color: theme.getTextColor,
          fw: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: theme.getTextColor),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Mindful Moments".blackTextStyle(
              color: const Color(0xFF5465FF),
              fw: FontWeight.bold,
              enumFontSize: EnumFontSize.extraLarge,
            ),
            const SizedBox(height: 8),
            "Set your daily meditation schedule. We'll remind you to take a deep breath."
                .greyTextStyle(
                  color: theme.getSecondaryTextColor,
                  height: 1.5,
                  overflow: TextOverflow.clip,
                  fw: FontWeight.w500,
                ),
            const SizedBox(height: 40),

            // Enable Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "Enable Reminders".blackTextStyle(
                  color: theme.getTextColor,
                  fw: FontWeight.bold,
                  enumFontSize: EnumFontSize.large,
                ),
                Switch(
                  value: vm.isReminderEnabled,
                  activeThumbColor: const Color(0xFF5465FF),
                  onChanged: (val) => vm.toggleReminder(val),
                ),
              ],
            ),
            const SizedBox(height: 32),

            if (vm.isReminderEnabled) ...[
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
                      color: const Color(0xFF5465FF).withValues(alpha: 0.3),
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
                      const Icon(
                        BootstrapIcons.clock,
                        color: Color(0xFF5465FF),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Days Selector
              "Repeat On".greyTextStyle(
                color: theme.getSecondaryTextColor,
                fw: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  int dayValue = index + 1; // 1 = Monday, 7 = Sunday
                  bool isSelected = vm.selectedDays.contains(dayValue);
                  return GestureDetector(
                    onTap: () => vm.toggleDay(dayValue),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF5465FF)
                            : theme.getCardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF5465FF)
                              : theme.getSecondaryTextColor.withValues(
                                  alpha: 0.2,
                                ),
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
            ],

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5465FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  await vm.saveSettings();
                  if (context.mounted) {
                    CustomToast.showSuccess(context, "Saved", "Schedule Saved");
                    Navigator.pop(context);
                  }
                },
                child: "Save Schedule".customTextStyle(
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
    );
  }
}
