import '../libs.dart';

class CompRichText {
  static RichText show() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: "colorful",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: " text.",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class CompRichTextModel {}
