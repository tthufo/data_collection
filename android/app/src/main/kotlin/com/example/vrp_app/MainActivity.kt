package com.vmg.vrp_app

import android.app.Activity
import android.app.AlertDialog
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import vn.vmg.ocr.OcrSdkSetting
import vn.vmg.ocr.ui.OcrSdk
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileInputStream
import java.io.FileNotFoundException


class MainActivity: FlutterActivity() {
    private val CHANNEL = "vmg.ekyc/VRP";
    private lateinit var channel: MethodChannel
    private var VRPResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        callForVRP(flutterEngine)
    }

    private fun callForVRP(flutterEngine: FlutterEngine) {
        channel = MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            var argument = call.arguments() as Map<String, String>;
            var option = argument["option"];
            if (call.method == "VRP") {
                VRPResult = result
                val ocrSdk = Intent(this, OcrSdk::class.java)
                ocrSdk.putExtra(OcrSdkSetting.OcrKey.KEY_VERSION, option?.toIntOrNull())
                startActivityForResult(ocrSdk, OcrSdkSetting.OcrRequest.REQUEST_OCR, null)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == OcrSdkSetting.OcrRequest.REQUEST_OCR) {
                if (data != null) {
                    val resultData = data.getStringExtra(OcrSdkSetting.OcrKey.KEY_RESULT)
                    if (resultData != null) {
                        try {
                            val resultObj = JSONObject(resultData)
                            val frontImage = resultObj.getString("front_image")
                            val backImage = resultObj.getString("back_image")
                            val faceImage = resultObj.getString("face_image")
                            val match = resultObj.getString("match")
                            val percentage = resultObj.getString("percentage")
                            val result = resultObj.getJSONObject("face_item")
                            result.put("match", match)
                            result.put("percentage", percentage)
                            resultObj.put("front_image", encodeImage(frontImage))
                            resultObj.put("back_image", encodeImage(backImage))
                            resultObj.put("face_image", encodeImage(faceImage))
                            VRPResult?.success(resultObj.toString())
                        } catch (t: Throwable) {
                            show(t.localizedMessage)
                            Log.e("Error", "Could not parse malformed JSON: \"$resultData\"")
                        }
                    }
                }
            }
        }
    }

    fun show(mess: String) {
        val builder = AlertDialog.Builder(this)
        builder.setTitle("Alert")
        builder.setMessage(mess)
        builder.setPositiveButton(android.R.string.yes) { dialog, which ->
            Toast.makeText(applicationContext,
                    android.R.string.yes, Toast.LENGTH_SHORT).show()
        }
        builder.show()
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String?>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    private fun encodeImage(path: String): String? {
        val imagefile = File(path)
        var fis: FileInputStream? = null
        try {
            fis = FileInputStream(imagefile)
        } catch (e: FileNotFoundException) {
            e.printStackTrace()
        }
        val bm = BitmapFactory.decodeStream(fis)
        val baos = ByteArrayOutputStream()
        bm.compress(Bitmap.CompressFormat.JPEG, 80, baos)
        val b = baos.toByteArray()
        return Base64.encodeToString(b, Base64.DEFAULT).replace("\n", "", false)
    }
}
