package com.example.kifiya_rendering_engine

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream

class KifiyaRenderingEnginePlugin :
    FlutterPlugin,
    MethodChannel.MethodCallHandler,
    ActivityAware,
    PluginRegistry.ActivityResultListener {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var pendingResult: MethodChannel.Result? = null
    private val FILE_PICKER_REQUEST_CODE = 2001

    // ───────────────────────────  ENGINE  ───────────────────────────

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "kifiya_file_picker")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // ───────────────────────────  METHOD CALLS  ───────────────────────────

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "pickFile" -> {
                val allowedTypes = call.argument<List<String>>("allowedTypes")
                openFilePicker(result, allowedTypes)
            }
            "getPlatformVersion" ->
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            else -> result.notImplemented()
        }
    }

    // ───────────────────────────  FILE PICKER  ───────────────────────────

    private fun openFilePicker(result: MethodChannel.Result, allowedTypes: List<String>?) {
        val currentActivity = activity
        if (currentActivity == null) {
            result.error("NO_ACTIVITY", "Plugin not attached to an activity", null)
            return
        }

        pendingResult = result
        val intent = Intent(Intent.ACTION_GET_CONTENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
        }

        if (!allowedTypes.isNullOrEmpty()) {
            val mimeTypes = allowedTypes.map {
                when (it.lowercase()) {
                    "jpg", "jpeg" -> "image/jpeg"
                    "png" -> "image/png"
                    "pdf" -> "application/pdf"
                    "doc", "docx" -> "application/msword"
                    "txt" -> "text/plain"
                    else -> "*/*"
                }
            }.toTypedArray()

            if (mimeTypes.size == 1) {
                intent.type = mimeTypes[0]
            } else {
                intent.putExtra(Intent.EXTRA_MIME_TYPES, mimeTypes)
            }
        }

        currentActivity.startActivityForResult(
            Intent.createChooser(intent, "Select File"),
            FILE_PICKER_REQUEST_CODE
        )
    }

    // ───────────────────────────  ACTIVITY RESULT  ───────────────────────────

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == FILE_PICKER_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                val uri: Uri? = data?.data
                if (uri != null) {
                    val realPath = getRealPathFromURI(uri)
                    pendingResult?.success(realPath ?: uri.toString())
                } else {
                    pendingResult?.success(null)
                }
            } else {
                pendingResult?.success(null)
            }
            pendingResult = null
            return true
        }
        return false
    }

    // ───────────────────────────  URI → PATH  ───────────────────────────

    private fun getRealPathFromURI(uri: Uri): String? {
        val resolver = activity?.contentResolver ?: return null

        // Direct file:// URIs
        if (uri.scheme.equals("file", ignoreCase = true)) {
            return uri.path
        }

        // Try reading from MediaStore for legacy media URIs
        if (uri.scheme.equals("content", ignoreCase = true)) {
            val projection = arrayOf(MediaStore.Images.Media.DATA)
            try {
                resolver.query(uri, projection, null, null, null)?.use { cursor ->
                    val columnIndex =
                        cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
                    if (cursor.moveToFirst()) {
                        val path = cursor.getString(columnIndex)
                        if (!path.isNullOrEmpty()) return path
                    }
                }
            } catch (_: Exception) {
                // ignore, will fall back
            }
        }

        // Scoped storage fallback: copy content to app cache
        return copyUriToCache(uri)
    }

    private fun copyUriToCache(uri: Uri): String? {
        val act = activity ?: return null
        return try {
            val inputStream: InputStream = act.contentResolver.openInputStream(uri) ?: return null
            val file = File(act.cacheDir, "picked_${System.currentTimeMillis()}")
            val outputStream = FileOutputStream(file)
            inputStream.copyTo(outputStream)
            inputStream.close()
            outputStream.close()
            file.absolutePath
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    // ───────────────────────────  ACTIVITY AWARE  ───────────────────────────

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
