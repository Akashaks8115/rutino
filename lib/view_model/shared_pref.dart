import 'package:shared_preferences/shared_preferences.dart';

import '../libs.dart';

class SharedPrefViewModel with ChangeNotifier {
  String key = "User";
  String userCity = "city";
  String userState = "state";
  String onBoardingKey = "onBoarding";
  String cartQtyKey = "totalCartQty";
  String flagKey = "userFlag";

  String flag = "";
  String get getFlag => flag;

  String get getFlagEmoji => flag;

  Future<void> saveUserCountryFlag(String countryName) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      // 1. Get the flag emoji directly using the new async utility
      flag = await CompFunctions.convertToFlagEmoji(countryName);

      if (flag.isNotEmpty) {
        // 2. Save the Emoji directly to SharedPreferences
        await sp.setString(flagKey, flag);
        notifyListeners();
        debugPrint(
          'Country Flag emoji ($flag) saved successfully for $countryName',
        );
      } else {
        debugPrint('Country info not found for: $countryName');
      }

      /* 
      // COMMENTED USAGE FOR LIB/UTIL/COMP_FUNCTIONS.DART helpers:
      
      // 1. Get emoji by Country Name:
      // String flag1 = await CompFunctions.getFlagEmojiByCountryName("India");
      // print(flag1); // Output: 🇮🇳

      // 2. Get emoji by Dialing Code:
      // String flag2 = await CompFunctions.getFlagEmojiByDialingCode("+91");
      // print(flag2); // Output: 🇮🇳
      */
    } catch (e) {
      debugPrint('Error saving country flag: $e');
    }
  }

  Future<void> loadFlagFromPref() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    flag = sp.getString(flagKey) ?? "";
    notifyListeners();
  }

  Future callSaveOnboarding() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(onBoardingKey, true);
    notifyListeners();
  }

  Future<bool> callCheckOnboarding() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(onBoardingKey) ?? false;
  }

  int _cartQty = 0;
  int get cartQty => _cartQty;

  Future<void> saveTotalQuantity(int qty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(cartQtyKey, qty);

    _cartQty = qty; // update provider value
    notifyListeners();
  }

  Future<void> loadCartQtyFromPref() async {
    final prefs = await SharedPreferences.getInstance();
    _cartQty = prefs.getInt(cartQtyKey) ?? 0;

    notifyListeners();
  }

  // Clear saved role (for logout or reset)

  /* 
  USAGE EXAMPLE (How to use the new flag function):
  
  1. During Login (in your LoginViewModel or Screen):
     final sharedPref = Provider.of<SharedPrefViewModel>(context, listen: false);
     if (loginModel.data != null && loginModel.data!.isNotEmpty) {
       // Pass the country name from the login response
       await sharedPref.saveUserCountryFlag(loginModel.data!.first.country ?? "");
     }

  2. Displaying the Flag (in your UI):
     Consumer<SharedPrefViewModel>(
       builder: (context, pref, child) {
         return Text("User Flag Code: ${pref.getFlag}"); 
         // Example: If flag is "IN", you can use it to fetch an asset or emoji
       },
     );
  */
}
