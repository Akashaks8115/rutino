import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InAppReminderOverlay extends StatefulWidget {
  final String title;
  final String description;
  final String emoji;
  final VoidCallback onDone;
  final VoidCallback onDismiss;

  const InAppReminderOverlay({
    super.key,
    required this.title,
    required this.description,
    required this.emoji,
    required this.onDone,
    required this.onDismiss,
  });

  @override
  State<InAppReminderOverlay> createState() => _InAppReminderOverlayState();
}

class _InAppReminderOverlayState extends State<InAppReminderOverlay>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _entranceController;
  late AnimationController _breathingController;
  late AnimationController _actionController;
  late AnimationController _snoozeController;

  bool _isMarkingDone = false;

  @override
  void initState() {
    super.initState();

    // 1. Entrance Animation
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _entranceController.forward();

    // 2. Continuous Breathing
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    // 3. Action Animations
    _actionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _snoozeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _breathingController.dispose();
    _actionController.dispose();
    _snoozeController.dispose();
    super.dispose();
  }

  void _handleMarkDone() async {
    if (_isMarkingDone || _snoozeController.isAnimating) return;
    setState(() {
      _isMarkingDone = true;
    });
    
    // Haptic Sync (Double short vibration)
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    HapticFeedback.heavyImpact();
    
    await _actionController.forward();
    widget.onDone();
  }

  void _handleSnooze() async {
    if (_isMarkingDone || _snoozeController.isAnimating) return;
    await _snoozeController.forward();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Entrance Animations
    final bgOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );
    final dropSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.1, 0.7, curve: Curves.elasticOut)),
    );
    final dropScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.1, 0.7, curve: Curves.elasticOut)),
    );
    final contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );
    final contentSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic)),
    );

    // 2. Breathing Animations
    final breathingScale = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
    final glowAnimation = Tween<double>(begin: 10.0, end: 35.0).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    // 3. Action Animations
    final dropShrink = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _actionController, curve: const Interval(0.0, 0.3, curve: Curves.easeInBack)),
    );
    final splashScale = Tween<double>(begin: 1.0, end: 35.0).animate(
      CurvedAnimation(parent: _actionController, curve: const Interval(0.2, 1.0, curve: Curves.easeOut)),
    );
    final splashOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _actionController, curve: const Interval(0.2, 0.4, curve: Curves.easeOut)),
    );

    // Snooze Slide Out
    final snoozeSlideOut = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.5)).animate(
      CurvedAnimation(parent: _snoozeController, curve: Curves.easeInBack),
    );

    return Material(
      color: Colors.transparent,
      child: SlideTransition(
        position: snoozeSlideOut,
        child: FadeTransition(
          opacity: bgOpacity,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0B0F19).withValues(alpha: 0.85),
                    const Color(0xFF1E293B).withValues(alpha: 0.95),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Splash Wave Effect (Triggered on Action)
                      AnimatedBuilder(
                        animation: _actionController,
                        builder: (context, child) {
                          if (!_actionController.isAnimating && !_actionController.isCompleted) return const SizedBox.shrink();
                          return Transform.scale(
                            scale: splashScale.value,
                            child: Opacity(
                              opacity: splashOpacity.value,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF00E676), // Neon Mint Green
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          
                          // Staggered Entrance & Breathing Emoji
                          AnimatedBuilder(
                            animation: Listenable.merge([_entranceController, _breathingController, _actionController]),
                            builder: (context, child) {
                              return Transform.scale(
                                scale: dropScale.value * dropShrink.value * breathingScale.value,
                                child: Transform.translate(
                                  offset: dropSlide.value * 100,
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF1E293B),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.lerp(
                                            const Color(0xFF5465FF).withValues(alpha: 0.4), // Indigo
                                            const Color(0xFF00E5FF).withValues(alpha: 0.4), // Cyan
                                            _breathingController.value
                                          )!,
                                          blurRadius: glowAnimation.value,
                                          spreadRadius: glowAnimation.value / 3,
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.emoji,
                                        style: const TextStyle(fontSize: 72),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 56),
                          
                          // Rest of Content (Text & Buttons)
                          FadeTransition(
                            opacity: contentOpacity,
                            child: SlideTransition(
                              position: contentSlide,
                              child: Column(
                                children: [
                                  Text(
                                    widget.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    widget.description,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8), // Muted Slate
                                      fontSize: 18,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          
                          // Buttons
                          FadeTransition(
                            opacity: contentOpacity,
                            child: SlideTransition(
                              position: contentSlide,
                              child: Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: 64,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isMarkingDone ? const Color(0xFF00E676) : const Color(0xFF5465FF),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        elevation: 8,
                                        shadowColor: (_isMarkingDone ? const Color(0xFF00E676) : const Color(0xFF5465FF)).withValues(alpha: 0.4),
                                      ),
                                      onPressed: _handleMarkDone,
                                      child: Text(
                                        widget.emoji == '💧' || widget.title.toLowerCase().contains('water') 
                                            ? '+250ml Water ✔️' 
                                            : 'Mark Day Completed ✔️',
                                        style: const TextStyle(
                                          fontSize: 18, 
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextButton(
                                    onPressed: _handleSnooze,
                                    style: TextButton.styleFrom(
                                      minimumSize: const Size(double.infinity, 56),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      'Remind Me in 15 Mins ⏰',
                                      style: TextStyle(
                                        color: Color(0xFF94A3B8), 
                                        fontSize: 16, 
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
