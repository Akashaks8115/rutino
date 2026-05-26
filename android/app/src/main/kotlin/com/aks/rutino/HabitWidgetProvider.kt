package com.aks.rutino

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

class HabitWidgetProvider : AppWidgetProvider() {

    private val ACTION_CLICK = "com.aks.rutino.ACTION_WIDGET_CLICK"
    private val ACTION_RESET = "com.aks.rutino.ACTION_WIDGET_RESET"

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateWidgetUI(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateWidgetUI(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int? = null) {
        val views = RemoteViews(context.packageName, R.layout.habit_widget_layout)
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

        // Check daily reset
        val todayStr = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())
        val lastDate = prefs.getString("flutter.water_last_date", "")
        if (lastDate != todayStr) {
            prefs.edit()
                .putLong("flutter.water_current_progress", 0L)
                .putString("flutter.water_last_date", todayStr)
                .putBoolean("flutter.water_widget_checked", false)
                .apply()
        }

        val currentProgress = try {
            prefs.getLong("flutter.water_current_progress", 0L).toInt()
        } catch (e: ClassCastException) {
            try {
                prefs.getInt("flutter.water_current_progress", 0)
            } catch (e2: ClassCastException) {
                prefs.getString("flutter.water_current_progress", "0")?.toIntOrNull() ?: 0
            }
        }
        
        val targetProgress = try {
            prefs.getLong("flutter.water_target", 6000L).toInt()
        } catch (e: ClassCastException) {
            try {
                prefs.getInt("flutter.water_target", 6000)
            } catch (e2: ClassCastException) {
                prefs.getString("flutter.water_target", "6000")?.toIntOrNull() ?: 6000
            }
        }
        
        val isChecked = try {
            prefs.getBoolean("flutter.water_widget_checked", false)
        } catch (e: ClassCastException) {
            try {
                prefs.getString("flutter.water_widget_checked", "false")?.toBoolean() ?: false
            } catch (e2: ClassCastException) {
                false
            }
        }

        views.setTextViewText(R.id.widget_habit_progress, "$currentProgress / $targetProgress ml")

        if (isChecked) {
            // Checked State: Green background, Check icon
            views.setTextViewText(R.id.widget_action_btn, "✔")
            views.setInt(R.id.widget_action_btn, "setBackgroundColor", Color.parseColor("#00E676"))
            // Disable click
            val emptyIntent = PendingIntent.getBroadcast(
                context, 0, Intent(),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_action_btn, emptyIntent)
        } else {
            // Normal State: Indigo background, + icon
            views.setTextViewText(R.id.widget_action_btn, "+")
            views.setInt(R.id.widget_action_btn, "setBackgroundColor", Color.parseColor("#5465FF"))
            
            val intent = Intent(context, HabitWidgetProvider::class.java).apply {
                action = ACTION_CLICK
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_action_btn, pendingIntent)
        }

        if (appWidgetId != null) {
            appWidgetManager.updateAppWidget(appWidgetId, views)
        } else {
            val thisWidget = ComponentName(context, HabitWidgetProvider::class.java)
            appWidgetManager.updateAppWidget(thisWidget, views)
        }
        
        scheduleNextReset(context)
    }

    private fun scheduleNextReset(context: Context) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val remindersStr = prefs.getString("flutter.water_reminders", "") ?: ""
        if (remindersStr.isEmpty()) return

        val times = remindersStr.split(",")
        val calendar = Calendar.getInstance()
        val currentHour = calendar.get(Calendar.HOUR_OF_DAY)
        val currentMinute = calendar.get(Calendar.MINUTE)
        val currentTotalMinutes = currentHour * 60 + currentMinute

        var nextAlarmTimeMinutes = -1

        for (time in times) {
            val parts = time.split(":")
            if (parts.size == 2) {
                val h = parts[0].toIntOrNull() ?: continue
                val m = parts[1].toIntOrNull() ?: continue
                val totalMinutes = h * 60 + m
                if (totalMinutes > currentTotalMinutes) {
                    nextAlarmTimeMinutes = totalMinutes
                    break
                }
            }
        }

        if (nextAlarmTimeMinutes != -1) {
            val h = nextAlarmTimeMinutes / 60
            val m = nextAlarmTimeMinutes % 60
            
            val alarmCalendar = Calendar.getInstance().apply {
                set(Calendar.HOUR_OF_DAY, h)
                set(Calendar.MINUTE, m)
                set(Calendar.SECOND, 0)
            }
            
            val intent = Intent(context, HabitWidgetProvider::class.java).apply {
                action = ACTION_RESET
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context, 1, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, alarmCalendar.timeInMillis, pendingIntent)
                } else {
                    alarmManager.setExact(AlarmManager.RTC_WAKEUP, alarmCalendar.timeInMillis, pendingIntent)
                }
            } catch (e: SecurityException) {
                // Ignore if exact alarm permission is denied
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        if (intent.action == ACTION_CLICK) {
            // Haptic Feedback
            val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(VibrationEffect.createOneShot(50, VibrationEffect.DEFAULT_AMPLITUDE))
            } else {
                @Suppress("DEPRECATION")
                vibrator.vibrate(50)
            }

            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            var currentProgress = try {
                prefs.getLong("flutter.water_current_progress", 0L).toInt()
            } catch (e: ClassCastException) {
                prefs.getInt("flutter.water_current_progress", 0)
            }
            
            val increment = try {
                prefs.getLong("flutter.water_increment", 500L).toInt()
            } catch (e: ClassCastException) {
                prefs.getInt("flutter.water_increment", 500)
            }
            
            currentProgress += increment
            prefs.edit()
                .putLong("flutter.water_current_progress", currentProgress.toLong())
                .putBoolean("flutter.water_widget_checked", true)
                .apply()

            val appWidgetManager = AppWidgetManager.getInstance(context)
            updateWidgetUI(context, appWidgetManager)
            
        } else if (intent.action == ACTION_RESET) {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            prefs.edit().putBoolean("flutter.water_widget_checked", false).apply()
            
            val appWidgetManager = AppWidgetManager.getInstance(context)
            updateWidgetUI(context, appWidgetManager)
        }
    }
}
