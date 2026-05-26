package com.aks.rutino

import android.content.Intent
import android.content.Context
import android.os.Bundle
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import android.app.Activity

class FullScreenReminderActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Window parameters configuration screen ko force wakeup karne ke liye
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
        }
        
        // Ensure screen stays on
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        // Hide Status Bar & Navigation Bar (Immersive Full Screen)
        window.decorView.systemUiVisibility = (
            android.view.View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
            or android.view.View.SYSTEM_UI_FLAG_LAYOUT_STABLE
            or android.view.View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
            or android.view.View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
            or android.view.View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
            or android.view.View.SYSTEM_UI_FLAG_FULLSCREEN
        )
        
        setContentView(R.layout.activity_fullscreen_reminder)

        val title = intent.getStringExtra("title") ?: "Routine Alert"
        val body = intent.getStringExtra("body") ?: "Time for your habit"
        val emoji = intent.getStringExtra("emoji") ?: "🔥"
        val habitId = intent.getStringExtra("habitId") ?: ""

        val titleView = findViewById<TextView>(R.id.tvTitle)
        val descView = findViewById<TextView>(R.id.tvDescription)
        val btnDone = findViewById<Button>(R.id.btnDone)
        val btnSnooze = findViewById<Button>(R.id.btnSnooze)
        val emojiContainer = findViewById<android.widget.FrameLayout>(R.id.flEmojiContainer)

        if (habitId.contains("water_tracker") || emoji == "💧") {
            btnDone.text = "+250ml Water ✔️"
        }

        titleView.text = title
        descView.text = body
        findViewById<TextView>(R.id.tvEmoji).text = emoji

        // Initial state for Entrance Animation
        titleView.alpha = 0f
        descView.alpha = 0f
        btnDone.alpha = 0f
        btnSnooze.alpha = 0f
        emojiContainer.scaleX = 0f
        emojiContainer.scaleY = 0f

        // Staggered Entrance Animation
        emojiContainer.animate().scaleX(1f).scaleY(1f).setDuration(800).setInterpolator(android.view.animation.OvershootInterpolator()).start()
        titleView.animate().alpha(1f).setDuration(500).setStartDelay(300).start()
        descView.animate().alpha(1f).setDuration(500).setStartDelay(400).start()
        btnDone.animate().alpha(1f).setDuration(500).setStartDelay(500).start()
        btnSnooze.animate().alpha(1f).setDuration(500).setStartDelay(600).start()

        // Continuous Breathing Glow
        val breatheAnim = android.animation.ObjectAnimator.ofPropertyValuesHolder(
            emojiContainer,
            android.animation.PropertyValuesHolder.ofFloat("scaleX", 1.12f),
            android.animation.PropertyValuesHolder.ofFloat("scaleY", 1.12f)
        )
        breatheAnim.duration = 1250
        breatheAnim.repeatCount = android.animation.ObjectAnimator.INFINITE
        breatheAnim.repeatMode = android.animation.ObjectAnimator.REVERSE
        breatheAnim.startDelay = 800
        breatheAnim.start()

        btnDone.setOnClickListener {
            // Action Animation
            breatheAnim.cancel()
            emojiContainer.animate().scaleX(0f).scaleY(0f).setDuration(300).start()
            
            // Haptic Feedback
            val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as android.os.Vibrator
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                vibrator.vibrate(android.os.VibrationEffect.createOneShot(50, android.os.VibrationEffect.DEFAULT_AMPLITUDE))
            } else {
                vibrator.vibrate(50)
            }

            btnDone.postDelayed({
                val launchIntent = Intent(this, MainActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    putExtra("action", "mark_done")
                    putExtra("habitId", habitId)
                }
                startActivity(launchIntent)
                finish()
            }, 300)
        }

        btnSnooze.setOnClickListener {
            // Slide Up Animation
            val rootLayout = findViewById<android.view.View>(R.id.rootLayout)
            rootLayout.animate().translationY(-2000f).setDuration(400).setInterpolator(android.view.animation.AccelerateInterpolator()).start()

            btnSnooze.postDelayed({
                val alarmManager = getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
                val intent = Intent(this, NativeAlarmReceiver::class.java).apply {
                    putExtra("title", title)
                    putExtra("body", body)
                    putExtra("emoji", emoji)
                    putExtra("habitId", habitId)
                }
                val pendingIntent = android.app.PendingIntent.getBroadcast(
                    this, habitId.hashCode() + 1000, intent,
                    android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
                )
                val timeMs = System.currentTimeMillis() + 15 * 60 * 1000
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                    alarmManager.setExactAndAllowWhileIdle(android.app.AlarmManager.RTC_WAKEUP, timeMs, pendingIntent)
                } else {
                    alarmManager.setExact(android.app.AlarmManager.RTC_WAKEUP, timeMs, pendingIntent)
                }
                finish()
            }, 400)
        }
    }
}
