package com.example.recall_butler_flutter

import android.app.Activity
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.PixelFormat
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.Image
import android.media.ImageReader
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Base64
import android.util.DisplayMetrics
import android.view.WindowManager
import androidx.core.app.NotificationCompat
import java.io.ByteArrayOutputStream

class ScreenCaptureService : Service() {

    companion object {
        const val ACTION_INIT = "INIT_PROJECTION"
        const val ACTION_CAPTURE = "CAPTURE_SCREEN"
        const val ACTION_STOP = "STOP_SERVICE"
        const val CHANNEL_ID = "screen_capture_channel"
        const val NOTIFICATION_ID = 2001
        const val REQUEST_CODE = 1002

        private var mediaProjection: MediaProjection? = null
        var captureCallback: ((String?) -> Unit)? = null
        private var projectionIntent: Intent? = null
        private var resultCode: Int = 0
        var isRunning = false

        var instance: ScreenCaptureService? = null

        // Store captured screenshot data here (too large for Intent extras)
        var lastCapturedScreenshot: String? = null

        fun hasPermission(): Boolean {
            return projectionIntent != null && resultCode != 0
        }

        fun isReady(): Boolean {
            return isRunning && mediaProjection != null &&
                   instance?.virtualDisplay != null && instance?.imageReader != null
        }

        fun setPermissionResult(code: Int, data: Intent?) {
            if (code == Activity.RESULT_OK && data != null) {
                resultCode = code
                projectionIntent = data
            }
        }
    }

    private val projectionManager: MediaProjectionManager by lazy {
        getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
    }

    private var virtualDisplay: VirtualDisplay? = null
    private var imageReader: ImageReader? = null
    private var screenWidth = 0
    private var screenHeight = 0
    private var screenDensity = 0

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        instance = this
        createNotificationChannel()

        // Get display metrics once
        val windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val metrics = DisplayMetrics()
        windowManager.defaultDisplay.getRealMetrics(metrics)
        screenWidth = metrics.widthPixels
        screenHeight = metrics.heightPixels
        screenDensity = metrics.densityDpi
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_INIT -> {
                // Start foreground and initialize MediaProjection (keep running)
                startForeground(NOTIFICATION_ID, createNotification("Ready to capture"))
                initializeProjection()
                isRunning = true
            }
            ACTION_CAPTURE -> {
                // Just capture, don't stop service
                performCapture()
            }
            ACTION_STOP -> {
                cleanup()
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
                "Screen Capture",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Enables quick screenshots from overlay"
                setShowBadge(false)
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(text: String): Notification {
        val stopIntent = Intent(this, ScreenCaptureService::class.java).apply {
            action = ACTION_STOP
        }
        val stopPendingIntent = PendingIntent.getService(
            this, 0, stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Recall Butler")
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_menu_camera)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .addAction(android.R.drawable.ic_menu_close_clear_cancel, "Stop", stopPendingIntent)
            .build()
    }

    private fun initializeProjection() {
        if (projectionIntent == null || resultCode == 0) {
            return
        }

        try {
            // Create MediaProjection once and keep it
            mediaProjection = projectionManager.getMediaProjection(resultCode, projectionIntent!!)

            mediaProjection?.registerCallback(object : MediaProjection.Callback() {
                override fun onStop() {
                    cleanup()
                    isRunning = false
                    stopSelf()
                }
            }, Handler(Looper.getMainLooper()))

            // Create ImageReader and VirtualDisplay once and keep them running
            // This avoids the "Don't call createVirtualDisplay multiple times" error
            imageReader = ImageReader.newInstance(screenWidth, screenHeight, PixelFormat.RGBA_8888, 2)

            virtualDisplay = mediaProjection?.createVirtualDisplay(
                "ScreenCapture",
                screenWidth,
                screenHeight,
                screenDensity,
                DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
                imageReader?.surface,
                null,
                null
            )

        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun performCapture() {
        if (mediaProjection == null || virtualDisplay == null || imageReader == null) {
            // Not ready - need to initialize first
            captureCallback?.invoke(null)
            return
        }

        // Capture after a short delay to ensure latest frame is available
        Handler(Looper.getMainLooper()).postDelayed({
            captureImage()
        }, 150)
    }

    private fun captureImage() {
        try {
            val image = imageReader?.acquireLatestImage()
            if (image != null) {
                val bitmap = imageToBitmap(image)
                image.close()

                val base64 = bitmapToBase64(bitmap)
                bitmap.recycle()

                // Don't clean up - keep VirtualDisplay running for future captures
                captureCallback?.invoke(base64)
            } else {
                // Retry once - image might not be ready yet
                Handler(Looper.getMainLooper()).postDelayed({
                    val retryImage = imageReader?.acquireLatestImage()
                    if (retryImage != null) {
                        val bitmap = imageToBitmap(retryImage)
                        retryImage.close()
                        val base64 = bitmapToBase64(bitmap)
                        bitmap.recycle()
                        captureCallback?.invoke(base64)
                    } else {
                        captureCallback?.invoke(null)
                    }
                }, 150)
            }
        } catch (e: Exception) {
            e.printStackTrace()
            captureCallback?.invoke(null)
        }
    }

    private fun imageToBitmap(image: Image): Bitmap {
        val planes = image.planes
        val buffer = planes[0].buffer
        val pixelStride = planes[0].pixelStride
        val rowStride = planes[0].rowStride
        val rowPadding = rowStride - pixelStride * image.width

        val bitmap = Bitmap.createBitmap(
            image.width + rowPadding / pixelStride,
            image.height,
            Bitmap.Config.ARGB_8888
        )
        bitmap.copyPixelsFromBuffer(buffer)

        return Bitmap.createBitmap(bitmap, 0, 0, image.width, image.height)
    }

    private fun bitmapToBase64(bitmap: Bitmap): String {
        // Scale down the bitmap to reduce size (max 1080px width)
        val scaledBitmap = if (bitmap.width > 1080) {
            val scale = 1080f / bitmap.width
            val newHeight = (bitmap.height * scale).toInt()
            Bitmap.createScaledBitmap(bitmap, 1080, newHeight, true)
        } else {
            bitmap
        }

        val outputStream = ByteArrayOutputStream()
        // Use lower quality (50) to keep under server limit
        scaledBitmap.compress(Bitmap.CompressFormat.JPEG, 50, outputStream)

        if (scaledBitmap != bitmap) {
            scaledBitmap.recycle()
        }

        val bytes = outputStream.toByteArray()
        return Base64.encodeToString(bytes, Base64.NO_WRAP)
    }

    private fun cleanup() {
        virtualDisplay?.release()
        virtualDisplay = null
        imageReader?.close()
        imageReader = null
        mediaProjection?.stop()
        mediaProjection = null
        projectionIntent = null
        resultCode = 0
    }

    override fun onDestroy() {
        super.onDestroy()
        cleanup()
        isRunning = false
        instance = null
    }
}
