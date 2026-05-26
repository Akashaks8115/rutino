import '../../../libs.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isError = false;

  void _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _isError = true);
      return;
    }

    final prefsBox = Hive.box('prefs');
    await prefsBox.put('user_name', name);

    // Navigate to dashboard
    if (mounted) {
      Navigator.pushReplacementNamed(context, RoutesName.bottomNav);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChangerViewModel>(context);

    return CommonScreen(
      showBannerAd: false,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.getPrimaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  BootstrapIcons.stars,
                  color: theme.getPrimaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 32),
              "Welcome to Rutino".blackTextStyle(
                color: theme.getTextColor,
                fw: FontWeight.w900,
                enumFontSize: EnumFontSize.extraLarge,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 12),
              "Let's personalize your experience. What should we call you?"
                  .greyTextStyle(
                    color: theme.getSecondaryTextColor,
                    enumFontSize: EnumFontSize.medium,
                    height: 1.5,
                    overflow: TextOverflow.visible,
                  ),
              const SizedBox(height: 48),
              Container(
                decoration: BoxDecoration(
                  color: theme.getCardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isError
                        ? Colors.redAccent
                        : theme.getPrimaryColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: _nameController,
                  style: TextStyle(
                    color: theme.getTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    hintStyle: TextStyle(
                      color: theme.getSecondaryTextColor.withValues(alpha: 0.5),
                      fontFamily: 'Roboto',
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (val) {
                    if (_isError && val.trim().isNotEmpty) {
                      setState(() => _isError = false);
                    }
                  },
                ),
              ),
              if (_isError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                  child: "Please enter your name".customTextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fw: FontWeight.bold,
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.getPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: "Continue".whiteTextStyle(
                    fw: FontWeight.bold,
                    enumFontSize: EnumFontSize.large,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
