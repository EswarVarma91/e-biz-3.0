package ebiz.lotus.administrator.eaglebiz;

import android.location.Location;
import android.location.LocationListener;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import java.text.SimpleDateFormat;
import java.util.TimeZone;

public class GeoListener implements LocationListener {
    @Override
    public void onLocationChanged(Location location) {
        String provider = location.getProvider();
        float acc = location.getAccuracy();
        double lat = location.getLatitude();
        double longi = location.getLongitude();
        long time = location.getTime();
        String pattern = "dd/MM/yyyy HH:mm:ss";

        SimpleDateFormat sdf = new SimpleDateFormat();
        sdf.setTimeZone(TimeZone.getTimeZone(pattern));
        String stime = sdf.format(time);

        Log.d("eskoData",String.format("[%s] Location by %s; (%f,%f) +/- %f meters",stime,provider,lat,longi,acc));
    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {
        Log.d("onStatusChanged",provider + " "+ status+ " "+extras );
    }

    @Override
    public void onProviderEnabled(String provider) {
        Log.d("onProviderEnabled",provider);
    }

    @Override
    public void onProviderDisabled(String provider) {
        Log.d("onProviderDisabled",provider );
    }
}
