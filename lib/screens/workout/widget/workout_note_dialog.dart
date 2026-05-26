import '../../../../libs.dart';

class WorkoutNoteDialog extends StatefulWidget {
  final HabitModel habit;
  final double minutesTrained;

  const WorkoutNoteDialog({super.key, required this.habit, required this.minutesTrained});

  @override
  State<WorkoutNoteDialog> createState() => _WorkoutNoteDialogState();
}

class _WorkoutNoteDialogState extends State<WorkoutNoteDialog> {
  String _selectedNote = "Push Day";
  final List<String> _options = ["Push Day", "Pull Day", "Legs", "Cardio", "Full Body", "Core"];

  @override
  Widget build(BuildContext context) {
    final neonCrimson = const Color(0xFFFF4500);
    final bgColor = const Color(0xFF1E293B);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Workout Completed! 🎉".blackTextStyle(color: Colors.white, enumFontSize: EnumFontSize.extraLarge, fw: FontWeight.bold),
            const SizedBox(height: 8),
            "What did you train today?".greyTextStyle(color: Colors.white70),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _options.map((opt) {
                final isSelected = _selectedNote == opt;
                return GestureDetector(
                  onTap: () => setState(() => _selectedNote = opt),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? neonCrimson : Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: opt.customTextStyle(color: isSelected ? Colors.white : Colors.white70, fw: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: neonCrimson,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () async {
                   await Provider.of<DashboardViewModel>(context, listen: false).logWorkoutSession(
                     widget.habit.id, 
                     widget.minutesTrained, 
                     _selectedNote,
                   );
                   if (context.mounted) {
                     Navigator.pop(context); // close dialog
                     Navigator.pop(context); // close timer screen
                   }
                },
                child: "Save Log".customTextStyle(color: Colors.white, fw: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
