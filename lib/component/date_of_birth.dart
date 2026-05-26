import 'package:flutter/cupertino.dart';

import '../libs.dart';

class CompDobPicker extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? errorText;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final Function(DateTime)? onDateSelected;

  const CompDobPicker({
    super.key,
    required this.controller,
    this.hint = "Select Date of Birth",
    this.focusNode,
    this.prefixIcon,
    this.validator,
    this.errorText,
    this.onDateSelected,
  });

  @override
  State<CompDobPicker> createState() => _CompDobPickerState();
}

class _CompDobPickerState extends State<CompDobPicker> {
  late ThemeChangerViewModel themeViewModel;
  DateTime selectedDate = DateTime(2000, 1, 1);

  @override
  void initState() {
    super.initState();
    themeViewModel = Provider.of<ThemeChangerViewModel>(
      navigatorKey.currentContext!,
      listen: false,
    );
  }

  void _showCupertinoDatePicker() {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      context: context,
      backgroundColor: themeViewModel.getWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SizedBox(
        height: 300,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextButton(
                onPressed: () {
                  widget.controller.text = CompDateTime.showMCZenDate(
                    selectedDate.toString(),
                  );

                  widget.onDateSelected?.call(selectedDate);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: selectedDate,
                maximumDate: DateTime.now(),
                minimumDate: DateTime(1900),
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (date) => setState(() {
                  selectedDate = date;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: GestureDetector(
        onTap: () {
          mDebugPrintResponse("Get Date of birth");
          _showCupertinoDatePicker();
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: themeViewModel.getWhiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.grey, width: 1),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),

              widget.prefixIcon ??
                  Icon(Icons.cake, color: themeViewModel.getPrimaryColor),

              const SizedBox(width: 12),

              Expanded(
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hint,
                      errorText: widget.errorText,
                      counterText: "",
                      hintStyle: TextStyle(
                        color: themeViewModel.getGreyColor,
                        fontSize: 12,
                      ),
                    ),
                    cursorColor: themeViewModel.getBlackColor,
                    style: TextStyle(
                      color: themeViewModel.getBlackColor,
                      fontSize: MyFontSize.getFontSize(EnumFontSize.extraSmall),
                    ),
                    validator:
                        widget.validator ??
                        (value) {
                          if (value == null || value.isEmpty) {
                            return widget.hint;
                          }
                          return null;
                        },
                  ),
                ),
              ),

              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
