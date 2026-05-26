import '../../../../libs.dart';

class BookReadingScreen extends StatefulWidget {
  const BookReadingScreen({super.key});

  @override
  State<BookReadingScreen> createState() => _BookReadingScreenState();
}

class _BookReadingScreenState extends State<BookReadingScreen> {
  final List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  Future<void> _pickTime(BuildContext context, BookReadingViewModel vm) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: vm.hour, minute: vm.minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: const Color(0xFFF59E0B)),
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
    final vm = Provider.of<BookReadingViewModel>(context);

    // Theme colors
    final bgColor = theme.getScaffoldColor;
    final amberColor = const Color(0xFFF59E0B);

    return CommonScreen(
      showBannerAd: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: "Reading Tracker".blackTextStyle(
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
              "Track your reading".blackTextStyle(
                color: amberColor,
                fw: FontWeight.bold,
                enumFontSize: EnumFontSize.extraLarge,
              ),
              const SizedBox(height: 8),
              "Set a target for a specific book or just a daily routine."
                  .greyTextStyle(
                    color: theme.getSecondaryTextColor,
                    height: 1.5,
                    fw: FontWeight.w500,
                    overflow: TextOverflow.clip,
                  ),
              const SizedBox(height: 32),

              // Goal Type Selector
              "Goal Type".greyTextStyle(
                color: theme.getSecondaryTextColor,
                fw: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => vm.setMode('per_book'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: vm.mode == 'per_book'
                              ? amberColor.withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: vm.mode == 'per_book'
                                ? amberColor
                                : theme.getPrimaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: "📖 Specific Book".customTextStyle(
                          color: vm.mode == 'per_book'
                              ? amberColor
                              : theme.getSecondaryTextColor,
                          fw: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => vm.setMode('daily_routine'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: vm.mode == 'daily_routine'
                              ? amberColor.withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: vm.mode == 'daily_routine'
                                ? amberColor
                                : theme.getPrimaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: "⏱️ Daily Routine".customTextStyle(
                          color: vm.mode == 'daily_routine'
                              ? amberColor
                              : theme.getSecondaryTextColor,
                          fw: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              if (vm.mode == 'per_book') ...[
                TextField(
                  style: TextStyle(color: theme.getTextColor),
                  decoration: InputDecoration(
                    labelText: "Book Name",
                    labelStyle: TextStyle(color: theme.getSecondaryTextColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.getPrimaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: amberColor),
                    ),
                  ),
                  onChanged: vm.setBookName,
                ),
                const SizedBox(height: 16),
                TextField(
                  style: TextStyle(color: theme.getTextColor),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Total Pages",
                    labelStyle: TextStyle(color: theme.getSecondaryTextColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.getPrimaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: amberColor),
                    ),
                  ),
                  onChanged: (val) => vm.setTotalPages(int.tryParse(val) ?? 0),
                ),
                const SizedBox(height: 32),
              ],

              // Daily Target
              "Daily Target (Pages)".greyTextStyle(
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
                        vm.setTargetDailyPages(vm.targetDailyPages - 1),
                    icon: Icon(
                      BootstrapIcons.dash_circle,
                      color: theme.getSecondaryTextColor,
                    ),
                  ),
                  const SizedBox(width: 24),
                  "${vm.targetDailyPages}".blackTextStyle(
                    color: theme.getTextColor,
                    enumFontSize: EnumFontSize.extraLarge,
                    fw: FontWeight.bold,
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    onPressed: () =>
                        vm.setTargetDailyPages(vm.targetDailyPages + 1),
                    icon: Icon(
                      BootstrapIcons.plus_circle_fill,
                      color: amberColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

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
                      color: amberColor.withValues(alpha: 0.3),
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
                      Icon(BootstrapIcons.clock, color: amberColor),
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
                        color: isSelected ? amberColor : theme.getCardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? amberColor
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
                    backgroundColor: amberColor,
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
                        "Book Tracker Saved!",
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: "Save Book Schedule".customTextStyle(
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
