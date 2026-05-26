package com.aks.rutino

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.app.AlarmManager
import android.app.PendingIntent
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.aks.rutino/alarm"
    private var methodChannel: MethodChannel? = null

    companion object {
        var isAppInForeground = false
    }

    private val inAppAlarmReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == "com.aks.rutino.IN_APP_ALARM") {
                val title = intent.getStringExtra("title")
                val body = intent.getStringExtra("body")
                val emoji = intent.getStringExtra("emoji")
                val habitId = intent.getStringExtra("habitId")
                
                methodChannel?.invokeMethod("showInAppReminder", mapOf(
                    "title" to title,
                    "body" to body,
                    "emoji" to emoji,
                    "habitId" to habitId
                ))
            }
        }
    }


    private val screenStateReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (context == null || intent == null) return
            
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val currentTime = System.currentTimeMillis()
            
            when (intent.action) {
                Intent.ACTION_SCREEN_OFF -> {
                    prefs.edit().putLong("flutter.native_screen_off_time", currentTime).apply()
                }
                Intent.ACTION_USER_PRESENT -> {
                    prefs.edit().putLong("flutter.native_user_present_time", currentTime).apply()
                }
            }
        }
    }

    private var pendingAction: String? = null
    private var pendingHabitId: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_OFF)
            addAction(Intent.ACTION_USER_PRESENT)
        }
        registerReceiver(screenStateReceiver, filter)

        intent?.let { handleIntentData(it) }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntentData(intent)
    }

    private fun handleIntentData(intent: Intent) {
        val action = intent.getStringExtra("action")
        val habitId = intent.getStringExtra("habitId")
        if (action == "mark_done") {
            if (methodChannel != null) {
                methodChannel?.invokeMethod("markHabitDone", mapOf("habitId" to habitId))
            } else {
                pendingAction = action
                pendingHabitId = habitId
            }
            intent.removeExtra("action")
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(screenStateReceiver)
    }

    override fun onResume() {
        super.onResume()
        isAppInForeground = true
        val filter = IntentFilter("com.aks.rutino.IN_APP_ALARM")
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(inAppAlarmReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(inAppAlarmReceiver, filter)
        }
    }

    override fun onPause() {
        super.onPause()
        isAppInForeground = false
        try {
            unregisterReceiver(inAppAlarmReceiver)
        } catch (e: Exception) {}
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            if (call.method == "triggerNativeAlarm") {
                val title = call.argument<String>("title")
                val body = call.argument<String>("body")
                val emoji = call.argument<String>("emoji")
                val habitId = call.argument<String>("habitId")

                val intent = Intent(this, FullScreenReminderActivity::class.java).apply {
                    putExtra("title", title)
                    putExtra("body", body)
                    putExtra("emoji", emoji)
                    putExtra("habitId", habitId)
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                }
                startActivity(intent)
                result.success(true)
            } else if (call.method == "scheduleNativeAlarm") {
                val timeMs = call.argument<Long>("timeMs") ?: return@setMethodCallHandler
                val title = call.argument<String>("title")
                val body = call.argument<String>("body")
                val emoji = call.argument<String>("emoji")
                val habitId = call.argument<String>("habitId")
                val alarmId = habitId?.hashCode() ?: 0

                val intent = Intent(this, NativeAlarmReceiver::class.java).apply {
                    putExtra("title", title)
                    putExtra("body", body)
                    putExtra("emoji", emoji)
                    putExtra("habitId", habitId)
                }

                val pendingIntent = PendingIntent.getBroadcast(
                    this, alarmId, intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

                val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                    alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, timeMs, pendingIntent)
                } else {
                    alarmManager.setExact(AlarmManager.RTC_WAKEUP, timeMs, pendingIntent)
                }
                result.success(true)
            } else if (call.method == "checkPendingActions") {
                if (pendingAction != null) {
                    val map = mapOf("action" to pendingAction, "habitId" to pendingHabitId)
                    pendingAction = null
                    pendingHabitId = null
                    result.success(map)
                } else {
                    result.success(null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
