package com.example.recall_butler_flutter

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.ImageView
import android.widget.LinearLayout
import androidx.core.app.NotificationCompat

class OverlayService : Service() {

    companion object {
        const val ACTION_SHOW = "com.recallbutler.ACTION_SHOW"
        const val ACTION_HIDE = "com.recallbutler.ACTION_HIDE"
        const val CHANNEL_ID = "recall_butler_overlay"
        const val NOTIFICATION_ID = 1001

        var isRunning = false
    }

    private var windowManager: WindowManager? = null
    private var floatingButton: View? = null
    private var expandedMenu: View? = null
    private var isMenuExpanded = false

    private var initialX = 0
    private var initialY = 0
    private var initialTouchX = 0f
    private var initialTouchY = 0f

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_SHOW -> {
                startForeground(NOTIFICATION_ID, createNotification())
                showFloatingButton()
                isRunning = true
            }
            ACTION_HIDE -> {
                hideFloatingButton()
                isRunning = false
                stopForeground(true)
                stopSelf()
            }
        }
        return START_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Recall Butler Overlay",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Shows floating capture button"
                setShowBadge(false)
            }

            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Recall Butler Active")
            .setContentText("Tap to open app • Swipe to dismiss")
            .setSmallIcon(android.R.drawable.ic_menu_camera)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .build()
    }

    private fun showFloatingButton() {
        if (floatingButton != null) return

        val layoutParams = createLayoutParams()
        layoutParams.gravity = Gravity.TOP or Gravity.START
        layoutParams.x = 0
        layoutParams.y = 300

        // Create floating button programmatically
        floatingButton = createFloatingButtonView()
        floatingButton?.setOnTouchListener(FloatingButtonTouchListener(layoutParams))

        windowManager?.addView(floatingButton, layoutParams)
    }

    private fun createFloatingButtonView(): View {
        val context = this

        // Main container
        val container = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            setBackgroundResource(android.R.color.transparent)
        }

        // Floating action button
        val fab = ImageView(context).apply {
            setImageResource(android.R.drawable.ic_menu_add)
            setBackgroundColor(0xFF6366F1.toInt()) // Primary color
            setPadding(24, 24, 24, 24)

            // Make it circular with elevation
            background = android.graphics.drawable.GradientDrawable().apply {
                shape = android.graphics.drawable.GradientDrawable.OVAL
                setColor(0xFF6366F1.toInt())
            }

            layoutParams = LinearLayout.LayoutParams(140, 140)

            setOnClickListener {
                toggleMenu()
            }
        }

        container.addView(fab)
        return container
    }

    private fun toggleMenu() {
        if (isMenuExpanded) {
            hideMenu()
        } else {
            showMenu()
        }
    }

    private fun showMenu() {
        if (expandedMenu != null) return

        isMenuExpanded = true

        val layoutParams = createLayoutParams()
        layoutParams.gravity = Gravity.CENTER

        expandedMenu = createMenuView()
        windowManager?.addView(expandedMenu, layoutParams)
    }

    private fun createMenuView(): View {
        val context = this

        // Semi-transparent background
        val overlay = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            setBackgroundColor(0xCC000000.toInt())
            gravity = Gravity.CENTER
            setPadding(48, 48, 48, 48)

            setOnClickListener {
                hideMenu()
            }
        }

        // Menu container
        val menuContainer = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            setBackgroundColor(0xFF1E293B.toInt()) // Surface color
            setPadding(32, 32, 32, 32)

            background = android.graphics.drawable.GradientDrawable().apply {
                cornerRadius = 32f
                setColor(0xFF1E293B.toInt())
            }
        }

        // Menu title
        val title = android.widget.TextView(context).apply {
            text = "Quick Capture"
            textSize = 18f
            setTextColor(0xFFF8FAFC.toInt())
            setPadding(0, 0, 0, 32)
            gravity = Gravity.CENTER
        }
        menuContainer.addView(title)

        // Menu options
        val options = listOf(
            Triple("Screenshot", android.R.drawable.ic_menu_gallery, "screenshot"),
            Triple("Photo", android.R.drawable.ic_menu_camera, "photo"),
            Triple("Voice", android.R.drawable.ic_btn_speak_now, "voice"),
            Triple("Link", android.R.drawable.ic_menu_share, "link")
        )

        for ((label, icon, action) in options) {
            val button = createMenuButton(label, icon) {
                onMenuAction(action)
            }
            menuContainer.addView(button)
        }

        // Close button
        val closeButton = createMenuButton("Close", android.R.drawable.ic_menu_close_clear_cancel) {
            hideMenu()
        }
        menuContainer.addView(closeButton)

        overlay.addView(menuContainer)
        return overlay
    }

    private fun createMenuButton(label: String, iconRes: Int, onClick: () -> Unit): View {
        val context = this

        return LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(24, 24, 24, 24)

            background = android.graphics.drawable.GradientDrawable().apply {
                cornerRadius = 16f
                setColor(0xFF334155.toInt()) // Surface light
            }

            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                setMargins(0, 8, 0, 8)
            }

            val icon = ImageView(context).apply {
                setImageResource(iconRes)
                layoutParams = LinearLayout.LayoutParams(48, 48)
            }
            addView(icon)

            val text = android.widget.TextView(context).apply {
                this.text = label
                textSize = 16f
                setTextColor(0xFFF8FAFC.toInt())
                setPadding(24, 0, 0, 0)
            }
            addView(text)

            setOnClickListener { onClick() }
        }
    }

    private fun hideMenu() {
        expandedMenu?.let {
            windowManager?.removeView(it)
            expandedMenu = null
        }
        isMenuExpanded = false
    }

    private fun onMenuAction(action: String) {
        hideMenu()

        if (action == "screenshot") {
            // For screenshot, capture FIRST, then bring app to foreground with the data
            // Hide the floating button during capture so it's not in the screenshot
            floatingButton?.visibility = View.GONE

            // Small delay to ensure UI is hidden
            Handler(Looper.getMainLooper()).postDelayed({
                captureScreenshot()
            }, 100)
        } else {
            // For other actions (photo, voice, link), bring app to foreground
            val intent = Intent(this, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                putExtra("overlay_action", action)
            }
            startActivity(intent)
        }
    }

    private fun captureScreenshot() {
        // Check if ScreenCaptureService is ready
        if (!ScreenCaptureService.isReady()) {
            // Service not ready - need to request permission through MainActivity
            floatingButton?.visibility = View.VISIBLE
            val intent = Intent(this, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                putExtra("overlay_action", "screenshot")
            }
            startActivity(intent)
            return
        }

        // Set callback to receive the captured image
        ScreenCaptureService.captureCallback = { base64Image ->
            Handler(Looper.getMainLooper()).post {
                // Show floating button again
                floatingButton?.visibility = View.VISIBLE

                if (base64Image != null) {
                    // Store image in static variable (too large for Intent extras)
                    ScreenCaptureService.lastCapturedScreenshot = base64Image

                    // Bring app to foreground - it will retrieve the image from static var
                    val intent = Intent(this, MainActivity::class.java).apply {
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                        putExtra("overlay_action", "screenshot_captured")
                    }
                    startActivity(intent)
                } else {
                    // Capture failed - notify user somehow (could show a toast)
                }
            }
        }

        // Trigger the capture
        val captureIntent = Intent(this, ScreenCaptureService::class.java).apply {
            action = ScreenCaptureService.ACTION_CAPTURE
        }
        startService(captureIntent)
    }

    private fun hideFloatingButton() {
        hideMenu()

        floatingButton?.let {
            windowManager?.removeView(it)
            floatingButton = null
        }
    }

    private fun createLayoutParams(): WindowManager.LayoutParams {
        val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            @Suppress("DEPRECATION")
            WindowManager.LayoutParams.TYPE_PHONE
        }

        return WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            type,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )
    }

    private inner class FloatingButtonTouchListener(
        private val params: WindowManager.LayoutParams
    ) : View.OnTouchListener {

        override fun onTouch(view: View, event: MotionEvent): Boolean {
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x
                    initialY = params.y
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                    return true
                }
                MotionEvent.ACTION_MOVE -> {
                    params.x = initialX + (event.rawX - initialTouchX).toInt()
                    params.y = initialY + (event.rawY - initialTouchY).toInt()
                    windowManager?.updateViewLayout(floatingButton, params)
                    return true
                }
                MotionEvent.ACTION_UP -> {
                    val deltaX = event.rawX - initialTouchX
                    val deltaY = event.rawY - initialTouchY

                    // If it's a click (not a drag)
                    if (Math.abs(deltaX) < 10 && Math.abs(deltaY) < 10) {
                        toggleMenu()
                    }
                    return true
                }
            }
            return false
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        hideFloatingButton()
        isRunning = false
    }
}
