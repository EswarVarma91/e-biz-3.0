package ebiz.lotus.administrator.eaglebiz;

import android.os.Bundle;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import io.flutter.app.FlutterActivity;
import android.widget.Toast;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.microsoft.appcenter.AppCenter;
import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.crashes.Crashes;

public class MainActivity extends FlutterActivity {
  AlarmManager alarmManager;
  PendingIntent pendingIntent;
  BroadcastReceiver mReceiver;
  int counter=0;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    AppCenter.start(getApplication(), "f56ca720-90e4-4964-92a4-10c291e68a86", Analytics.class, Crashes.class);
    RegisterAlarmBroadcast();
    alarmManager.setRepeating(AlarmManger.RTC_WAKEUP, System.currentTimeMillis(), 15 * 60 * 1000, pendingIntent);
  }

  private void RegisterAlarmBroadcast() {
    mReceiver = new BroadcastReceiver() {
      // private static final String TAG = "Alarm Example Receiver";
      @Override
      public void onReceive(Context context, Intent intent) {
        counter++;
        Toast.makeText(context, "Background Service Started "+counter, Toast.LENGTH_LONG).show();
      }
    };

    registerReceiver(mReceiver, new IntentFilter("sample"));
    pendingIntent = PendingIntent.getBroadcast(this, 0, new Intent("sample"), 0);
    alarmManager = (AlarmManager) (this.getSystemService(Context.ALARM_SERVICE));
  }

  private void UnregisterAlarmBroadcast() {
    alarmManager.cancel(pendingIntent);
    getBaseContext().unregisterReceiver(mReceiver);
  }

  @Override
  protected void onDestroy() {
    unregisterReceiver(mReceiver);
    super.onDestroy();
  }
}