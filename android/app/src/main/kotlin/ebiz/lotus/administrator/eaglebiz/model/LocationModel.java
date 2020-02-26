package ebiz.lotus.administrator.eaglebiz.model;

public class LocationModel {
    String deviceId,date;
    String latitude,longitude,battery;

    public LocationModel(){

    }

    public LocationModel( String device_id, String lati, String longi,String battery, String creadted_date) {
        this.deviceId=device_id;
        this.latitude=lati;
        this.longitude=longi;
        this.battery=battery;
        this.date=creadted_date;

    }

    public String getBattery() {
        return battery;
    }

    public void setBattery(String battery) {
        this.battery = battery;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }
}