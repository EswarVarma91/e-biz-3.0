package com.example.eaglebiz;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterView;

public class MainActivity extends FlutterActivity {

  private PendingIntent pendingIntent;
  private AlarmManager alarmManager;
  private static  FlutterView flutterView;
  private static final String CHANNEL = "com.tarazgroup";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    Intent intent = new Intent(this, MyReceiver.class);
        pendingIntent = PendingIntent.getBroadcast(this, 1019662, intent, 0);
        alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);
        alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP, System.currentTimeMillis(), 1000, pendingIntent);

  }

  @Override
  protected void onDestroy() {
      super.onDestroy();
      alarmManager.cancel(pendingIntent);
  }

  static void callFlutter(){
      MethodChannel methodChannel=new MethodChannel(flutterView, CHANNEL);
      methodChannel.invokeMethod("I say hello every minute!!","");
  }
}
