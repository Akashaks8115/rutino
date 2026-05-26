package com.aks.rutino

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat

class NativeAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val title = intent.getStringExtra("title") ?: "Routine Reminder"
        val body = intent.getStringExtra("body") ?: "Time for your task!"
        val emoji = intent.getStringExtra("emoji") ?: "🔥"
        val habitId = intent.getStringExtra("habitId") ?: ""
        val notificationId = habitId.hashCode()

        if (MainActivity.isAppInForeground) {
            val flutterIntent = Intent("com.aks.rutino.IN_APP_ALARM")
            flutterIntent.putExtra("title", title)
            flutterIntent.putExtra("body", body)
            flutterIntent.putExtra("emoji", emoji)
            flutterIntent.putExtra("habitId", habitId)
            context.sendBroadcast(flutterIntent)
            return
        }

        val fullScreenIntent = Intent(context, FullScreenReminderActivity::class.java).apply {
            putExtra("title", title)
            putExtra("body", body)
            putExtra("emoji", emoji)
            putExtra("habitId", habitId)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        }

        val fullScreenPendingIntent = PendingIntent.getActivity(
            context,
            notificationId,
            fullScreenIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val channelId = "rutino_alarm_channel"
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Routine Full-Screen Alarms",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Shows full screen alarm reminders"
                setBypassDnd(true)
            }
            notificationManager.createNotificationChannel(channel)
        }

        val notificationBuilder = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setFullScreenIntent(fullScreenPendingIntent, true)
            .setAutoCancel(true)

        notificationManager.notify(notificationId, notificationBuilder.build())
    }
}
