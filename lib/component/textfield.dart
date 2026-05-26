import '../libs.dart';

class CompTextField {
  /// ------------------------------------------------------------
  /// GLOBAL
  /// ------------------------------------------------------------

  static final themeChangerViewModel = Provider.of<ThemeChangerViewModel>(
    navigatorKey.currentContext!,
    listen: false,
  );
  static TextStyle get textStyle => TextStyle(
    fontSize: 12,
    color: themeChangerViewModel.getBlackColor,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get hintStyle => TextStyle(
    fontSize: 14,
    color: themeChangerViewModel.getGreyColor.withValues(alpha: 0.6),
  );

  static InputDecoration decoration(String hint) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hint,
      hintStyle: hintStyle,
      counterText: "",
    );
  }

  /// ------------------------------------------------------------
  /// COMMON FIELD CONTAINER
  /// ------------------------------------------------------------

  static Widget textFieldContainer({
    required Widget child,
    Widget? prefixIcon,
    Widget? suffixIcon,
    double? height,
  }) {
    return Container(
      height: height ?? 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: themeChangerViewModel.getWhiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeChangerViewModel.getGreyColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            IconTheme(
              data: IconThemeData(
                color: themeChangerViewModel.getPrimaryColor,
                size: 22,
              ),
              child: prefixIcon,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(child: child),
          if (suffixIcon != null) ...[
            const SizedBox(width: 12),
            IconTheme(
              data: IconThemeData(
                color: themeChangerViewModel.getGreyColor,
                size: 22,
              ),
              child: suffixIcon,
            ),
          ],
        ],
      ),
    );
  }

  /// ------------------------------------------------------------
  /// NAME FIELD
  /// ------------------------------------------------------------

  static Widget name({
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    TextEditingController? controller,
    String hint = "Enter name",
    bool isEnable = true,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    controller ??= TextEditingController();

    return textFieldContainer(
      prefixIcon: const Icon(Icons.person_outline),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: isEnable,
        maxLength: 50,
        style: textStyle,
        decoration: decoration(hint),
        validator:
            validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return "Name is required";
              }
              return null;
            },
        onChanged: onChanged,
        onFieldSubmitted: (value) {
          if (nextFocusNode != null) {
            CompFunctions.fieldFocusChange(
              currentFocusNode: focusNode ?? FocusNode(),
              nextFocusNode: nextFocusNode,
            );
          }
        },
      ),
    );
  }

  /// ------------------------------------------------------------
  /// EMAIL FIELD
  /// ------------------------------------------------------------

  static Widget email({
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    TextEditingController? controller,
    String hint = "Enter email",
    bool isEnable = true,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    controller ??= TextEditingController();

    return textFieldContainer(
      prefixIcon: const Icon(Icons.email_outlined),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: isEnable,
        keyboardType: TextInputType.emailAddress,
        style: textStyle,
        decoration: decoration(hint),
        validator:
            validator ??
            (val) {
              if (val == null || val.isEmpty) {
                return "Email cannot be empty";
              }

              if (!RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+',
              ).hasMatch(val)) {
                return "Enter valid email";
              }

              return null;
            },
        onChanged: onChanged,
      ),
    );
  }

  /// ------------------------------------------------------------
  /// MOBILE FIELD
  /// ------------------------------------------------------------

  static Widget mobile({
    TextEditingController? controller,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    ValueChanged<String>? onChange,
    String countryCode = "+91",
    String countryFlag = "🇮🇳",
    VoidCallback? onCountryTap,
    String hint = "Enter your mobile number",
    String? Function(String?)? validator,
    int? maxLength,
    TextInputAction? textInputAction,
  }) {
    controller ??= TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: themeChangerViewModel.getWhiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.grey, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            InkWell(
              onTap: onCountryTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    countryFlag,
                    style: TextStyle(
                      fontSize: 15,
                      color: themeChangerViewModel.getPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_drop_down,
                    color: themeChangerViewModel.getPrimaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    countryCode,
                    style: TextStyle(
                      fontSize: 14,
                      color: themeChangerViewModel.getPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                maxLength: maxLength ?? 10,
                keyboardType: TextInputType.phone,
                textInputAction:
                    textInputAction ??
                    (nextFocusNode != null
                        ? TextInputAction.next
                        : TextInputAction.done),
                style: textStyle,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  onChange?.call(value);

                  if (maxLength != null &&
                      value.length == maxLength &&
                      nextFocusNode != null) {
                    CompFunctions.fieldFocusChange(
                      currentFocusNode: focusNode!,
                      nextFocusNode: nextFocusNode,
                    );
                  } else if (maxLength == null &&
                      value.length == 10 &&
                      nextFocusNode != null) {
                    CompFunctions.fieldFocusChange(
                      currentFocusNode: focusNode!,
                      nextFocusNode: nextFocusNode,
                    );
                  }
                },
                decoration: decoration(hint),
                validator:
                    validator ??
                    (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a valid mobile number";
                      }
                      if (maxLength != null) {
                        if (value.length != maxLength) {
                          return "Mobile number must be $maxLength digits";
                        }
                      } else {
                        if (value.length < 7 || value.length > 15) {
                          return "Invalid mobile number";
                        }
                      }
                      return null;
                    },
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  /// ------------------------------------------------------------
  /// PASSWORD FIELD
  /// ------------------------------------------------------------

  static Widget password({
    required ValueNotifier<bool> obscurePassword,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    TextEditingController? controller,
    String hint = "Enter password",
    bool isEnable = true,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    controller ??= TextEditingController();

    return ValueListenableBuilder(
      valueListenable: obscurePassword,
      builder: (context, value, child) {
        return textFieldContainer(
          prefixIcon: const Icon(Icons.lock_outline, size: 20),
          suffixIcon: InkWell(
            onTap: () {
              obscurePassword.value = !value;
            },
            child: Icon(
              value ? Icons.visibility_outlined : Icons.visibility_off,
              size: 20,
            ),
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            enabled: isEnable,
            obscureText: value,
            maxLength: 20,
            style: textStyle,
            decoration: decoration(hint),
            validator: validator,
            onChanged: onChanged,
          ),
        );
      },
    );
  }

  /// ------------------------------------------------------------
  /// GENERIC TEXT FIELD
  /// ------------------------------------------------------------

  static Widget text({
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    TextEditingController? controller,
    String hint = "Enter text",
    bool isEnable = true,
    Widget? prefixIcon,
    Widget? suffixIcon,
    int maxLength = 70,
    int maxLine = 1,
    double? height,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
    String? Function(String?)? validator,
  }) {
    controller ??= TextEditingController();

    return textFieldContainer(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      height: height,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: isEnable,
        maxLength: maxLength,
        maxLines: maxLine,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: textStyle,
        decoration: decoration(hint),
        validator:
            validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return "$hint is required";
              }
              return null;
            },
        onChanged: onChanged,
        onFieldSubmitted: (value) {
          if (nextFocusNode != null) {
            CompFunctions.fieldFocusChange(
              currentFocusNode: focusNode ?? FocusNode(),
              nextFocusNode: nextFocusNode,
            );
          }
        },
      ),
    );
  }

  /// ------------------------------------------------------------
  /// DATE PICKER FIELD
  /// ------------------------------------------------------------

  static Widget datePicker({
    required TextEditingController controller,
    required VoidCallback onTap,
    String hint = "Select date",
  }) {
    return textFieldContainer(
      prefixIcon: const Icon(Icons.calendar_today),
      child: TextField(
        controller: controller,
        readOnly: true,
        style: textStyle,
        onTap: onTap,
        decoration: decoration(hint),
      ),
    );
  }

  /// ------------------------------------------------------------
  /// DROPDOWN FIELD
  /// ------------------------------------------------------------

  /// ------------------------------------------------------------
  /// DROPDOWN FIELD
  /// ------------------------------------------------------------

  static Widget dropdown({
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
    String hint = "Select option",
    bool isEnable = true,
  }) {
    /// ensure value exists in list
    String? safeValue = items.contains(value) ? value : null;

    return textFieldContainer(
      suffixIcon: Icon(
        Icons.keyboard_arrow_down,
        color: themeChangerViewModel.getPrimaryColor,
      ),
      child: DropdownButtonFormField<String>(
        value: safeValue,
        isExpanded: true,
        icon: const SizedBox(),
        style: hintStyle,
        dropdownColor: themeChangerViewModel.getWhiteColor,
        decoration: decoration(hint),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: textStyle),
          );
        }).toList(),
        onChanged: isEnable ? onChanged : null,
      ),
    );
  }

  // static Widget dropdown({
  //   required List<String> items,
  //   required String? value,
  //   required ValueChanged<String?> onChanged,
  //   String hint = "Select option",
  //   bool isEnable = true,
  // }) {
  //   return _container(
  //     suffixIcon: Icon(
  //       Icons.keyboard_arrow_down,
  //       color: themeChangerViewModel.primaryColor,
  //     ),
  //     child: DropdownButtonFormField<String>(
  //       value: value,
  //       isExpanded: true,
  //       icon: const SizedBox(),
  //       style: _textStyle,
  //       dropdownColor: themeChangerViewModel.getWhiteColor,
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: hint,
  //         hintStyle: _hintStyle,
  //       ),

  //       /// convert String list → DropdownMenuItem
  //       items: items.map((item) {
  //         return DropdownMenuItem<String>(
  //           value: item,
  //           child: Text(item, style: _textStyle),
  //         );
  //       }).toList(),

  //       onChanged: isEnable ? onChanged : null,
  //     ),
  //   );
  // }
}

// import '../libs.dart';

// class CompTextField {
//   /// ------------------------------------------------------------
//   /// GLOBAL
//   /// ------------------------------------------------------------

//   static final themeChangerViewModel = Provider.of<ThemeChangerViewModel>(
//     navigatorKey.currentContext!,
//     listen: false,
//   );

//   /// ------------------------------------------------------------
//   /// COMMON FIELD CONTAINER
//   /// ------------------------------------------------------------

//   static Widget _container({
//     required Widget child,
//     Widget? prefixIcon,
//     Widget? suffixIcon,
//   }) {
//     return Container(
//       height: 55,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       decoration: BoxDecoration(
//         color: themeChangerViewModel.getWhiteColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColor.grey),
//       ),
//       child: Row(
//         children: [
//           if (prefixIcon != null) ...[prefixIcon, const SizedBox(width: 10)],

//           Expanded(child: child),

//           if (suffixIcon != null) suffixIcon,
//         ],
//       ),
//     );
//   }

//   /// ------------------------------------------------------------
//   /// NAME FIELD
//   /// ------------------------------------------------------------

//   static Widget name({
//     FocusNode? focusNode,
//     FocusNode? nextFocusNode,
//     TextEditingController? controller,
//     String hint = "Enter name",
//     bool isEnable = true,
//     ValueChanged<String>? onChanged,
//     String? Function(String?)? validator,
//   }) {
//     controller ??= TextEditingController();

//     return _container(
//       prefixIcon: const Icon(Icons.person_outline),
//       child: TextFormField(
//         controller: controller,
//         focusNode: focusNode,
//         enabled: isEnable,
//         maxLength: 50,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           counterText: "",
//           hintText: hint,
//         ),
//         validator:
//             validator ??
//             (value) {
//               if (value == null || value.isEmpty) {
//                 return "Name is required";
//               }
//               return null;
//             },
//         onChanged: onChanged,
//         onFieldSubmitted: (value) {
//           if (nextFocusNode != null) {
//             CompFunctions.fieldFocusChange(
//               currentFocusNode: focusNode ?? FocusNode(),
//               nextFocusNode: nextFocusNode,
//             );
//           }
//         },
//       ),
//     );
//   }

//   /// ------------------------------------------------------------
//   /// EMAIL FIELD
//   /// ------------------------------------------------------------

//   static Widget email({
//     FocusNode? focusNode,
//     FocusNode? nextFocusNode,
//     TextEditingController? controller,
//     String hint = "Enter email",
//     bool isEnable = true,
//     ValueChanged<String>? onChanged,
//     String? Function(String?)? validator,
//   }) {
//     controller ??= TextEditingController();

//     return _container(
//       prefixIcon: const Icon(Icons.email_outlined),
//       child: TextFormField(
//         controller: controller,
//         focusNode: focusNode,
//         enabled: isEnable,
//         keyboardType: TextInputType.emailAddress,
//         decoration: InputDecoration(border: InputBorder.none, hintText: hint),
//         validator:
//             validator ??
//             (val) {
//               if (val == null || val.isEmpty) {
//                 return "Email cannot be empty";
//               }

//               if (!RegExp(
//                 r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+',
//               ).hasMatch(val)) {
//                 return "Enter valid email";
//               }

//               return null;
//             },
//         onChanged: onChanged,
//       ),
//     );
//   }

//   /// ------------------------------------------------------------
//   /// MOBILE FIELD
//   /// ------------------------------------------------------------

//   static Widget mobile({
//     TextEditingController? controller,
//     FocusNode? focusNode,
//     FocusNode? nextFocusNode,
//     ValueChanged<String>? onChange,
//     String countryCode = "+91",
//     String countryFlag = "🇮🇳",
//     VoidCallback? onCountryTap,
//   }) {
//     controller ??= TextEditingController();

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
//       child: Container(
//         height: 55,
//         decoration: BoxDecoration(
//           color: themeChangerViewModel.getWhiteColor,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppColor.grey, width: 1),
//         ),
//         child: Row(
//           children: [
//             const SizedBox(width: 12),

//             InkWell(
//               onTap: onCountryTap,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   /// Country Flag
//                   Text(
//                     countryFlag,
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: themeChangerViewModel.primaryColor,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(width: 5),
//                   Icon(
//                     Icons.arrow_drop_down,
//                     color: themeChangerViewModel.primaryColor,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 5),

//                   /// Country Code
//                   Text(
//                     countryCode,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: themeChangerViewModel.primaryColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(width: 12),

//             /// Text Field (with focusNode + nextFocusNode)
//             Expanded(
//               child: TextFormField(
//                 controller: controller,
//                 focusNode: focusNode,
//                 maxLength: 10,
//                 keyboardType: TextInputType.phone,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 onChanged: (value) {
//                   onChange?.call(value);

//                   /// Move to next field automatically
//                   if (value.length == 10 && nextFocusNode != null) {
//                     CompFunctions.fieldFocusChange(
//                       currentFocusNode: focusNode!,
//                       nextFocusNode: nextFocusNode!,
//                     );
//                   }
//                 },
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   counterText: "",
//                   hintText: "Enter your 10-digit mobile number",
//                   hintStyle: TextStyle(
//                     color: themeChangerViewModel.getGreyColor,
//                     fontSize: 12,
//                   ),
//                 ),
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: themeChangerViewModel.primaryColor,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter a valid mobile number";
//                   }
//                   if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
//                     return "Invalid mobile number";
//                   }
//                   return null;
//                 },
//               ),
//             ),

//             const SizedBox(width: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   // static Widget mobile({
//   //   FocusNode? focusNode,
//   //   FocusNode? nextFocusNode,
//   //   TextEditingController? controller,
//   //   String hint = "Enter mobile number",
//   //   bool isEnable = true,
//   //   ValueChanged<String>? onChanged,
//   //   String? Function(String?)? validator,
//   // }) {
//   //   controller ??= TextEditingController();

//   //   return _container(
//   //     prefixIcon: Row(
//   //       mainAxisSize: MainAxisSize.min,
//   //       children: const [
//   //         Text("+91"),
//   //         SizedBox(width: 6),
//   //         Icon(Icons.phone_android),
//   //       ],
//   //     ),
//   //     child: TextFormField(
//   //       controller: controller,
//   //       focusNode: focusNode,
//   //       enabled: isEnable,
//   //       keyboardType: TextInputType.phone,
//   //       maxLength: 10,
//   //       decoration: InputDecoration(
//   //         border: InputBorder.none,
//   //         counterText: "",
//   //         hintText: hint,
//   //       ),
//   //       validator:
//   //           validator ??
//   //           (value) {
//   //             if (value == null || value.isEmpty) {
//   //               return "Enter mobile number";
//   //             }

//   //             if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
//   //               return "Invalid mobile number";
//   //             }

//   //             return null;
//   //           },
//   //       onChanged: onChanged,
//   //     ),
//   //   );
//   // }

//   /// ------------------------------------------------------------
//   /// PASSWORD FIELD
//   /// ------------------------------------------------------------

//   static Widget password({
//     required ValueNotifier<bool> obscurePassword,
//     FocusNode? focusNode,
//     FocusNode? nextFocusNode,
//     TextEditingController? controller,
//     String hint = "Enter password",
//     bool isEnable = true,
//     ValueChanged<String>? onChanged,
//     String? Function(String?)? validator,
//   }) {
//     controller ??= TextEditingController();

//     return ValueListenableBuilder(
//       valueListenable: obscurePassword,
//       builder: (context, value, child) {
//         return _container(
//           prefixIcon: const Icon(Icons.lock_outline),
//           suffixIcon: InkWell(
//             onTap: () {
//               obscurePassword.value = !value;
//             },
//             child: Icon(value ? Icons.visibility_off : Icons.visibility),
//           ),
//           child: TextFormField(
//             controller: controller,
//             focusNode: focusNode,
//             enabled: isEnable,
//             obscureText: value,
//             maxLength: 20,
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               counterText: "",
//               hintText: hint,
//             ),
//             validator: validator,
//             onChanged: onChanged,
//           ),
//         );
//       },
//     );
//   }

//   /// ------------------------------------------------------------
//   /// NUMBER FIELD
//   /// ------------------------------------------------------------

//   static Widget number({
//     FocusNode? focusNode,
//     FocusNode? nextFocusNode,
//     TextEditingController? controller,
//     String hint = "Enter number",
//     bool isEnable = true,
//     ValueChanged<String>? onChanged,
//     String? Function(String?)? validator,
//   }) {
//     controller ??= TextEditingController();

//     return _container(
//       prefixIcon: const Icon(Icons.numbers),
//       child: TextFormField(
//         controller: controller,
//         focusNode: focusNode,
//         enabled: isEnable,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(border: InputBorder.none, hintText: hint),
//         validator: validator,
//         onChanged: onChanged,
//       ),
//     );
//   }

//   /// ------------------------------------------------------------
//   /// DROPDOWN FIELD
//   /// ------------------------------------------------------------

//   static Widget dropdown({
//     required List<String> items,
//     required String? value,
//     required ValueChanged<String?> onChanged,
//     String hint = "Select option",
//     bool isEnable = true,
//   }) {
//     return _container(
//       prefixIcon: const Icon(Icons.arrow_drop_down_circle_outlined),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           hint: Text(hint),
//           isExpanded: true,
//           items: items.map((item) {
//             return DropdownMenuItem(value: item, child: Text(item));
//           }).toList(),
//           onChanged: isEnable ? onChanged : null,
//         ),
//       ),
//     );
//   }

//   /// ------------------------------------------------------------
//   /// SEARCH FIELD
//   /// ------------------------------------------------------------

//   static Widget search({
//     FocusNode? focusNode,
//     TextEditingController? controller,
//     String hint = "Search",
//     ValueChanged<String>? onChanged,
//   }) {
//     controller ??= TextEditingController();

//     return _container(
//       prefixIcon: const Icon(Icons.search),
//       child: TextField(
//         controller: controller,
//         focusNode: focusNode,
//         decoration: InputDecoration(border: InputBorder.none, hintText: hint),
//         onChanged: onChanged,
//       ),
//     );
//   }

//   /// ------------------------------------------------------------
//   /// ADDRESS FIELD
//   /// ------------------------------------------------------------

//   static Widget address({
//     FocusNode? focusNode,
//     TextEditingController? controller,
//     String hint = "Enter address",
//     bool isEnable = true,
//     int maxLine = 3,
//     ValueChanged<String>? onChanged,
//   }) {
//     controller ??= TextEditingController();

//     return Container(
//       padding: const EdgeInsets.all(12),
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       decoration: BoxDecoration(
//         color: themeChangerViewModel.getWhiteColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColor.grey),
//       ),
//       child: TextFormField(
//         controller: controller,
//         focusNode: focusNode,
//         enabled: isEnable,
//         maxLines: maxLine,
//         decoration: InputDecoration(border: InputBorder.none, hintText: hint),
//         onChanged: onChanged,
//       ),
//     );
//   }

//   /// ------------------------------------------------------------
//   /// GENERIC TEXT FIELD
//   /// ------------------------------------------------------------

//   static Widget text({
//     FocusNode? focusNode,
//     FocusNode? nextFocusNode,
//     TextEditingController? controller,
//     String hint = "Enter text",
//     bool isEnable = true,
//     Widget? prefixIcon,
//     Widget? suffixIcon,
//     int maxLength = 70,
//     int maxLine = 1,
//     TextInputType keyboardType = TextInputType.text,
//     ValueChanged<String>? onChanged,
//     String? Function(String?)? validator,
//   }) {
//     controller ??= TextEditingController();

//     return _container(
//       prefixIcon: prefixIcon,
//       suffixIcon: suffixIcon,
//       child: TextFormField(
//         controller: controller,
//         focusNode: focusNode,
//         enabled: isEnable,
//         maxLength: maxLength,
//         maxLines: maxLine,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           counterText: "",
//           hintText: hint,
//         ),
//         validator:
//             validator ??
//             (value) {
//               if (value == null || value.isEmpty) {
//                 return "$hint is required";
//               }
//               return null;
//             },
//         onChanged: onChanged,
//         onFieldSubmitted: (value) {
//           if (nextFocusNode != null) {
//             CompFunctions.fieldFocusChange(
//               currentFocusNode: focusNode ?? FocusNode(),
//               nextFocusNode: nextFocusNode,
//             );
//           }
//         },
//       ),
//     );
//   }

//   /// ------------------------------------------------------------
//   /// DATE PICKER FIELD
//   /// ------------------------------------------------------------

//   static Widget datePicker({
//     required TextEditingController controller,
//     required VoidCallback onTap,
//     String hint = "Select date",
//   }) {
//     return _container(
//       prefixIcon: const Icon(Icons.calendar_today),
//       child: TextField(
//         controller: controller,
//         readOnly: true,
//         onTap: onTap,
//         decoration: InputDecoration(border: InputBorder.none, hintText: hint),
//       ),
//     );
//   }
// }

// import 'package:animated_search_bar/animated_search_bar.dart';

// import '../libs.dart';

// class CompTextField {
//   static final themeChangerViewModel = Provider.of<ThemeChangerViewModel>(
//     navigatorKey.currentContext!,
//     listen: false,
//   );
//   static Widget email({
//     FocusNode? focusNode,
//     TextEditingController? controller,
//     FocusNode? nextFocusNode,
//   }) {
//     controller ??= TextEditingController();

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//       child: Container(
//         height: 55,
//         decoration: BoxDecoration(
//           color: themeChangerViewModel.getWhiteColor,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppColor.grey, width: 1),
//         ),
//         child: Row(
//           children: [
//             const SizedBox(width: 12),

//             // PREFIX ICON
//             Icon(
//               Icons.email_outlined,
//               color: themeChangerViewModel.primaryColor,
//             ),

//             const SizedBox(width: 12),

//             // MAIN INPUT
//             Expanded(
//               child: TextFormField(
//                 controller: controller,
//                 focusNode: focusNode,
//                 maxLength: 35,
//                 keyboardType: TextInputType.emailAddress,
//                 cursorColor: themeChangerViewModel.getBlackColor,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,

//                 style: TextStyle(
//                   color: themeChangerViewModel.getBlackColor,
//                   fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//                 ),

//                 decoration: InputDecoration(
//                   hintText: "Enter email",
//                   hintStyle: TextStyle(
//                     color: themeChangerViewModel.getGreyColor,
//                     fontSize: 12,
//                   ),
//                   border: InputBorder.none,
//                   counterText: "",
//                 ),

//                 // VALIDATOR
//                 validator: (val) {
//                   if (val == null || val.isEmpty) {
//                     return 'Email cannot be empty';
//                   }

//                   final emailPattern =
//                       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
//                   final isValid = RegExp(emailPattern).hasMatch(val);

//                   if (!isValid) {
//                     return 'Enter a valid email address';
//                   }

//                   return null;
//                 },

//                 // MOVE TO NEXT FIELD ON COMPLETE DOMAIN
//                 onChanged: (val) {
//                   if (val.endsWith('@gmail.com') ||
//                       val.endsWith('@outlook.com') ||
//                       val.endsWith('@yahoo.com')) {
//                     CompFunctions.fieldFocusChange(
//                       currentFocusNode: focusNode ?? FocusNode(),
//                       nextFocusNode: nextFocusNode ?? FocusNode(),
//                     );
//                   }
//                 },
//               ),
//             ),

//             const SizedBox(width: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget gender({
//     required String? value,
//     required Function(String?) onChanged,
//   }) {
//     List<String> genderList = ["Male", "Female", "Other"];

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//       child: Container(
//         height: 55,
//         padding: EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           color: themeChangerViewModel.getWhiteColor,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppColor.grey, width: 1),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               Icons.person_outline,
//               color: themeChangerViewModel.primaryColor,
//             ),

//             const SizedBox(width: 12),

//             Expanded(
//               child: DropdownButtonFormField<String>(
//                 value: (value != null && genderList.contains(value))
//                     ? value
//                     : null,

//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   isDense: true,
//                   contentPadding: EdgeInsets.zero,
//                   hintText: "Select Gender",
//                   hintStyle: TextStyle(
//                     color: themeChangerViewModel.getGreyColor,
//                     fontSize: 12,
//                   ),
//                 ),

//                 icon: Icon(
//                   Icons.arrow_drop_down,
//                   color: themeChangerViewModel.primaryColor,
//                 ),

//                 style: TextStyle(
//                   fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//                   color: themeChangerViewModel.getBlackColor,
//                 ),

//                 items: genderList
//                     .map(
//                       (gender) =>
//                           DropdownMenuItem(value: gender, child: Text(gender)),
//                     )
//                     .toList(),

//                 validator: (val) {
//                   if (val == null || val.isEmpty) {
//                     return "Select gender";
//                   }
//                   return null;
//                 },

//                 onChanged: onChanged,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   static datePicker({
//     FocusNode? focusNode,
//     TextEditingController? controller,
//     FocusNode? nextFocusNode,
//     BuildContext? context,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//       child: SizedBox(
//         child: TextFormField(
//           cursorColor: themeChangerViewModel.getBlackColor,
//           focusNode: focusNode,
//           style: TextStyle(
//             color: themeChangerViewModel.getBlackColor,
//             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//           ),
//           textAlignVertical: TextAlignVertical.center,
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.all(0),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 width: 1,
//                 color: themeChangerViewModel.getBlackColor,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: themeChangerViewModel.getBlackColor,
//                 width: 1,
//               ),
//             ),
//             filled: true,
//             fillColor: themeChangerViewModel.getWhiteColor,
//             hintText: "Select date",
//             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
//             prefixIcon: Icon(
//               Icons.calendar_today_outlined,
//               color: themeChangerViewModel.getPrimaryColor,
//             ),
//           ),
//           controller: controller,
//           readOnly: true,
//           onTap: () async {
//             if (context != null) {
//               DateTime? pickedDate = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(1900),
//                 lastDate: DateTime.now(),
//                 builder: (BuildContext context, Widget? child) {
//                   return Theme(
//                     data: ThemeData.light().copyWith(
//                       colorScheme: ColorScheme.light(
//                         primary: themeChangerViewModel.getPrimaryColor,
//                         onPrimary: themeChangerViewModel.getWhiteColor,
//                         surface: themeChangerViewModel.getWhiteColor,
//                         onSurface: themeChangerViewModel.getBlackColor,
//                       ),
//                       dialogBackgroundColor:
//                           themeChangerViewModel.getWhiteColor,
//                     ),
//                     child: child ?? SizedBox.shrink(),
//                   );
//                 },
//               );

//               if (pickedDate != null) {
//                 String formattedDate =
//                     "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
//                 controller?.text = formattedDate;

//                 // Automatically move to the next field if applicable
//                 CompFunctions.fieldFocusChange(
//                   currentFocusNode: focusNode ?? FocusNode(),
//                   nextFocusNode: nextFocusNode ?? FocusNode(),
//                 );
//               }
//             }
//           },
//           validator: (val) {
//             if (val == null || val.isEmpty) {
//               return 'Date cannot be empty';
//             }
//             return null;
//           },
//         ),
//       ),
//     );
//   }

//   static password({
//     FocusNode? focusNode,
//     TextEditingController? controller,
//     FocusNode? nextFocusNode,
//     String? Function(String?)? validator,
//     required ValueNotifier<bool> obscurePassword,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//       child: SizedBox(
//         height: 70,
//         child: ValueListenableBuilder(
//           valueListenable: obscurePassword,
//           builder: (context, value, child) {
//             return TextFormField(
//               onFieldSubmitted: (va) {
//                 CompFunctions.fieldFocusChange(
//                   currentFocusNode: focusNode ?? FocusNode(),
//                   nextFocusNode: nextFocusNode ?? FocusNode(),
//                 );
//               },
//               obscureText: obscurePassword.value,
//               obscuringCharacter: "*",
//               cursorColor: themeChangerViewModel.getBlackColor,
//               maxLength: 20,
//               focusNode: focusNode,
//               style: TextStyle(
//                 color: themeChangerViewModel.getBlackColor,
//                 fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//               ),
//               textAlignVertical: TextAlignVertical.center,
//               decoration: InputDecoration(
//                 contentPadding: const EdgeInsets.all(0),
//                 counterText: "",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(
//                     color: themeChangerViewModel.getBlackColor,
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(
//                     color: themeChangerViewModel.getBlackColor,
//                     width: 1,
//                   ),
//                 ),
//                 filled: true,
//                 fillColor: themeChangerViewModel.getWhiteColor,
//                 hintText: "Enter password",
//                 hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
//                 prefixIcon: Icon(
//                   Icons.lock_outline_rounded,
//                   color: themeChangerViewModel.getBlackColor,
//                 ),
//                 suffixIcon: InkWell(
//                   onTap: () {
//                     obscurePassword.value = !obscurePassword.value;
//                   },
//                   child: Icon(
//                     obscurePassword.value
//                         ? Icons.visibility_off_outlined
//                         : Icons.visibility,
//                     color: themeChangerViewModel.getGreyColor,
//                   ),
//                 ),
//               ),
//               controller: controller,
//               keyboardType: TextInputType.emailAddress,
//               validator:
//                   validator ??
//                   (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter password'; // Validation for empty field
//                     }
//                     return null;
//                   },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   static searchField({
//     Key? key,
//     TextEditingController? controller,
//     FocusNode? focusNode,
//     bool? enabled,
//     GestureTapCallback? onTap,
//     FocusNode? nextFocusNode,
//     ValueChanged<String>? onChange,
//     String hint = "Search...",
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
//       child: InkWell(
//         onTap: (enabled ?? true) ? null : onTap,
//         child: SizedBox(
//           height: 50,
//           child: TextFormField(
//             key: key,
//             enabled: enabled,
//             autovalidateMode: AutovalidateMode.disabled,
//             cursorColor: themeChangerViewModel.primaryColor,
//             controller: controller,
//             onFieldSubmitted: (val) {
//               CompFunctions.fieldFocusChange(
//                 currentFocusNode: focusNode ?? FocusNode(),
//                 nextFocusNode: nextFocusNode ?? FocusNode(),
//               );
//             },
//             focusNode: focusNode,
//             style: TextStyle(
//               fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//               color: themeChangerViewModel.primaryColor,
//             ),
//             textAlignVertical: TextAlignVertical.center,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                   color: themeChangerViewModel.getPrimaryColor,
//                   width: 1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                   color: themeChangerViewModel.getPrimaryColor,
//                   width: 1,
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(
//                   color: themeChangerViewModel.getPrimaryColor,
//                   width: 1,
//                 ),
//               ),
//               prefixIcon: Icon(
//                 Icons.search,
//                 color: themeChangerViewModel.getGreyColor,
//               ),
//               fillColor: themeChangerViewModel.getWhiteColor,
//               filled: true,
//               contentPadding: const EdgeInsets.all(0),
//               isDense: true,
//               errorBorder: InputBorder.none,
//               errorText: null,
//               hintText: hint,
//               hintStyle: TextStyle(
//                 fontSize: 12,
//                 color: themeChangerViewModel.getGreyColor,
//               ),
//               counterText: "",
//               errorStyle: const TextStyle(),
//             ),
//             onChanged: onChange,
//           ),
//         ),
//       ),
//     );
//   }

//   static Widget mobile({
//     TextEditingController? controller,
//     FocusNode? focusNode,
//     FocusNode? nextFocusNode,
//     ValueChanged<String>? onChange,
//     String countryCode = "+91",
//     String countryFlag = "🇮🇳",
//     VoidCallback? onCountryTap,
//   }) {
//     controller ??= TextEditingController();

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//       child: Container(
//         height: 55,
//         decoration: BoxDecoration(
//           color: themeChangerViewModel.getWhiteColor,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppColor.grey, width: 1),
//         ),
//         child: Row(
//           children: [
//             const SizedBox(width: 12),

//             InkWell(
//               onTap: onCountryTap,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   /// Country Flag
//                   Text(
//                     countryFlag,
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: themeChangerViewModel.primaryColor,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(width: 5),
//                   Icon(
//                     Icons.arrow_drop_down,
//                     color: themeChangerViewModel.primaryColor,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 5),

//                   /// Country Code
//                   Text(
//                     countryCode,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: themeChangerViewModel.primaryColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(width: 12),

//             /// Text Field (with focusNode + nextFocusNode)
//             Expanded(
//               child: TextFormField(
//                 controller: controller,
//                 focusNode: focusNode,
//                 maxLength: 10,
//                 keyboardType: TextInputType.phone,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 onChanged: (value) {
//                   onChange?.call(value);

//                   /// Move to next field automatically
//                   if (value.length == 10 && nextFocusNode != null) {
//                     CompFunctions.fieldFocusChange(
//                       currentFocusNode: focusNode!,
//                       nextFocusNode: nextFocusNode!,
//                     );
//                   }
//                 },
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   counterText: "",
//                   hintText: "Enter your 10-digit mobile number",
//                   hintStyle: TextStyle(
//                     color: themeChangerViewModel.getGreyColor,
//                     fontSize: 12,
//                   ),
//                 ),
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: themeChangerViewModel.primaryColor,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter a valid mobile number";
//                   }
//                   if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
//                     return "Invalid mobile number";
//                   }
//                   return null;
//                 },
//               ),
//             ),

//             const SizedBox(width: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   // static Widget mobile({
//   //   TextEditingController? controller,
//   //   FocusNode? focusNode,
//   //   FocusNode? nextFocusNode,
//   //   ValueChanged<String>? onChange,
//   // }) {
//   //   controller ??= TextEditingController();

//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//   //     child: Container(
//   //       height: 55,
//   //       decoration: BoxDecoration(
//   //         color: themeChangerViewModel.getWhiteColor,
//   //         borderRadius: BorderRadius.circular(12),
//   //         border: Border.all(color: AppColor.grey, width: 1),
//   //       ),
//   //       child: Row(
//   //         children: [
//   //           const SizedBox(width: 12),

//   //           /// India Flag
//   //           Text(
//   //             "🇮🇳",
//   //             style: TextStyle(
//   //               fontSize: 15,
//   //               color: themeChangerViewModel.primaryColor,
//   //               fontWeight: FontWeight.w700,
//   //             ),
//   //           ),

//   //           const SizedBox(width: 10),

//   //           /// Country Code
//   //           Text(
//   //             "+91",
//   //             style: TextStyle(
//   //               fontSize: 14,
//   //               color: themeChangerViewModel.primaryColor,
//   //               fontWeight: FontWeight.w600,
//   //             ),
//   //           ),

//   //           const SizedBox(width: 12),

//   //           /// Text Field (with focusNode + nextFocusNode)
//   //           Expanded(
//   //             child: TextFormField(
//   //               controller: controller,
//   //               focusNode: focusNode,
//   //               maxLength: 10,
//   //               keyboardType: TextInputType.phone,
//   //               autovalidateMode: AutovalidateMode.onUserInteraction,
//   //               onChanged: (value) {
//   //                 onChange?.call(value);

//   //                 /// Move to next field automatically
//   //                 if (value.length == 10 && nextFocusNode != null) {
//   //                   CompFunctions.fieldFocusChange(
//   //                     currentFocusNode: focusNode!,
//   //                     nextFocusNode: nextFocusNode!,
//   //                   );
//   //                 }
//   //               },
//   //               decoration: InputDecoration(
//   //                 border: InputBorder.none,
//   //                 counterText: "",
//   //                 hintText: "Enter your 10-digit mobile number",
//   //                 hintStyle: TextStyle(
//   //                   color: themeChangerViewModel.getGreyColor,
//   //                   fontSize: 12,
//   //                 ),
//   //               ),
//   //               style: TextStyle(
//   //                 fontSize: 15,
//   //                 color: themeChangerViewModel.primaryColor,
//   //               ),
//   //               validator: (value) {
//   //                 if (value == null || value.isEmpty) {
//   //                   return "Please enter a valid mobile number";
//   //                 }
//   //                 if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
//   //                   return "Invalid mobile number";
//   //                 }
//   //                 return null;
//   //               },
//   //             ),
//   //           ),

//   //           const SizedBox(width: 10),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   static Widget text({
//     FocusNode? focusNode,
//     String hint = "Enter text",
//     ValueChanged<String>? onChanged,
//     TextEditingController? controller,
//     Widget? prefixIcon,
//     FocusNode? nextFocusNode,
//     String? Function(String?)? validator,
//     bool enabled = true,
//   }) {
//     controller ??= TextEditingController();

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//       child: Container(
//         height: 55,
//         decoration: BoxDecoration(
//           color: themeChangerViewModel.getWhiteColor,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppColor.grey, width: 1),
//         ),
//         child: Row(
//           children: [
//             if (prefixIcon != null) ...[
//               const SizedBox(width: 12),
//               prefixIcon,
//               const SizedBox(width: 12),
//             ],

//             // MAIN TEXT FIELD
//             Expanded(
//               child: TextFormField(
//                 enabled: enabled,
//                 controller: controller,
//                 focusNode: focusNode,
//                 maxLength: 70,
//                 onChanged: onChanged,
//                 keyboardType: TextInputType.text,
//                 style: TextStyle(
//                   fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//                   color: themeChangerViewModel.getBlackColor,
//                 ),
//                 decoration: InputDecoration(
//                   counterText: "",
//                   contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                   border: InputBorder.none,
//                   hintText: hint,
//                   hintStyle: TextStyle(
//                     color: themeChangerViewModel.getGreyColor,
//                     fontSize: 12,
//                   ),
//                 ),
//                 onFieldSubmitted: (val) {
//                   if (nextFocusNode != null) {
//                     CompFunctions.fieldFocusChange(
//                       currentFocusNode: focusNode ?? FocusNode(),
//                       nextFocusNode: nextFocusNode,
//                     );
//                   } else {
//                     CompFunctions.unFocus();
//                   }
//                 },
//                 validator:
//                     validator ??
//                     (value) {
//                       if (value == null || value.isEmpty) {
//                         return "$hint is required";
//                       }
//                       return null;
//                     },
//               ),
//             ),

//             const SizedBox(width: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   static drawerSearch({
//     FocusNode? focusNode,
//     String hint = "here",
//     ValueChanged<String>? onChanged,
//     TextEditingController? controller,
//     FocusNode? nextFocusNode,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//       child: SizedBox(
//         height: 40,
//         child: TextFormField(
//           cursorColor: themeChangerViewModel.getBlackColor,
//           maxLength: 70,
//           focusNode: focusNode,
//           style: TextStyle(
//             color: themeChangerViewModel.getBlackColor,
//             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//           ),
//           textAlignVertical: TextAlignVertical.center,
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.all(10),
//             counterText: "",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: themeChangerViewModel.getBlackColor,
//                 width: 1,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(
//                 color: themeChangerViewModel.getBlackColor,
//                 width: 1,
//               ),
//             ),
//             filled: true,
//             fillColor: themeChangerViewModel.getWhiteColor,
//             hintText: hint,
//             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
//           ),
//           onChanged: onChanged,
//           onFieldSubmitted: (val) {
//             if (nextFocusNode != null) {
//               CompFunctions.fieldFocusChange(
//                 currentFocusNode: focusNode ?? FocusNode(),
//                 nextFocusNode: nextFocusNode,
//               );
//             } else {
//               CompFunctions.unFocus();
//             }
//           },

//           controller: controller,
//           keyboardType: TextInputType.text, // Adjust based on input type
//         ),
//       ),
//     );
//   }

//   static address({
//     FocusNode? focusNode,
//     TextEditingController? controller,
//     FocusNode? nextFocusNode,
//     ValueChanged<String>? onChanged,
//     String? Function(String?)? validator,
//     String hint = "Enter address here",
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//       child: SizedBox(
//         height: 100,
//         child: TextFormField(
//           cursorColor: themeChangerViewModel.getBlackColor,
//           maxLength: 300,
//           focusNode: focusNode,
//           style: TextStyle(
//             color: themeChangerViewModel.getBlackColor,
//             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//           ),
//           textAlignVertical: TextAlignVertical.top,
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.all(
//               Constants.defaultPagePaddingHorizontally,
//             ),
//             counterText: "",
//             errorStyle: const TextStyle(fontSize: 0),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 color: themeChangerViewModel.getBlackColor,
//                 width: 1,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 color: themeChangerViewModel.getBlackColor,
//                 width: 1,
//               ),
//             ),
//             filled: true,
//             fillColor: themeChangerViewModel.getWhiteColor,
//             hintText: hint,
//             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
//           ),
//           onChanged: onChanged,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               // Return an error string to display the error border
//               return ''; // Returning an empty string to avoid showing a message
//             }
//             return null; // No error, return null
//           },
//           onFieldSubmitted: (val) {
//             CompFunctions.fieldFocusChange(
//               currentFocusNode: focusNode ?? FocusNode(),
//               nextFocusNode: nextFocusNode ?? FocusNode(),
//             );
//           },
//           controller: controller,
//           maxLines: null,
//           expands: true,
//           keyboardType: TextInputType.multiline,
//         ),
//       ),
//     );
//   }

//   static search({
//     required Function(String) onChange,
//     TextEditingController? controller,
//     required String title,
//   }) {
//     return Row(
//       children: [
//         title.whiteTextStyle(
//           enumFontSize: EnumFontSize.small,
//           fw: FontWeight.normal,
//         ),
//         MasterSpacer.w.fifty(),
//         Expanded(
//           child: AnimatedSearchBar(
//             labelStyle: TextStyle(color: themeChangerViewModel.primaryColor),
//             searchIcon: Icon(
//               Icons.search,
//               color: themeChangerViewModel.primaryColor,
//             ),
//             height: 35,
//             controller: controller,
//             cursorColor: themeChangerViewModel.primaryColor,
//             searchDecoration: InputDecoration(
//               filled: true,
//               fillColor: themeChangerViewModel.getWhiteColor,
//               hintText: "Search here",
//               hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
//               contentPadding: const EdgeInsets.symmetric(
//                 vertical: 13,
//                 horizontal: 15,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(
//                   color: themeChangerViewModel.primaryColor,
//                   width: 1,
//                 ),
//               ),
//             ),
//             searchStyle: TextStyle(
//               color: themeChangerViewModel.primaryColor,
//               fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//             ),
//             closeIcon: Icon(
//               Icons.close,
//               color: themeChangerViewModel.primaryColor,
//             ),
//             onChanged: onChange,
//           ),
//         ),
//       ],
//     );
//   }

//   static amount({
//     FocusNode? focusNode,
//     TextEditingController? controller,
//     FocusNode? nextFocusNode,
//     suffixVisible = true,
//     TextAlign textAlign = TextAlign.left,
//     String hint = "Enter amount",
//     GestureTapCallback? onSuffixTap,
//     ValueChanged<String>? onChange,
//     bool enable = true,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
//       child: SizedBox(
//         height: 50,
//         child: TextField(
//           enabled: enable,
//           textAlign: textAlign,
//           cursorColor: themeChangerViewModel.getSecondaryColor,
//           maxLength: 20,
//           focusNode: focusNode,
//           style: TextStyle(
//             color: themeChangerViewModel.getBlackColor,
//             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//           ),
//           textAlignVertical: TextAlignVertical.center,
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.all(
//               Constants.defaultPagePaddingHorizontally,
//             ),
//             counterText: "",
//             errorStyle: const TextStyle(fontSize: 0),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 color: themeChangerViewModel.getBlackColor,
//                 width: 1,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 color: themeChangerViewModel.getBlackColor,
//                 width: 1,
//               ),
//             ),
//             filled: true,
//             fillColor: themeChangerViewModel.getWhiteColor,
//             hintText: hint,
//             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
//           ),
//           onChanged: onChange,
//           onSubmitted: (val) {
//             CompFunctions.fieldFocusChange(
//               currentFocusNode: focusNode ?? FocusNode(),
//               nextFocusNode: nextFocusNode ?? FocusNode(),
//             );
//           },
//           controller: controller,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             // FilteringTextInputFormatter.allow(RegExp(r"^[0-9.]{1,10}$")),
//             TextInputFormatter.withFunction((oldValue, newValue) {
//               final text = newValue.text;

//               // Regular expression to match only decimal digits and a single period (.)
//               final validInput = RegExp(r'^\d{0,8}(\.\d{0,4})?$');

//               if (text.isEmpty || validInput.hasMatch(text)) {
//                 return newValue;
//               } else {
//                 // Check if the old value is empty or matches the valid input pattern
//                 if (oldValue.text.isEmpty ||
//                     validInput.hasMatch(oldValue.text)) {
//                   // Revert to the old value if it's valid
//                   return oldValue;
//                 } else {
//                   // If the old value is also invalid, allow backspace by returning an empty string
//                   return TextEditingValue.empty;
//                 }
//               }
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget number({
//     FocusNode? focusNode,
//     TextEditingController? controller,
//     FocusNode? nextFocusNode,
//     String hint = "Enter number",
//     int maxLength = 6,
//     ValueChanged<String>? onChanged,
//     String? Function(String?)? validator,
//     Widget? prefixIcon,
//   }) {
//     controller ??= TextEditingController();

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 55,
//             decoration: BoxDecoration(
//               color: themeChangerViewModel.getWhiteColor,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: AppColor.grey, width: 1),
//             ),
//             child: Row(
//               children: [
//                 const SizedBox(width: 12),

//                 if (prefixIcon != null) ...[
//                   prefixIcon,
//                   const SizedBox(width: 12),
//                 ],

//                 Expanded(
//                   child: TextFormField(
//                     controller: controller,
//                     focusNode: focusNode,
//                     maxLength: maxLength,
//                     keyboardType: TextInputType.number,
//                     cursorColor: themeChangerViewModel.getBlackColor,
//                     inputFormatters: [CustomDecimalInputFormatter()],
//                     style: TextStyle(
//                       fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//                       color: themeChangerViewModel.getBlackColor,
//                     ),

//                     decoration: InputDecoration(
//                       counterText: "",
//                       border: InputBorder.none,
//                       hintText: hint,
//                       hintStyle: TextStyle(
//                         color: themeChangerViewModel.getGreyColor,
//                         fontSize: 12,
//                       ),

//                       /// 👇 FIX: Show error text properly
//                       errorStyle: TextStyle(color: Colors.red, fontSize: 11),
//                     ),

//                     onChanged: onChanged,

//                     onFieldSubmitted: (val) {
//                       CompFunctions.fieldFocusChange(
//                         currentFocusNode: focusNode ?? FocusNode(),
//                         nextFocusNode: nextFocusNode ?? FocusNode(),
//                       );
//                     },

//                     validator:
//                         validator ??
//                         (value) {
//                           if (value == null || value.isEmpty) {
//                             return "$hint is required";
//                           }
//                           return null;
//                         },
//                   ),
//                 ),

//                 const SizedBox(width: 10),
//               ],
//             ),
//           ),

//           /// 👇 Space for error message below box
//           SizedBox(height: 4),
//         ],
//       ),
//     );
//   }

//   static scan({
//     FocusNode? focusNode,
//     required TextEditingController controller,
//     FocusNode? nextFocusNode,
//     GestureTapCallback? onSuffixTap,
//     String hint = "Enter here",
//     ValueChanged<String>? onChanged,
//     Function? call,
//     bool isSuffix = true,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
//       child: SizedBox(
//         height: 50,
//         child: TextField(
//           // textAlign: TextAlign.right,
//           cursorColor: themeChangerViewModel.getSecondaryColor,
//           maxLength: 40,
//           focusNode: focusNode,
//           style: TextStyle(
//             color: themeChangerViewModel.whiteColor,
//             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//           ),
//           textAlignVertical: TextAlignVertical.center,
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.symmetric(horizontal: 10),
//             counterText: "",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 color: themeChangerViewModel.getSecondaryColor,
//                 width: 1,
//               ),
//             ),
//             filled: true,
//             fillColor: themeChangerViewModel.lightColor,
//             hintText: hint,
//             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
//             suffixIcon: isSuffix
//                 ? InkWell(
//                     onTap: () async {
//                       if (call != null) {
//                         call();
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 5,
//                       ),
//                       child: Icon(
//                         Icons.qr_code,
//                         color: themeChangerViewModel.getSecondaryColor,
//                       ),
//                     ),
//                   )
//                 : null,
//           ),

//           onSubmitted: (val) {
//             CompFunctions.fieldFocusChange(
//               currentFocusNode: focusNode ?? FocusNode(),
//               nextFocusNode: nextFocusNode ?? FocusNode(),
//             );
//           },
//           onChanged: onChanged,
//           controller: controller,
//           keyboardType: TextInputType.text,
//         ),
//       ),
//     );
//   }

//   static sendMessage({
//     FocusNode? focusNode,
//     String hint = "message",
//     ValueChanged<String>? onChanged,
//     TextEditingController? controller,
//     FocusNode? nextFocusNode,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
//       child: SizedBox(
//         height: 50,
//         child: TextField(
//           cursorColor: themeChangerViewModel.primaryColor,
//           maxLength: 20,
//           focusNode: focusNode,
//           style: TextStyle(
//             color: themeChangerViewModel.primaryColor,
//             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//           ),
//           textAlignVertical: TextAlignVertical.center,
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.all(10),
//             counterText: "",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: BorderSide(
//                 color: themeChangerViewModel.greyColor,
//                 width: 1,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: BorderSide(
//                 color: themeChangerViewModel.greyColor,
//                 width: 1,
//               ),
//             ),
//             filled: true,
//             fillColor: themeChangerViewModel.whiteColor,
//             hintText: "Type $hint...",
//             hintStyle: TextStyle(color: themeChangerViewModel.greyColor),
//           ),
//           onChanged: onChanged,
//           onSubmitted: (val) {
//             CompFunctions.fieldFocusChange(
//               currentFocusNode: focusNode ?? FocusNode(),
//               nextFocusNode: nextFocusNode ?? FocusNode(),
//             );
//           },
//           controller: controller,
//           keyboardType: TextInputType.emailAddress,
//         ),
//       ),
//     );
//   }

//   static Widget card({
//     FocusNode? focusNode,
//     String hint = "",
//     Icon? pIcon,
//     ValueChanged<String>? onChanged,
//     TextEditingController? controller,
//     FocusNode? nextFocusNode,
//     int? maxNumber,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
//       child: SizedBox(
//         height: 50,
//         child: TextField(
//           cursorColor: themeChangerViewModel.primaryColor,
//           maxLength: maxNumber,
//           focusNode: focusNode,
//           style: TextStyle(
//             color: themeChangerViewModel.primaryColor,
//             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//           ),
//           textAlignVertical: TextAlignVertical.center,
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.only(left: 15),
//             counterText: "",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: BorderSide(
//                 color: themeChangerViewModel.primaryColor,
//                 width: 1,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: BorderSide(
//                 color: themeChangerViewModel.primaryColor,
//                 width: 1,
//               ),
//             ),
//             filled: true,
//             fillColor: themeChangerViewModel.getWhiteColor,
//             hintText: "Enter $hint",
//             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
//             prefixIcon: pIcon,
//           ),
//           onChanged: onChanged,
//           onSubmitted: (val) {
//             CompFunctions.fieldFocusChange(
//               currentFocusNode: focusNode ?? FocusNode(),
//               nextFocusNode: nextFocusNode ?? FocusNode(),
//             );
//           },
//           controller: controller,
//           keyboardType: TextInputType.number,
//           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         ),
//       ),
//     );
//   }

//   static Widget dropdown<T>({
//     required String hint,
//     required T? value,
//     required List<T> items,
//     required ValueChanged<T?> onChanged,
//     Color borderColor = const Color(0xFF000000), // Default black
//     Color fillColor = const Color(0xFFFFFFFF), // Default white
//     TextStyle? hintStyle,
//     FocusNode? focusNode,
//     String? Function(T?)? validator,
//   }) {
//     // Ensure items are unique
//     final uniqueItems = items.toSet().toList();

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//       child: DropdownButtonFormField<T>(
//         isExpanded: true,
//         dropdownColor: themeChangerViewModel.getWhiteColor,
//         focusNode: focusNode,
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.all(10),

//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: borderColor, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: borderColor, width: 1),
//           ),
//           filled: true,
//           fillColor: fillColor,
//           hintText: hint,
//           hintStyle: TextStyle(
//             color: themeChangerViewModel.getGreyColor,
//             fontSize: 12,
//           ),
//           // Default grey
//         ),
//         value: uniqueItems.contains(value)
//             ? value
//             : null, // Ensure value exists in items
//         items: uniqueItems
//             .map(
//               (item) => DropdownMenuItem<T>(
//                 value: item,
//                 child: (item.toString()).blackTextStyle(
//                   fw: FontWeight.normal,
//                   enumFontSize: EnumFontSize.small,
//                 ),
//               ),
//             )
//             .toList(),
//         onChanged: onChanged,
//         validator:
//             validator ??
//             (selectedValue) {
//               if (selectedValue == null) {
//                 return 'Please select $hint'; // Validation for unselected dropdown
//               }
//               return null;
//             },
//       ),
//     );
//   }

//   static Widget searchableDropdown({
//     required TextEditingController controller,
//     required List<String> items,
//     required ValueChanged<String> onSelected,
//     required ValueChanged<String> onChange,
//     FocusNode? focusNode,
//     FocusNode? nextFocusNode,
//     String hint = "Search here",
//     String? Function(String?)? validator,
//   }) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         List<String> filteredItems = items;

//         void filterItems(String query) {
//           setState(() {
//             filteredItems = items
//                 .where(
//                   (item) => item.toLowerCase().contains(query.toLowerCase()),
//                 )
//                 .toList();
//           });
//         }

//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 50,
//                 child: TextFormField(
//                   cursorColor: themeChangerViewModel.getBlackColor,
//                   focusNode: focusNode,
//                   style: TextStyle(
//                     color: themeChangerViewModel.getBlackColor,
//                     fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
//                   ),
//                   textAlignVertical: TextAlignVertical.center,
//                   decoration: InputDecoration(
//                     errorStyle: const TextStyle(fontSize: 0),
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 10),
//                     prefixIcon: const Icon(Icons.search),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(
//                         color: themeChangerViewModel.getPrimaryColor,
//                         width: 1,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(
//                         color: themeChangerViewModel.getPrimaryColor,
//                         width: 1,
//                       ),
//                     ),
//                     filled: true,
//                     fillColor: themeChangerViewModel.getWhiteColor,
//                     hintText: hint,
//                     hintStyle: TextStyle(
//                       color: themeChangerViewModel.getGreyColor,
//                     ),
//                   ),
//                   onChanged: onChange,
//                   onFieldSubmitted: (val) {
//                     CompFunctions.fieldFocusChange(
//                       currentFocusNode: focusNode ?? FocusNode(),
//                       nextFocusNode: nextFocusNode ?? FocusNode(),
//                     );
//                   },
//                   validator:
//                       validator ??
//                       (value) {
//                         if (value == null || value.isEmpty) {
//                           return ''; // Error border
//                         }
//                         return null;
//                       },
//                   controller: controller,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 decoration: BoxDecoration(
//                   color: themeChangerViewModel.getWhiteColor,
//                   border: Border.all(
//                     color: themeChangerViewModel.getPrimaryColor,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: filteredItems.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(
//                         filteredItems[index],
//                         style: TextStyle(
//                           color: themeChangerViewModel.getBlackColor,
//                         ),
//                       ),
//                       onTap: () {
//                         controller.text = filteredItems[index];
//                         onSelected(filteredItems[index]);
//                         filteredItems = items; // Reset list after selection
//                         setState(() {});
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class CustomDecimalInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     final reg = RegExp(r'^[0-9]{0,6}$'); // up to 6 digits

//     if (reg.hasMatch(newValue.text)) {
//       return newValue;
//     }
//     return oldValue;
//   }
// }

// import 'package:mczen/libs.dart';

// class CompTextField {
//   static final themeChangerViewModel = Provider.of<ThemeChangerViewModel>(
//     navigatorKey.currentContext!,
//     listen: false,
//   );

//   static const double _height = 55;

//   /// BASE INPUT DECORATION (USED EVERYWHERE)

//   static InputDecoration _decoration({
//     required String hint,
//     Widget? prefixIcon,
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       hintText: hint,
//       counterText: "",
//       prefixIcon: prefixIcon,
//       suffixIcon: suffixIcon,

//       filled: true,
//       fillColor: themeChangerViewModel.getWhiteColor,

//       hintStyle: TextStyle(
//         color: themeChangerViewModel.getGreyColor,
//         fontSize: 12,
//       ),

//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(50),
//         borderSide: BorderSide(
//           color: themeChangerViewModel.getBlackColor.withValues(alpha: 0.2),
//           width: 1,
//         ),
//       ),

//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(50),
//         borderSide: BorderSide(
//           color: themeChangerViewModel.getGreyColor.withValues(alpha: 0.2),
//           width: 1,
//         ),
//       ),

//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(50),
//         borderSide: BorderSide(
//           color: themeChangerViewModel.getPrimaryColor.withValues(alpha: 0.2),
//           width: 1,
//         ),
//       ),

//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(50),
//         borderSide: BorderSide(color: themeChangerViewModel.getRedColor),
//       ),
//     );
//   }

//   /// TEXT FIELD

//   static Widget text({
//     FocusNode? focusNode,
//     TextEditingController? controller,
//     FocusNode? nextFocusNode,
//     String hint = "Enter text",
//     Widget? prefixIcon,
//     ValueChanged<String>? onChanged,
//   }) {
//     return SizedBox(
//       height: _height,
//       child: TextFormField(
//         controller: controller,
//         focusNode: focusNode,
//         maxLength: 70,
//         onChanged: onChanged,
//         cursorColor: themeChangerViewModel.getBlackColor,
//         style: TextStyle(
//           color: themeChangerViewModel.getBlackColor,
//           fontSize: 13,
//         ),
//         decoration: _decoration(hint: hint, prefixIcon: prefixIcon),
//         onFieldSubmitted: (val) {
//           CompFunctions.fieldFocusChange(
//             currentFocusNode: focusNode ?? FocusNode(),
//             nextFocusNode: nextFocusNode ?? FocusNode(),
//           );
//         },
//       ),
//     );
//   }

//   /// PASSWORD FIELD

//   static Widget password({
//     FocusNode? focusNode,
//     TextEditingController? controller,
//     FocusNode? nextFocusNode,
//     required ValueNotifier<bool> obscurePassword,
//   }) {
//     return SizedBox(
//       height: _height,
//       child: ValueListenableBuilder(
//         valueListenable: obscurePassword,
//         builder: (context, value, child) {
//           return TextFormField(
//             controller: controller,
//             focusNode: focusNode,
//             obscureText: value,
//             maxLength: 20,
//             style: TextStyle(
//               color: themeChangerViewModel.getBlackColor,
//               fontSize: 13,
//             ),
//             decoration: _decoration(
//               hint: "Enter password",
//               prefixIcon: const Icon(Icons.lock_outline, size: 17),
//               suffixIcon: InkWell(
//                 onTap: () {
//                   obscurePassword.value = !value;
//                 },
//                 child: Icon(
//                   value ? Icons.visibility : Icons.visibility_off,
//                   size: 17,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   /// EMAIL

//   static Widget email({
//     FocusNode? focusNode,
//     TextEditingController? controller,
//   }) {
//     return text(
//       controller: controller,
//       focusNode: focusNode,
//       hint: "Enter email",
//       prefixIcon: const Icon(Icons.email_outlined),
//     );
//   }

//   /// MOBILE

//   static Widget mobile({
//     TextEditingController? controller,
//     FocusNode? focusNode,
//   }) {
//     return SizedBox(
//       height: _height,
//       child: TextFormField(
//         controller: controller,
//         focusNode: focusNode,
//         keyboardType: TextInputType.phone,
//         maxLength: 10,
//         decoration: _decoration(
//           hint: "Enter mobile number",
//           prefixIcon: const Padding(
//             padding: EdgeInsets.all(12),
//             // child: Text("+91"),
//           ),
//         ),
//       ),
//     );
//   }

//   /// SEARCH

//   static Widget search({
//     TextEditingController? controller,
//     ValueChanged<String>? onChanged,
//   }) {
//     return SizedBox(
//       height: _height,
//       child: TextField(
//         controller: controller,
//         onChanged: onChanged,
//         decoration: _decoration(
//           hint: "Search...",
//           prefixIcon: const Icon(Icons.search),
//         ),
//       ),
//     );
//   }

//   /// DATE PICKER

//   static Widget datePicker({
//     required BuildContext context,
//     TextEditingController? controller,
//   }) {
//     return SizedBox(
//       height: _height,
//       child: TextFormField(
//         controller: controller,
//         readOnly: true,
//         decoration: _decoration(
//           hint: "Select date",
//           prefixIcon: const Icon(Icons.calendar_today),
//         ),
//         onTap: () async {
//           DateTime? picked = await showDatePicker(
//             context: context,
//             firstDate: DateTime(1900),
//             lastDate: DateTime.now(),
//             initialDate: DateTime.now(),
//           );

//           if (picked != null) {
//             controller?.text = "${picked.year}-${picked.month}-${picked.day}";
//           }
//         },
//       ),
//     );
//   }

//   /// DROPDOWN

//   static Widget dropdown<T>({
//     required String hint,
//     required List<T> items,
//     required T? value,
//     required ValueChanged<T?> onChanged,
//   }) {
//     return SizedBox(
//       height: 55,
//       child: DropdownButtonFormField<T>(
//         value: value,
//         icon: const Icon(Icons.keyboard_arrow_down),
//         decoration: _decoration(hint: hint),
//         items: items.map((e) {
//           return DropdownMenuItem<T>(
//             value: e,
//             child: Text(
//               e.toString(),
//               style: TextStyle(
//                 color: themeChangerViewModel.getBlackColor,
//                 fontSize: 13,
//               ),
//             ),
//           );
//         }).toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }

//   // static Widget dropdown<T>({
//   //   required String hint,
//   //   required List<T> items,
//   //   required T? value,
//   //   required ValueChanged<T?> onChanged,
//   // }) {
//   //   return DropdownButtonFormField<T>(
//   //     value: value,
//   //     decoration: _decoration(hint: hint),
//   //     items: items
//   //         .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
//   //         .toList(),
//   //     onChanged: onChanged,
//   //   );
//   // }

//   /// ADDRESS (MULTILINE)

//   static Widget address({TextEditingController? controller}) {
//     return SizedBox(
//       height: 100,
//       child: TextFormField(
//         controller: controller,
//         maxLines: null,
//         expands: true,
//         decoration: _decoration(hint: "Enter address"),
//       ),
//     );
//   }

//   /// NUMBER FIELD

//   static Widget number({TextEditingController? controller, int maxLength = 6}) {
//     return SizedBox(
//       height: _height,
//       child: TextFormField(
//         controller: controller,
//         maxLength: maxLength,
//         keyboardType: TextInputType.number,
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         decoration: _decoration(hint: "Enter number"),
//       ),
//     );
//   }

//   /// AMOUNT

//   static Widget amount({TextEditingController? controller}) {
//     return SizedBox(
//       height: _height,
//       child: TextField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         decoration: _decoration(hint: "Enter amount"),
//       ),
//     );
//   }
// }

// // import 'package:animated_search_bar/animated_search_bar.dart';

// // import '../libs.dart';

// // class CompTextField {
// //   static final themeChangerViewModel = Provider.of<ThemeChangerViewModel>(
// //     navigatorKey.currentContext!,
// //     listen: false,
// //   );
// //   static Widget email({
// //     FocusNode? focusNode,
// //     TextEditingController? controller,
// //     FocusNode? nextFocusNode,
// //   }) {
// //     controller ??= TextEditingController();

// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
// //       child: Container(
// //         height: 55,
// //         decoration: BoxDecoration(
// //           color: themeChangerViewModel.getWhiteColor,
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(color: AppColor.grey, width: 1),
// //         ),
// //         child: Row(
// //           children: [
// //             const SizedBox(width: 12),

// //             // PREFIX ICON
// //             Icon(
// //               Icons.email_outlined,
// //               color: themeChangerViewModel.primaryColor,
// //             ),

// //             const SizedBox(width: 12),

// //             // MAIN INPUT
// //             Expanded(
// //               child: TextFormField(
// //                 controller: controller,
// //                 focusNode: focusNode,
// //                 maxLength: 35,
// //                 keyboardType: TextInputType.emailAddress,
// //                 cursorColor: themeChangerViewModel.getBlackColor,
// //                 autovalidateMode: AutovalidateMode.onUserInteraction,

// //                 style: TextStyle(
// //                   color: themeChangerViewModel.getBlackColor,
// //                   fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //                 ),

// //                 decoration: InputDecoration(
// //                   hintText: "Enter email",
// //                   hintStyle: TextStyle(
// //                     color: themeChangerViewModel.getGreyColor,
// //                     fontSize: 12,
// //                   ),
// //                   border: InputBorder.none,
// //                   counterText: "",
// //                 ),

// //                 // VALIDATOR
// //                 validator: (val) {
// //                   if (val == null || val.isEmpty) {
// //                     return 'Email cannot be empty';
// //                   }

// //                   final emailPattern =
// //                       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
// //                   final isValid = RegExp(emailPattern).hasMatch(val);

// //                   if (!isValid) {
// //                     return 'Enter a valid email address';
// //                   }

// //                   return null;
// //                 },

// //                 // MOVE TO NEXT FIELD ON COMPLETE DOMAIN
// //                 onChanged: (val) {
// //                   if (val.endsWith('@gmail.com') ||
// //                       val.endsWith('@outlook.com') ||
// //                       val.endsWith('@yahoo.com')) {
// //                     CompFunctions.fieldFocusChange(
// //                       currentFocusNode: focusNode ?? FocusNode(),
// //                       nextFocusNode: nextFocusNode ?? FocusNode(),
// //                     );
// //                   }
// //                 },
// //               ),
// //             ),

// //             const SizedBox(width: 10),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   static Widget gender({
// //     required String? value,
// //     required Function(String?) onChanged,
// //   }) {
// //     List<String> genderList = ["Male", "Female", "Other"];

// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
// //       child: Container(
// //         height: 55,
// //         padding: EdgeInsets.symmetric(horizontal: 12),
// //         decoration: BoxDecoration(
// //           color: themeChangerViewModel.getWhiteColor,
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(color: AppColor.grey, width: 1),
// //         ),
// //         child: Row(
// //           children: [
// //             Icon(
// //               Icons.person_outline,
// //               color: themeChangerViewModel.primaryColor,
// //             ),

// //             const SizedBox(width: 12),

// //             Expanded(
// //               child: DropdownButtonFormField<String>(
// //                 value: (value != null && genderList.contains(value))
// //                     ? value
// //                     : null,

// //                 decoration: InputDecoration(
// //                   border: InputBorder.none,
// //                   isDense: true,
// //                   contentPadding: EdgeInsets.zero,
// //                   hintText: "Select Gender",
// //                   hintStyle: TextStyle(
// //                     color: themeChangerViewModel.getGreyColor,
// //                     fontSize: 12,
// //                   ),
// //                 ),

// //                 icon: Icon(
// //                   Icons.arrow_drop_down,
// //                   color: themeChangerViewModel.primaryColor,
// //                 ),

// //                 style: TextStyle(
// //                   fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //                   color: themeChangerViewModel.getBlackColor,
// //                 ),

// //                 items: genderList
// //                     .map(
// //                       (gender) =>
// //                           DropdownMenuItem(value: gender, child: Text(gender)),
// //                     )
// //                     .toList(),

// //                 validator: (val) {
// //                   if (val == null || val.isEmpty) {
// //                     return "Select gender";
// //                   }
// //                   return null;
// //                 },

// //                 onChanged: onChanged,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   static datePicker({
// //     FocusNode? focusNode,
// //     TextEditingController? controller,
// //     FocusNode? nextFocusNode,
// //     BuildContext? context,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
// //       child: SizedBox(
// //         child: TextFormField(
// //           cursorColor: themeChangerViewModel.getBlackColor,
// //           focusNode: focusNode,
// //           style: TextStyle(
// //             color: themeChangerViewModel.getBlackColor,
// //             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //           ),
// //           textAlignVertical: TextAlignVertical.center,
// //           decoration: InputDecoration(
// //             contentPadding: const EdgeInsets.all(0),
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(10),
// //               borderSide: BorderSide(
// //                 width: 1,
// //                 color: themeChangerViewModel.getBlackColor,
// //               ),
// //             ),
// //             focusedBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(10),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.getBlackColor,
// //                 width: 1,
// //               ),
// //             ),
// //             filled: true,
// //             fillColor: themeChangerViewModel.getWhiteColor,
// //             hintText: "Select date",
// //             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
// //             prefixIcon: Icon(
// //               Icons.calendar_today_outlined,
// //               color: themeChangerViewModel.getPrimaryColor,
// //             ),
// //           ),
// //           controller: controller,
// //           readOnly: true,
// //           onTap: () async {
// //             if (context != null) {
// //               DateTime? pickedDate = await showDatePicker(
// //                 context: context,
// //                 initialDate: DateTime.now(),
// //                 firstDate: DateTime(1900),
// //                 lastDate: DateTime.now(),
// //                 builder: (BuildContext context, Widget? child) {
// //                   return Theme(
// //                     data: ThemeData.light().copyWith(
// //                       colorScheme: ColorScheme.light(
// //                         primary: themeChangerViewModel.getPrimaryColor,
// //                         onPrimary: themeChangerViewModel.getWhiteColor,
// //                         surface: themeChangerViewModel.getWhiteColor,
// //                         onSurface: themeChangerViewModel.getBlackColor,
// //                       ),
// //                       dialogBackgroundColor:
// //                           themeChangerViewModel.getWhiteColor,
// //                     ),
// //                     child: child ?? SizedBox.shrink(),
// //                   );
// //                 },
// //               );

// //               if (pickedDate != null) {
// //                 String formattedDate =
// //                     "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
// //                 controller?.text = formattedDate;

// //                 // Automatically move to the next field if applicable
// //                 CompFunctions.fieldFocusChange(
// //                   currentFocusNode: focusNode ?? FocusNode(),
// //                   nextFocusNode: nextFocusNode ?? FocusNode(),
// //                 );
// //               }
// //             }
// //           },
// //           validator: (val) {
// //             if (val == null || val.isEmpty) {
// //               return 'Date cannot be empty';
// //             }
// //             return null;
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   static password({
// //     FocusNode? focusNode,
// //     TextEditingController? controller,
// //     FocusNode? nextFocusNode,
// //     String? Function(String?)? validator,
// //     required ValueNotifier<bool> obscurePassword,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
// //       child: SizedBox(
// //         height: 70,
// //         child: ValueListenableBuilder(
// //           valueListenable: obscurePassword,
// //           builder: (context, value, child) {
// //             return TextFormField(
// //               onFieldSubmitted: (va) {
// //                 CompFunctions.fieldFocusChange(
// //                   currentFocusNode: focusNode ?? FocusNode(),
// //                   nextFocusNode: nextFocusNode ?? FocusNode(),
// //                 );
// //               },
// //               obscureText: obscurePassword.value,
// //               obscuringCharacter: "*",
// //               cursorColor: themeChangerViewModel.getBlackColor,
// //               maxLength: 20,
// //               focusNode: focusNode,
// //               style: TextStyle(
// //                 color: themeChangerViewModel.getBlackColor,
// //                 fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //               ),
// //               textAlignVertical: TextAlignVertical.center,
// //               decoration: InputDecoration(
// //                 contentPadding: const EdgeInsets.all(0),
// //                 counterText: "",
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                   borderSide: BorderSide(
// //                     color: themeChangerViewModel.getBlackColor,
// //                     width: 1,
// //                   ),
// //                 ),
// //                 focusedBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                   borderSide: BorderSide(
// //                     color: themeChangerViewModel.getBlackColor,
// //                     width: 1,
// //                   ),
// //                 ),
// //                 filled: true,
// //                 fillColor: themeChangerViewModel.getWhiteColor,
// //                 hintText: "Enter password",
// //                 hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
// //                 prefixIcon: Icon(
// //                   Icons.lock_outline_rounded,
// //                   color: themeChangerViewModel.getBlackColor,
// //                 ),
// //                 suffixIcon: InkWell(
// //                   onTap: () {
// //                     obscurePassword.value = !obscurePassword.value;
// //                   },
// //                   child: Icon(
// //                     obscurePassword.value
// //                         ? Icons.visibility_off_outlined
// //                         : Icons.visibility,
// //                     color: themeChangerViewModel.getGreyColor,
// //                   ),
// //                 ),
// //               ),
// //               controller: controller,
// //               keyboardType: TextInputType.emailAddress,
// //               validator:
// //                   validator ??
// //                   (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter password'; // Validation for empty field
// //                     }
// //                     return null;
// //                   },
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   static searchField({
// //     Key? key,
// //     TextEditingController? controller,
// //     FocusNode? focusNode,
// //     bool? enabled,
// //     GestureTapCallback? onTap,
// //     FocusNode? nextFocusNode,
// //     ValueChanged<String>? onChange,
// //     String hint = "Search...",
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
// //       child: InkWell(
// //         onTap: (enabled ?? true) ? null : onTap,
// //         child: SizedBox(
// //           height: 50,
// //           child: TextFormField(
// //             key: key,
// //             enabled: enabled,
// //             autovalidateMode: AutovalidateMode.disabled,
// //             cursorColor: themeChangerViewModel.primaryColor,
// //             controller: controller,
// //             onFieldSubmitted: (val) {
// //               CompFunctions.fieldFocusChange(
// //                 currentFocusNode: focusNode ?? FocusNode(),
// //                 nextFocusNode: nextFocusNode ?? FocusNode(),
// //               );
// //             },
// //             focusNode: focusNode,
// //             style: TextStyle(
// //               fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //               color: themeChangerViewModel.primaryColor,
// //             ),
// //             textAlignVertical: TextAlignVertical.center,
// //             decoration: InputDecoration(
// //               border: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(10),
// //                 borderSide: BorderSide(
// //                   color: themeChangerViewModel.getPrimaryColor,
// //                   width: 1,
// //                 ),
// //               ),
// //               focusedBorder: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(10),
// //                 borderSide: BorderSide(
// //                   color: themeChangerViewModel.getPrimaryColor,
// //                   width: 1,
// //                 ),
// //               ),
// //               enabledBorder: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(10),
// //                 borderSide: BorderSide(
// //                   color: themeChangerViewModel.getPrimaryColor,
// //                   width: 1,
// //                 ),
// //               ),
// //               prefixIcon: Icon(
// //                 Icons.search,
// //                 color: themeChangerViewModel.getGreyColor,
// //               ),
// //               fillColor: themeChangerViewModel.getWhiteColor,
// //               filled: true,
// //               contentPadding: const EdgeInsets.all(0),
// //               isDense: true,
// //               errorBorder: InputBorder.none,
// //               errorText: null,
// //               hintText: hint,
// //               hintStyle: TextStyle(
// //                 fontSize: 12,
// //                 color: themeChangerViewModel.getGreyColor,
// //               ),
// //               counterText: "",
// //               errorStyle: const TextStyle(),
// //             ),
// //             onChanged: onChange,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   static Widget mobile({
// //     TextEditingController? controller,
// //     FocusNode? focusNode,
// //     FocusNode? nextFocusNode,
// //     ValueChanged<String>? onChange,
// //   }) {
// //     controller ??= TextEditingController();

// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
// //       child: Container(
// //         height: 55,
// //         decoration: BoxDecoration(
// //           color: themeChangerViewModel.getWhiteColor,
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(color: AppColor.grey, width: 1),
// //         ),
// //         child: Row(
// //           children: [
// //             const SizedBox(width: 12),

// //             /// India Flag
// //             Text(
// //               "🇮🇳",
// //               style: TextStyle(
// //                 fontSize: 15,
// //                 color: themeChangerViewModel.primaryColor,
// //                 fontWeight: FontWeight.w700,
// //               ),
// //             ),

// //             const SizedBox(width: 10),

// //             /// Country Code
// //             Text(
// //               "+91",
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 color: themeChangerViewModel.primaryColor,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),

// //             const SizedBox(width: 12),

// //             /// Text Field (with focusNode + nextFocusNode)
// //             Expanded(
// //               child: TextFormField(
// //                 controller: controller,
// //                 focusNode: focusNode,
// //                 maxLength: 10,
// //                 keyboardType: TextInputType.phone,
// //                 autovalidateMode: AutovalidateMode.onUserInteraction,
// //                 onChanged: (value) {
// //                   onChange?.call(value);

// //                   /// Move to next field automatically
// //                   if (value.length == 10 && nextFocusNode != null) {
// //                     CompFunctions.fieldFocusChange(
// //                       currentFocusNode: focusNode!,
// //                       nextFocusNode: nextFocusNode!,
// //                     );
// //                   }
// //                 },
// //                 decoration: InputDecoration(
// //                   border: InputBorder.none,
// //                   counterText: "",
// //                   hintText: "Enter your 10-digit mobile number",
// //                   hintStyle: TextStyle(
// //                     color: themeChangerViewModel.getGreyColor,
// //                     fontSize: 12,
// //                   ),
// //                 ),
// //                 style: TextStyle(
// //                   fontSize: 15,
// //                   color: themeChangerViewModel.primaryColor,
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return "Please enter a valid mobile number";
// //                   }
// //                   if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
// //                     return "Invalid mobile number";
// //                   }
// //                   return null;
// //                 },
// //               ),
// //             ),

// //             const SizedBox(width: 10),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // static Widget text({
// //   //   FocusNode? focusNode,
// //   //   String hint = "Enter text",
// //   //   ValueChanged<String>? onChanged,
// //   //   TextEditingController? controller,
// //   //   Widget? prefixIcon,
// //   //   FocusNode? nextFocusNode,
// //   //   String? Function(String?)? validator,
// //   // }) {
// //   //   controller ??= TextEditingController();

// //   //   return Padding(
// //   //     padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
// //   //     child: Container(
// //   //       height: 70,
// //   //       decoration: BoxDecoration(
// //   //         color: themeChangerViewModel.getWhiteColor,
// //   //         borderRadius: BorderRadius.circular(12),
// //   //         border: Border.all(color: AppColor.grey, width: 1),
// //   //       ),
// //   //       child: Row(
// //   //         children: [
// //   //           if (prefixIcon != null) ...[
// //   //             const SizedBox(width: 12),
// //   //             prefixIcon,
// //   //             const SizedBox(width: 12),
// //   //           ],

// //   //           // MAIN TEXT FIELD
// //   //           Expanded(
// //   //             child: TextFormField(
// //   //               controller: controller,
// //   //               focusNode: focusNode,
// //   //               maxLength: 70,
// //   //               onChanged: onChanged,
// //   //               keyboardType: TextInputType.text,
// //   //               style: TextStyle(
// //   //                 fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //   //                 color: themeChangerViewModel.getBlackColor,
// //   //               ),
// //   //               decoration: InputDecoration(
// //   //                 counterText: "",
// //   //                 contentPadding: EdgeInsets.symmetric(horizontal: 10),
// //   //                 border: InputBorder.none,
// //   //                 hintText: hint,
// //   //                 hintStyle: TextStyle(
// //   //                   color: themeChangerViewModel.getGreyColor,
// //   //                   fontSize: 12,
// //   //                 ),
// //   //               ),
// //   //               onFieldSubmitted: (val) {
// //   //                 if (nextFocusNode != null) {
// //   //                   CompFunctions.fieldFocusChange(
// //   //                     currentFocusNode: focusNode ?? FocusNode(),
// //   //                     nextFocusNode: nextFocusNode,
// //   //                   );
// //   //                 } else {
// //   //                   CompFunctions.unFocus();
// //   //                 }
// //   //               },
// //   //               validator:
// //   //                   validator ??
// //   //                   (value) {
// //   //                     if (value == null || value.isEmpty) {
// //   //                       return "$hint is required";
// //   //                     }
// //   //                     return null;
// //   //                   },
// //   //             ),
// //   //           ),

// //   //           const SizedBox(width: 10),
// //   //         ],
// //   //       ),
// //   //     ),
// //   //   );
// //   // }

// //   static Widget text({
// //     FocusNode? focusNode,
// //     String hint = "Enter text",
// //     ValueChanged<String>? onChanged,
// //     TextEditingController? controller,
// //     Widget? prefixIcon,
// //     FocusNode? nextFocusNode,
// //     String? Function(String?)? validator,
// //   }) {
// //     controller ??= TextEditingController();

// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
// //       child: SizedBox(
// //         height: 70,
// //         child: TextFormField(
// //           controller: controller,
// //           focusNode: focusNode,
// //           maxLength: 70,
// //           onChanged: onChanged,
// //           keyboardType: TextInputType.text,
// //           cursorColor: themeChangerViewModel.getBlackColor,
// //           style: TextStyle(
// //             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //             color: themeChangerViewModel.getBlackColor,
// //           ),
// //           textAlignVertical: TextAlignVertical.center,
// //           decoration: InputDecoration(
// //             counterText: "",
// //             contentPadding: const EdgeInsets.all(0),

// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(10),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.getBlackColor,
// //                 width: 1,
// //               ),
// //             ),

// //             enabledBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(10),
// //               borderSide: BorderSide(color: AppColor.grey, width: 1),
// //             ),

// //             focusedBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(10),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.getBlackColor,
// //                 width: 1,
// //               ),
// //             ),

// //             errorBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(10),
// //               borderSide: BorderSide(color: Colors.red, width: 1),
// //             ),

// //             filled: true,
// //             fillColor: themeChangerViewModel.getWhiteColor,

// //             hintText: hint,
// //             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),

// //             prefixIcon: prefixIcon,
// //           ),
// //           onFieldSubmitted: (val) {
// //             if (nextFocusNode != null) {
// //               CompFunctions.fieldFocusChange(
// //                 currentFocusNode: focusNode ?? FocusNode(),
// //                 nextFocusNode: nextFocusNode,
// //               );
// //             } else {
// //               CompFunctions.unFocus();
// //             }
// //           },
// //           validator:
// //               validator ??
// //               (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return "$hint is required";
// //                 }
// //                 return null;
// //               },
// //         ),
// //       ),
// //     );
// //   }

// //   static drawerSearch({
// //     FocusNode? focusNode,
// //     String hint = "here",
// //     ValueChanged<String>? onChanged,
// //     TextEditingController? controller,
// //     FocusNode? nextFocusNode,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
// //       child: SizedBox(
// //         height: 40,
// //         child: TextFormField(
// //           cursorColor: themeChangerViewModel.getBlackColor,
// //           maxLength: 70,
// //           focusNode: focusNode,
// //           style: TextStyle(
// //             color: themeChangerViewModel.getBlackColor,
// //             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //           ),
// //           textAlignVertical: TextAlignVertical.center,
// //           decoration: InputDecoration(
// //             contentPadding: const EdgeInsets.all(10),
// //             counterText: "",
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(10),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.getBlackColor,
// //                 width: 1,
// //               ),
// //             ),
// //             focusedBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(10),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.getBlackColor,
// //                 width: 1,
// //               ),
// //             ),
// //             filled: true,
// //             fillColor: themeChangerViewModel.getWhiteColor,
// //             hintText: hint,
// //             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
// //           ),
// //           onChanged: onChanged,
// //           onFieldSubmitted: (val) {
// //             if (nextFocusNode != null) {
// //               CompFunctions.fieldFocusChange(
// //                 currentFocusNode: focusNode ?? FocusNode(),
// //                 nextFocusNode: nextFocusNode,
// //               );
// //             } else {
// //               CompFunctions.unFocus();
// //             }
// //           },

// //           controller: controller,
// //           keyboardType: TextInputType.text, // Adjust based on input type
// //         ),
// //       ),
// //     );
// //   }

// //   static address({
// //     FocusNode? focusNode,
// //     TextEditingController? controller,
// //     FocusNode? nextFocusNode,
// //     ValueChanged<String>? onChanged,
// //     String? Function(String?)? validator,
// //     String hint = "Enter address here",
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
// //       child: SizedBox(
// //         height: 100,
// //         child: TextFormField(
// //           cursorColor: themeChangerViewModel.getBlackColor,
// //           maxLength: 300,
// //           focusNode: focusNode,
// //           style: TextStyle(
// //             color: themeChangerViewModel.getBlackColor,
// //             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //           ),
// //           textAlignVertical: TextAlignVertical.top,
// //           decoration: InputDecoration(
// //             contentPadding: EdgeInsets.all(
// //               Constants.defaultPagePaddingHorizontally,
// //             ),
// //             counterText: "",
// //             errorStyle: const TextStyle(fontSize: 0),
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(8),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.getBlackColor,
// //                 width: 1,
// //               ),
// //             ),
// //             focusedBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(8),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.getBlackColor,
// //                 width: 1,
// //               ),
// //             ),
// //             filled: true,
// //             fillColor: themeChangerViewModel.getWhiteColor,
// //             hintText: hint,
// //             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
// //           ),
// //           onChanged: onChanged,
// //           validator: (value) {
// //             if (value == null || value.isEmpty) {
// //               // Return an error string to display the error border
// //               return ''; // Returning an empty string to avoid showing a message
// //             }
// //             return null; // No error, return null
// //           },
// //           onFieldSubmitted: (val) {
// //             CompFunctions.fieldFocusChange(
// //               currentFocusNode: focusNode ?? FocusNode(),
// //               nextFocusNode: nextFocusNode ?? FocusNode(),
// //             );
// //           },
// //           controller: controller,
// //           maxLines: null,
// //           expands: true,
// //           keyboardType: TextInputType.multiline,
// //         ),
// //       ),
// //     );
// //   }

// //   static search({
// //     required Function(String) onChange,
// //     TextEditingController? controller,
// //     required String title,
// //   }) {
// //     return Row(
// //       children: [
// //         title.whiteTextStyle(
// //           enumFontSize: EnumFontSize.small,
// //           fw: FontWeight.normal,
// //         ),
// //         MasterSpacer.w.fifty(),
// //         Expanded(
// //           child: AnimatedSearchBar(
// //             labelStyle: TextStyle(color: themeChangerViewModel.primaryColor),
// //             searchIcon: Icon(
// //               Icons.search,
// //               color: themeChangerViewModel.primaryColor,
// //             ),
// //             height: 35,
// //             controller: controller,
// //             cursorColor: themeChangerViewModel.primaryColor,
// //             searchDecoration: InputDecoration(
// //               filled: true,
// //               fillColor: themeChangerViewModel.getWhiteColor,
// //               hintText: "Search here",
// //               hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
// //               contentPadding: const EdgeInsets.symmetric(
// //                 vertical: 13,
// //                 horizontal: 15,
// //               ),
// //               focusedBorder: OutlineInputBorder(
// //                 borderRadius: BorderRadius.circular(8),
// //                 borderSide: BorderSide(
// //                   color: themeChangerViewModel.primaryColor,
// //                   width: 1,
// //                 ),
// //               ),
// //             ),
// //             searchStyle: TextStyle(
// //               color: themeChangerViewModel.primaryColor,
// //               fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //             ),
// //             closeIcon: Icon(
// //               Icons.close,
// //               color: themeChangerViewModel.primaryColor,
// //             ),
// //             onChanged: onChange,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   static amount({
// //     FocusNode? focusNode,
// //     TextEditingController? controller,
// //     FocusNode? nextFocusNode,
// //     suffixVisible = true,
// //     TextAlign textAlign = TextAlign.left,
// //     String hint = "Enter amount",
// //     GestureTapCallback? onSuffixTap,
// //     ValueChanged<String>? onChange,
// //     bool enable = true,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
// //       child: SizedBox(
// //         height: 50,
// //         child: TextField(
// //           enabled: enable,
// //           textAlign: textAlign,
// //           cursorColor: themeChangerViewModel.getSecondaryColor,
// //           maxLength: 20,
// //           focusNode: focusNode,
// //           style: TextStyle(
// //             color: themeChangerViewModel.getBlackColor,
// //             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //           ),
// //           textAlignVertical: TextAlignVertical.center,
// //           decoration: InputDecoration(
// //             contentPadding: EdgeInsets.all(
// //               Constants.defaultPagePaddingHorizontally,
// //             ),
// //             counterText: "",
// //             errorStyle: const TextStyle(fontSize: 0),
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(8),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.getBlackColor,
// //                 width: 1,
// //               ),
// //             ),
// //             focusedBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(8),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.getBlackColor,
// //                 width: 1,
// //               ),
// //             ),
// //             filled: true,
// //             fillColor: themeChangerViewModel.getWhiteColor,
// //             hintText: hint,
// //             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
// //           ),
// //           onChanged: onChange,
// //           onSubmitted: (val) {
// //             CompFunctions.fieldFocusChange(
// //               currentFocusNode: focusNode ?? FocusNode(),
// //               nextFocusNode: nextFocusNode ?? FocusNode(),
// //             );
// //           },
// //           controller: controller,
// //           keyboardType: TextInputType.number,
// //           inputFormatters: [
// //             // FilteringTextInputFormatter.allow(RegExp(r"^[0-9.]{1,10}$")),
// //             TextInputFormatter.withFunction((oldValue, newValue) {
// //               final text = newValue.text;

// //               // Regular expression to match only decimal digits and a single period (.)
// //               final validInput = RegExp(r'^\d{0,8}(\.\d{0,4})?$');

// //               if (text.isEmpty || validInput.hasMatch(text)) {
// //                 return newValue;
// //               } else {
// //                 // Check if the old value is empty or matches the valid input pattern
// //                 if (oldValue.text.isEmpty ||
// //                     validInput.hasMatch(oldValue.text)) {
// //                   // Revert to the old value if it's valid
// //                   return oldValue;
// //                 } else {
// //                   // If the old value is also invalid, allow backspace by returning an empty string
// //                   return TextEditingValue.empty;
// //                 }
// //               }
// //             }),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   static Widget number({
// //     FocusNode? focusNode,
// //     TextEditingController? controller,
// //     FocusNode? nextFocusNode,
// //     String hint = "Enter number",
// //     int maxLength = 6,
// //     ValueChanged<String>? onChanged,
// //     String? Function(String?)? validator,
// //     Widget? prefixIcon,
// //   }) {
// //     controller ??= TextEditingController();

// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             height: 55,
// //             decoration: BoxDecoration(
// //               color: themeChangerViewModel.getWhiteColor,
// //               borderRadius: BorderRadius.circular(12),
// //               border: Border.all(color: AppColor.grey, width: 1),
// //             ),
// //             child: Row(
// //               children: [
// //                 const SizedBox(width: 12),

// //                 if (prefixIcon != null) ...[
// //                   prefixIcon,
// //                   const SizedBox(width: 12),
// //                 ],

// //                 Expanded(
// //                   child: TextFormField(
// //                     controller: controller,
// //                     focusNode: focusNode,
// //                     maxLength: maxLength,
// //                     keyboardType: TextInputType.number,
// //                     cursorColor: themeChangerViewModel.getBlackColor,
// //                     inputFormatters: [CustomDecimalInputFormatter()],
// //                     style: TextStyle(
// //                       fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //                       color: themeChangerViewModel.getBlackColor,
// //                     ),

// //                     decoration: InputDecoration(
// //                       counterText: "",
// //                       border: InputBorder.none,
// //                       hintText: hint,
// //                       hintStyle: TextStyle(
// //                         color: themeChangerViewModel.getGreyColor,
// //                         fontSize: 12,
// //                       ),

// //                       /// 👇 FIX: Show error text properly
// //                       errorStyle: TextStyle(color: Colors.red, fontSize: 11),
// //                     ),

// //                     onChanged: onChanged,

// //                     onFieldSubmitted: (val) {
// //                       CompFunctions.fieldFocusChange(
// //                         currentFocusNode: focusNode ?? FocusNode(),
// //                         nextFocusNode: nextFocusNode ?? FocusNode(),
// //                       );
// //                     },

// //                     validator:
// //                         validator ??
// //                         (value) {
// //                           if (value == null || value.isEmpty) {
// //                             return "$hint is required";
// //                           }
// //                           return null;
// //                         },
// //                   ),
// //                 ),

// //                 const SizedBox(width: 10),
// //               ],
// //             ),
// //           ),

// //           /// 👇 Space for error message below box
// //           SizedBox(height: 4),
// //         ],
// //       ),
// //     );
// //   }

// //   static scan({
// //     FocusNode? focusNode,
// //     required TextEditingController controller,
// //     FocusNode? nextFocusNode,
// //     GestureTapCallback? onSuffixTap,
// //     String hint = "Enter here",
// //     ValueChanged<String>? onChanged,
// //     Function? call,
// //     bool isSuffix = true,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
// //       child: SizedBox(
// //         height: 50,
// //         child: TextField(
// //           // textAlign: TextAlign.right,
// //           cursorColor: themeChangerViewModel.getSecondaryColor,
// //           maxLength: 40,
// //           focusNode: focusNode,
// //           style: TextStyle(
// //             color: themeChangerViewModel.whiteColor,
// //             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //           ),
// //           textAlignVertical: TextAlignVertical.center,
// //           decoration: InputDecoration(
// //             contentPadding: const EdgeInsets.symmetric(horizontal: 10),
// //             counterText: "",
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(8),
// //               borderSide: BorderSide.none,
// //             ),
// //             focusedBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(8),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.getSecondaryColor,
// //                 width: 1,
// //               ),
// //             ),
// //             filled: true,
// //             fillColor: themeChangerViewModel.lightColor,
// //             hintText: hint,
// //             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
// //             suffixIcon: isSuffix
// //                 ? InkWell(
// //                     onTap: () async {
// //                       if (call != null) {
// //                         call();
// //                       }
// //                     },
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 10,
// //                         vertical: 5,
// //                       ),
// //                       child: Icon(
// //                         Icons.qr_code,
// //                         color: themeChangerViewModel.getSecondaryColor,
// //                       ),
// //                     ),
// //                   )
// //                 : null,
// //           ),

// //           onSubmitted: (val) {
// //             CompFunctions.fieldFocusChange(
// //               currentFocusNode: focusNode ?? FocusNode(),
// //               nextFocusNode: nextFocusNode ?? FocusNode(),
// //             );
// //           },
// //           onChanged: onChanged,
// //           controller: controller,
// //           keyboardType: TextInputType.text,
// //         ),
// //       ),
// //     );
// //   }

// //   static sendMessage({
// //     FocusNode? focusNode,
// //     String hint = "message",
// //     ValueChanged<String>? onChanged,
// //     TextEditingController? controller,
// //     FocusNode? nextFocusNode,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
// //       child: SizedBox(
// //         height: 50,
// //         child: TextField(
// //           cursorColor: themeChangerViewModel.primaryColor,
// //           maxLength: 20,
// //           focusNode: focusNode,
// //           style: TextStyle(
// //             color: themeChangerViewModel.primaryColor,
// //             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //           ),
// //           textAlignVertical: TextAlignVertical.center,
// //           decoration: InputDecoration(
// //             contentPadding: const EdgeInsets.all(10),
// //             counterText: "",
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(25),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.greyColor,
// //                 width: 1,
// //               ),
// //             ),
// //             focusedBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(25),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.greyColor,
// //                 width: 1,
// //               ),
// //             ),
// //             filled: true,
// //             fillColor: themeChangerViewModel.whiteColor,
// //             hintText: "Type $hint...",
// //             hintStyle: TextStyle(color: themeChangerViewModel.greyColor),
// //           ),
// //           onChanged: onChanged,
// //           onSubmitted: (val) {
// //             CompFunctions.fieldFocusChange(
// //               currentFocusNode: focusNode ?? FocusNode(),
// //               nextFocusNode: nextFocusNode ?? FocusNode(),
// //             );
// //           },
// //           controller: controller,
// //           keyboardType: TextInputType.emailAddress,
// //         ),
// //       ),
// //     );
// //   }

// //   static Widget card({
// //     FocusNode? focusNode,
// //     String hint = "",
// //     Icon? pIcon,
// //     ValueChanged<String>? onChanged,
// //     TextEditingController? controller,
// //     FocusNode? nextFocusNode,
// //     int? maxNumber,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
// //       child: SizedBox(
// //         height: 50,
// //         child: TextField(
// //           cursorColor: themeChangerViewModel.primaryColor,
// //           maxLength: maxNumber,
// //           focusNode: focusNode,
// //           style: TextStyle(
// //             color: themeChangerViewModel.primaryColor,
// //             fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //           ),
// //           textAlignVertical: TextAlignVertical.center,
// //           decoration: InputDecoration(
// //             contentPadding: const EdgeInsets.only(left: 15),
// //             counterText: "",
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(25),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.primaryColor,
// //                 width: 1,
// //               ),
// //             ),
// //             focusedBorder: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(25),
// //               borderSide: BorderSide(
// //                 color: themeChangerViewModel.primaryColor,
// //                 width: 1,
// //               ),
// //             ),
// //             filled: true,
// //             fillColor: themeChangerViewModel.getWhiteColor,
// //             hintText: "Enter $hint",
// //             hintStyle: TextStyle(color: themeChangerViewModel.getGreyColor),
// //             prefixIcon: pIcon,
// //           ),
// //           onChanged: onChanged,
// //           onSubmitted: (val) {
// //             CompFunctions.fieldFocusChange(
// //               currentFocusNode: focusNode ?? FocusNode(),
// //               nextFocusNode: nextFocusNode ?? FocusNode(),
// //             );
// //           },
// //           controller: controller,
// //           keyboardType: TextInputType.number,
// //           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
// //         ),
// //       ),
// //     );
// //   }

// //   static Widget dropdown<T>({
// //     required String hint,
// //     required T? value,
// //     required List<T> items,
// //     required ValueChanged<T?> onChanged,
// //     Color borderColor = const Color(0xFF000000), // Default black
// //     Color fillColor = const Color(0xFFFFFFFF), // Default white
// //     TextStyle? hintStyle,
// //     FocusNode? focusNode,
// //     String? Function(T?)? validator,
// //   }) {
// //     // Ensure items are unique
// //     final uniqueItems = items.toSet().toList();

// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
// //       child: DropdownButtonFormField<T>(
// //         isExpanded: true,
// //         dropdownColor: themeChangerViewModel.getWhiteColor,
// //         focusNode: focusNode,
// //         decoration: InputDecoration(
// //           contentPadding: const EdgeInsets.all(10),

// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(10),
// //             borderSide: BorderSide(color: borderColor, width: 1),
// //           ),
// //           focusedBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(10),
// //             borderSide: BorderSide(color: borderColor, width: 1),
// //           ),
// //           filled: true,
// //           fillColor: fillColor,
// //           hintText: hint,
// //           hintStyle: TextStyle(
// //             color: themeChangerViewModel.getGreyColor,
// //             fontSize: 12,
// //           ),
// //           // Default grey
// //         ),
// //         value: uniqueItems.contains(value)
// //             ? value
// //             : null, // Ensure value exists in items
// //         items: uniqueItems
// //             .map(
// //               (item) => DropdownMenuItem<T>(
// //                 value: item,
// //                 child: (item.toString()).blackTextStyle(
// //                   fw: FontWeight.normal,
// //                   enumFontSize: EnumFontSize.small,
// //                 ),
// //               ),
// //             )
// //             .toList(),
// //         onChanged: onChanged,
// //         validator:
// //             validator ??
// //             (selectedValue) {
// //               if (selectedValue == null) {
// //                 return 'Please select $hint'; // Validation for unselected dropdown
// //               }
// //               return null;
// //             },
// //       ),
// //     );
// //   }

// //   static Widget searchableDropdown({
// //     required TextEditingController controller,
// //     required List<String> items,
// //     required ValueChanged<String> onSelected,
// //     required ValueChanged<String> onChange,
// //     FocusNode? focusNode,
// //     FocusNode? nextFocusNode,
// //     String hint = "Search here",
// //     String? Function(String?)? validator,
// //   }) {
// //     return StatefulBuilder(
// //       builder: (context, setState) {
// //         List<String> filteredItems = items;

// //         void filterItems(String query) {
// //           setState(() {
// //             filteredItems = items
// //                 .where(
// //                   (item) => item.toLowerCase().contains(query.toLowerCase()),
// //                 )
// //                 .toList();
// //           });
// //         }

// //         return Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
// //           child: Column(
// //             children: [
// //               SizedBox(
// //                 height: 50,
// //                 child: TextFormField(
// //                   cursorColor: themeChangerViewModel.getBlackColor,
// //                   focusNode: focusNode,
// //                   style: TextStyle(
// //                     color: themeChangerViewModel.getBlackColor,
// //                     fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
// //                   ),
// //                   textAlignVertical: TextAlignVertical.center,
// //                   decoration: InputDecoration(
// //                     errorStyle: const TextStyle(fontSize: 0),
// //                     contentPadding: const EdgeInsets.symmetric(horizontal: 10),
// //                     prefixIcon: const Icon(Icons.search),
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                       borderSide: BorderSide(
// //                         color: themeChangerViewModel.getPrimaryColor,
// //                         width: 1,
// //                       ),
// //                     ),
// //                     focusedBorder: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                       borderSide: BorderSide(
// //                         color: themeChangerViewModel.getPrimaryColor,
// //                         width: 1,
// //                       ),
// //                     ),
// //                     filled: true,
// //                     fillColor: themeChangerViewModel.getWhiteColor,
// //                     hintText: hint,
// //                     hintStyle: TextStyle(
// //                       color: themeChangerViewModel.getGreyColor,
// //                     ),
// //                   ),
// //                   onChanged: onChange,
// //                   onFieldSubmitted: (val) {
// //                     CompFunctions.fieldFocusChange(
// //                       currentFocusNode: focusNode ?? FocusNode(),
// //                       nextFocusNode: nextFocusNode ?? FocusNode(),
// //                     );
// //                   },
// //                   validator:
// //                       validator ??
// //                       (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return ''; // Error border
// //                         }
// //                         return null;
// //                       },
// //                   controller: controller,
// //                 ),
// //               ),
// //               const SizedBox(height: 8),
// //               Container(
// //                 decoration: BoxDecoration(
// //                   color: themeChangerViewModel.getWhiteColor,
// //                   border: Border.all(
// //                     color: themeChangerViewModel.getPrimaryColor,
// //                   ),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: ListView.builder(
// //                   shrinkWrap: true,
// //                   itemCount: filteredItems.length,
// //                   itemBuilder: (context, index) {
// //                     return ListTile(
// //                       title: Text(
// //                         filteredItems[index],
// //                         style: TextStyle(
// //                           color: themeChangerViewModel.getBlackColor,
// //                         ),
// //                       ),
// //                       onTap: () {
// //                         controller.text = filteredItems[index];
// //                         onSelected(filteredItems[index]);
// //                         filteredItems = items; // Reset list after selection
// //                         setState(() {});
// //                       },
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// // class CustomDecimalInputFormatter extends TextInputFormatter {
// //   @override
// //   TextEditingValue formatEditUpdate(
// //     TextEditingValue oldValue,
// //     TextEditingValue newValue,
// //   ) {
// //     final reg = RegExp(r'^[0-9]{0,6}$'); // up to 6 digits

// //     if (reg.hasMatch(newValue.text)) {
// //       return newValue;
// //     }
// //     return oldValue;
// //   }
// // }
