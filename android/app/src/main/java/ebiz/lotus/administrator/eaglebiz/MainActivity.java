package ebiz.lotus.administrator.eaglebiz;

import android.os.Bundle;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.microsoft.appcenter.AppCenter;
import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.crashes.Crashes;

public class MainActivity extends FlutterActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    AppCenter.start(getApplication(), "f56ca720-90e4-4964-92a4-10c291e68a86", Analytics.class, Crashes.class);
    // startAlert();
  }

  // public void startAlert() {
  //   Intent intent = new Intent(this, MyBroadcastReceiver.class);
  //   PendingIntent pendingIntent = PendingIntent.getBroadcast(this.getApplicationContext(), 234, intent, 0);
  //   AlarmManager alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);
    
  //   alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP, System.currentTimeMillis(),1*60*1000, pendingIntent);

  // }

}