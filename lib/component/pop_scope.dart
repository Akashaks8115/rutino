import 'dart:async';

import '../libs.dart';

class CompPopScope extends StatefulWidget {
  final Widget child;
  const CompPopScope({super.key, required this.child});

  @override
  State<CompPopScope> createState() => _CompPopScopeState();
}

class _CompPopScopeState extends State<CompPopScope> {
  bool popStatus = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: popStatus,
      onPopInvokedWithResult: (stat, result) {
        setState(() {
          popStatus = true;
        });

        Timer(const Duration(seconds: 2), () {
          setState(() {
            popStatus = false;
          });
        });

        CompDialog.showToast(
          autoCloseDuration: 2,
          context: context,
          msg: "Press back again to exit",
        );
      },
      child: widget.child,
    );
  }
}
