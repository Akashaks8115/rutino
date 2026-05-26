import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../libs.dart';

class CommonScreen extends StatefulWidget {
  final Widget child;
  final bool loading;
  final PreferredSizeWidget? appBar;
  final bool isBackPress;
  final Future<bool> Function()? onWillPop;
  final bool doubleBackPress;
  final bool removePaddings;
  final Widget? bottomNavigationBar;
  final bool isBottomShape;
  final Widget? drawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget? floatingActionButton;
  final RefreshCallback? refreshCallback;
  final bool showBannerAd;
  const CommonScreen({
    super.key,
    required this.child,
    this.loading = false,
    this.isBackPress = true,
    this.appBar,
    this.onWillPop,
    this.scaffoldKey,
    this.removePaddings = false,
    this.drawer,
    this.floatingActionButton,
    this.doubleBackPress = false,
    this.bottomNavigationBar,
    this.isBottomShape = false,
    this.refreshCallback,
    this.showBannerAd = true,
  });

  @override
  State<CommonScreen> createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen> {
  late Connectivity _connectivity;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _connectivity = Connectivity();

    _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {},
    );

    if (widget.showBannerAd) {
      _loadBannerAd();
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-5673370027323305/9305292339',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  // DateTime? _lastPressedAt; // Track the time of the last back press

  @override
  Widget build(BuildContext context) {
    return widget.doubleBackPress
        ? CompPopScope(child: isRefresh(context: context))
        : WillPopScope(
            onWillPop: widget.onWillPop,
            // canPop: false,
            child: isRefresh(context: context),
          );
  }

  Widget isRefresh({required BuildContext context}) {
    if (widget.refreshCallback != null) {
      return CompRefreshIndicator.show(
        child: isScreenShot(context: context),
        onRefresh: widget.refreshCallback!,
      );
    } else {
      return isScreenShot(context: context);
    }
  }

  Widget isScreenShot({required BuildContext context}) {
    return page(context: context);
  }

  Widget page({required BuildContext context}) {
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: widget.loading ? null : widget.drawer,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: widget.loading ? null : widget.floatingActionButton,
      bottomNavigationBar: widget.loading
          ? null
          : SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_bannerAd != null && _isBannerAdLoaded)
                    Container(
                      alignment: Alignment.center,
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  widget.bottomNavigationBar ?? const SizedBox(),
                ],
              ),
            ),
      extendBodyBehindAppBar: true,
      appBar: widget.loading ? null : widget.appBar,
      extendBody: false,
      body: SafeArea(
        child: Stack(
          children: [
            AbsorbPointer(
              absorbing: widget.loading,
              child: Container(
                padding: EdgeInsets.symmetric(
                  // vertical: 15,
                  horizontal: widget.removePaddings ? 0 : 10,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: widget.child,
              ),
            ),
            widget.loading
                ? Container(
                    color: AppColor.blackColor.withValues(alpha: 0.2),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ApiResponseView.loading(),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
