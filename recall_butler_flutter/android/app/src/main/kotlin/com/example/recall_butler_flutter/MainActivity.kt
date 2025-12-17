package com.example.recall_butler_flutter

import android.content.Context
import android.content.Intent
import android.media.projection.MediaProjectionManager
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.recallbutler/overlay"
    private var methodChannel: MethodChannel? = null
    private var pendingScreenCaptureResult: MethodChannel.Result? = null
    private var pendingCaptureAfterPermission = false

    private val projectionManager: MediaProjectionManager by lazy {
        getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
    }

    companion object {
        private const val OVERLAY_PERMISSION_REQUEST = 1001
        var instance: MainActivity? = null
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        instance = this

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        // Handle overlay action from initial launch intent
        Handler(Looper.getMainLooper()).postDelayed({
            handleOverlayIntent(intent)
        }, 500)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPermission" -> {
                    result.success(checkOverlayPermission())
                }
                "requestPermission" -> {
                    requestOverlayPermission()
                    result.success(true)
                }
                "showOverlay" -> {
                    val success = showOverlay()
                    result.success(success)
                }
                "hideOverlay" -> {
                    val success = hideOverlay()
                    result.success(success)
                }
                "isOverlayVisible" -> {
                    result.success(OverlayService.isRunning)
                }
                "requestScreenCapturePermission" -> {
                    pendingScreenCaptureResult = result
                    requestScreenCapturePermission()
                }
                "hasScreenCapturePermission" -> {
                    result.success(ScreenCaptureService.hasPermission())
                }
                "captureScreen" -> {
                    // Check if we have permission first
                    if (!ScreenCaptureService.hasPermission()) {
                        // Need to request permission first
                        pendingScreenCaptureResult = result
                        pendingCaptureAfterPermission = true
                        requestScreenCapturePermission()
                    } else {
                        // Already have permission, capture directly
                        performScreenCapture(result)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun requestScreenCapturePermission() {
        val intent = projectionManager.createScreenCaptureIntent()
        startActivityForResult(intent, ScreenCaptureService.REQUEST_CODE)
    }

    private fun checkOverlayPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(this)
        } else {
            true
        }
    }

    private fun requestOverlayPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivityForResult(intent, OVERLAY_PERMISSION_REQUEST)
        }
    }

    private fun showOverlay(): Boolean {
        if (!checkOverlayPermission()) {
            return false
        }

        val intent = Intent(this, OverlayService::class.java)
        intent.action = OverlayService.ACTION_SHOW

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
        return true
    }

    private fun hideOverlay(): Boolean {
        val intent = Intent(this, OverlayService::class.java)
        intent.action = OverlayService.ACTION_HIDE
        startService(intent)
        return true
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleOverlayIntent(intent)
    }

    private fun handleOverlayIntent(intent: Intent?) {
        val action = intent?.getStringExtra("overlay_action")
        if (action != null) {
            // Clear the extra to prevent re-triggering
            intent.removeExtra("overlay_action")

            if (action == "screenshot_captured") {
                // Screenshot was already captured - get from static variable
                val screenshotData = ScreenCaptureService.lastCapturedScreenshot
                ScreenCaptureService.lastCapturedScreenshot = null // Clear after use

                if (screenshotData != null) {
                    // Send to Flutter with the captured data
                    Handler(Looper.getMainLooper()).postDelayed({
                        methodChannel?.invokeMethod("onScreenshotCaptured", screenshotData)
                    }, 300)
                }
            } else {
                // Notify Flutter after a short delay to ensure channel is ready
                Handler(Looper.getMainLooper()).postDelayed({
                    methodChannel?.invokeMethod("onOverlayAction", action)
                }, 300)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            OVERLAY_PERMISSION_REQUEST -> {
                // Notify Flutter about permission result
                methodChannel?.invokeMethod("onPermissionResult", checkOverlayPermission())
            }
            ScreenCaptureService.REQUEST_CODE -> {
                // Store the permission result
                ScreenCaptureService.setPermissionResult(resultCode, data)

                if (resultCode == android.app.Activity.RESULT_OK) {
                    // Permission granted - initialize the service so it's ready
                    val initIntent = Intent(this, ScreenCaptureService::class.java).apply {
                        action = ScreenCaptureService.ACTION_INIT
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(initIntent)
                    } else {
                        startService(initIntent)
                    }

                    if (pendingCaptureAfterPermission && pendingScreenCaptureResult != null) {
                        // Perform the capture after service initializes
                        pendingCaptureAfterPermission = false
                        val result = pendingScreenCaptureResult!!
                        pendingScreenCaptureResult = null
                        Handler(Looper.getMainLooper()).postDelayed({
                            performScreenCapture(result)
                        }, 500)
                    } else {
                        pendingScreenCaptureResult?.success(true)
                        pendingScreenCaptureResult = null
                    }
                } else {
                    // Permission denied
                    pendingCaptureAfterPermission = false
                    pendingScreenCaptureResult?.error("PERMISSION_DENIED", "Screen capture permission denied", null)
                    pendingScreenCaptureResult = null
                }
            }
        }
    }

    private fun performScreenCapture(result: MethodChannel.Result) {
        // Hide overlay first
        hideOverlay()

        // Set the callback before starting the service
        ScreenCaptureService.captureCallback = { base64Image ->
            Handler(Looper.getMainLooper()).post {
                if (base64Image != null) {
                    result.success(base64Image)
                } else {
                    result.error("CAPTURE_FAILED", "Failed to capture screen", null)
                }
                // Show overlay again after capture
                showOverlay()
            }
        }

        // Check if service is already running
        if (ScreenCaptureService.isRunning) {
            // Just send capture command
            val captureIntent = Intent(this, ScreenCaptureService::class.java).apply {
                action = ScreenCaptureService.ACTION_CAPTURE
            }
            startService(captureIntent)
        } else {
            // Initialize the service first, then capture
            val initIntent = Intent(this, ScreenCaptureService::class.java).apply {
                action = ScreenCaptureService.ACTION_INIT
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(initIntent)
            } else {
                startService(initIntent)
            }
            // After init, send capture command with small delay
            Handler(Looper.getMainLooper()).postDelayed({
                val captureIntent = Intent(this, ScreenCaptureService::class.java).apply {
                    action = ScreenCaptureService.ACTION_CAPTURE
                }
                startService(captureIntent)
            }, 300)
        }
    }

    // Called from OverlayService when user taps an action
    fun onOverlayAction(action: String) {
        methodChannel?.invokeMethod("onOverlayAction", action)
    }

    override fun onDestroy() {
        super.onDestroy()
        instance = null
    }
}
