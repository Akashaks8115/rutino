import '../../../../libs.dart';

void showSessionFeedbackDialog(BuildContext context, FocusViewModel state) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final theme = Provider.of<ThemeChangerViewModel>(context, listen: false);
      
      return AlertDialog(
        backgroundColor: theme.getCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: "Session Complete! 🎉".blackTextStyle(
            color: theme.getTextColor,
            fw: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            "How was your session?".greyTextStyle(
              color: theme.getSecondaryTextColor,
            ),
            const SizedBox(height: 20),
            _FeedbackButton(
              title: "Great 🚀",
              color: theme.getSuccessColor,
              onTap: () {
                state.saveSessionLog("Great");
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            _FeedbackButton(
              title: "Distracted 🤔",
              color: Colors.orangeAccent,
              onTap: () {
                state.saveSessionLog("Distracted");
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            _FeedbackButton(
              title: "Difficult 😓",
              color: Colors.redAccent,
              onTap: () {
                state.saveSessionLog("Difficult");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

class _FeedbackButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _FeedbackButton({
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: title.customTextStyle(
            color: color,
            fw: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
