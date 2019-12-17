package ebiz.lotus.administrator.eaglebiz

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import androidx.lifecycle.LifecycleRegistry
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import androidx.lifecycle.Lifecycle



class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
//        AppCenter.start(application, "f56ca720-90e4-4964-92a4-10c291e68a86", Analytics::class.java, Crashes::class.java)
    }
}
