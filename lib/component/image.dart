import '../libs.dart';

class CompImage {
  static final themeChangerViewModel = Provider.of<ThemeChangerViewModel>(
    navigatorKey.currentContext!,
    listen: false,
  );

  static AnimatedOpacity showAssetWithColor({
    required String path,
    Color? color,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(seconds: 1),
      child: Image.asset(
        path,
        fit: BoxFit.contain,
        color: color ?? themeChangerViewModel.getSecondaryColor,
      ),
    );
  }

  static AnimatedOpacity showAsset({
    required String path,
    Alignment alignment = Alignment.center,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(seconds: 1),
      child: Container(
        width: 100,
        height: 100,
        alignment: alignment,
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }

  static AnimatedOpacity showAssetOrg({
    required String path,
    Alignment alignment = Alignment.center,
    required double scale,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(seconds: 1),
      child: Container(
        width: double.infinity,
        alignment: alignment,
        child: Image.asset(path, fit: BoxFit.cover, scale: scale),
      ),
    );
  }

  static AnimatedOpacity showNetwork({
    String? url,
    String? defaultAsset,
    BorderRadius? borderRadius,
    BoxFit? fit,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(seconds: 1),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(50),
        child: Image.network(
          url ?? "",
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(10),
              child: Image.asset(
                defaultAsset ?? Constants.appIcon,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          },
          fit: fit ?? BoxFit.cover,
        ),
      ),
    );
  }

  static AnimatedOpacity showCircleNetwork2({
    String? url,
    String? defaultAsset,
    double scale = 1,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(seconds: 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          url ?? "",
          scale: scale,
          errorBuilder: (context, error, stackTrace) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                defaultAsset ?? Constants.appIcon,
                fit: BoxFit.contain,
                scale: scale,
              ),
            );
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  static SizedBox showNetworkProfile({
    String? url,
    double width = 140,
    double height = 140,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(seconds: 1),
          child: Image.network(
            url ?? "",
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                size: 20,
                color: themeChangerViewModel.getPrimaryColor,
                Icons.person,
              );
            },
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class AnimatedImageScale extends StatefulWidget {
  final String path;
  final bool isNetwork;
  final double width;
  final double height;

  const AnimatedImageScale({
    super.key,
    required this.path,
    required this.isNetwork,
    required this.width,
    required this.height,
  });

  @override
  AnimatedImageScaleState createState() => AnimatedImageScaleState();
}

class AnimatedImageScaleState extends State<AnimatedImageScale> {
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(seconds: 1),
      child: widget.isNetwork
          ? Image.network(
              widget.path,
              fit: BoxFit.fill,
              height: widget.height,
              width: widget.width,
            )
          : Image.asset(
              widget.path,
              fit: BoxFit.fill,
              height: widget.height,
              width: widget.width,
            ),
    );
  }
}
