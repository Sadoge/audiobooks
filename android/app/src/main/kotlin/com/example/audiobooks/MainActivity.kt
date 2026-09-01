package com.example.audiobooks

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Hosts Flutter inside audio_service's activity, which is what lets a
 * notification or a lock-screen control reach a running player rather than
 * starting a second one.
 *
 * It also answers for the one thing the plugin cannot ask on its own. From
 * Android 13 the playback notification needs the listener's permission, and
 * the lock-screen controls are that same notification, so without it a book
 * plays but shows up nowhere. Only an activity can raise the system's sheet,
 * so the app asks through here the first time a book is opened.
 */
class MainActivity : AudioServiceActivity() {
    private var pendingPermission: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "ensureGranted" -> ensureNotificationPermission(result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun ensureNotificationPermission(result: MethodChannel.Result) {
        // Before Android 13 the permission came with the install.
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            result.success(true)
            return
        }
        if (checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            result.success(true)
            return
        }
        // A sheet is already up; the answer it gets will be the answer.
        if (pendingPermission != null) {
            result.success(false)
            return
        }
        pendingPermission = result
        requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), REQUEST_CODE)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != REQUEST_CODE) return
        val result = pendingPermission ?: return
        pendingPermission = null
        result.success(
            grantResults.isNotEmpty() &&
                grantResults[0] == PackageManager.PERMISSION_GRANTED,
        )
    }

    private companion object {
        const val CHANNEL = "audiobooks/playback_notification"

        /** Ours alone, so a plugin's own request is never mistaken for it. */
        const val REQUEST_CODE = 6821
    }
}
