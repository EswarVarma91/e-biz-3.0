package com.example.eaglebiz;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

class MyService extends BroadcastReceiver {
    public MyService() {
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        MainActivity.callFlutter();
    }
}
