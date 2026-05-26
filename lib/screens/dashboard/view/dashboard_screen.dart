import '../../../libs.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.requestPermission();
      context.read<DashboardViewModel>().processAutomatedSleep(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String userName = Hive.box(
      'prefs',
    ).get('user_name', defaultValue: 'User');

    return CommonScreen(
      showBannerAd: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CompAppBar.titleBar(
          title: "Hi, $userName 👋",
          isBackButtonVisible: false,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          const SliverToBoxAdapter(child: WeeklyCalendar()),
          const SliverToBoxAdapter(child: StatsGrid()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                "My Habits",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ThemeChangerViewModel>(
                    context,
                  ).getTextColor,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: HabitList()),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
