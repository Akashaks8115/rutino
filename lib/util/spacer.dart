import 'package:flutter/material.dart';

class MasterSpacer {
  static Width w = Width();
  static Height h = Height();
}

class Width {
  Widget fifty() {
    return const SizedBox(width: 50);
  }

  Widget ten() {
    return const SizedBox(width: 10);
  }

  Widget five() {
    return const SizedBox(width: 5);
  }

  Widget twelve() {
    return const SizedBox(width: 12);
  }

  Widget eight() {
    return const SizedBox(width: 8);
  }

  Widget fifteen() {
    return const SizedBox(width: 15);
  }

  Widget twenty() {
    return const SizedBox(width: 20);
  }

  Widget twentyfive() {
    return const SizedBox(width: 25);
  }
}

class Height {
  Widget two() {
    return const SizedBox(height: 2);
  }

  Widget four() {
    return const SizedBox(height: 4);
  }

  Widget five() {
    return const SizedBox(height: 5);
  }

  Widget eight() {
    return const SizedBox(height: 8);
  }

  Widget ten() {
    return const SizedBox(height: 10);
  }

  Widget fifteen() {
    return const SizedBox(height: 15);
  }

  Widget twenty() {
    return const SizedBox(height: 20);
  }

  Widget twentyfive() {
    return const SizedBox(height: 25);
  }

  Widget thirty() {
    return const SizedBox(height: 30);
  }

  Widget fifty() {
    return const SizedBox(height: 50);
  }

  Widget max() {
    return Expanded(child: Container());
  }
}
