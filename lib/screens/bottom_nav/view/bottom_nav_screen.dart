import '../../../libs.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ExploreScreen(),
    AnalyticsScreen(),
    FocusScreen(),
    VaultScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeChangerViewModel>(context);

    return CommonScreen(
      // We do not need to explicitly set background color as CommonScreen picks from theme
      child: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: themeProvider.getCardColor,
        selectedItemColor: themeProvider.getPrimaryColor,
        unselectedItemColor: themeProvider.getGreyColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.grid),
            activeIcon: Icon(BootstrapIcons.grid_fill),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.compass),
            activeIcon: Icon(BootstrapIcons.compass_fill),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.bar_chart),
            activeIcon: Icon(BootstrapIcons.bar_chart_fill),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.clock),
            activeIcon: Icon(BootstrapIcons.clock_fill),
            label: "Focus",
          ),
          BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.person),
            activeIcon: Icon(BootstrapIcons.person_fill),
            label: "Vault",
          ),
        ],
      ),
    );
  }
}
